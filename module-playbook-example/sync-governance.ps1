<#
.SYNOPSIS
  Synchronises Oqtane AI governance files into a solution without removing anything.

.DESCRIPTION
  - Adds missing governance file references to .slnx
  - Ensures required governance files physically exist
  - Never deletes solution content
  - Supports DryRun and Verbose output

.PARAMETER SolutionPath
  Path to the .slnx solution file (or directory containing it).

.PARAMETER DryRun
  Shows what would change without modifying files.

.PARAMETER Help
  Displays this help text.

.EXAMPLE
  ./sync-governance.ps1 -SolutionPath "D:\MySolution\MySolution.slnx"

.EXAMPLE
  ./sync-governance.ps1 -SolutionPath "D:\MySolution" -DryRun -Verbose

.EXAMPLE
  ./sync-governance.ps1 -Help
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string] $SolutionPath,
    
    [switch] $DryRun,
    [switch] $Help
)

if ($Help) {
    Get-Help $MyInvocation.MyCommand.Path -Detailed
    return
}

$ErrorActionPreference = "Stop"
$Changes = @()

Write-Verbose "Starting governance sync"

# ------------------------------------------------------------
# Paths - SCRIPT LOCATION IS THE PLAYBOOK ROOT
# ------------------------------------------------------------

# The script is located in the playbook root (module-playbook-example)
$PlaybookRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Verbose "PlaybookRoot: $PlaybookRoot"

# Verify the playbook root exists (it should since we're running from here)
if (-not (Test-Path $PlaybookRoot)) {
    throw "Playbook directory not found at script location: $PlaybookRoot"
}

# ------------------------------------------------------------
# Find and validate solution file - FIXED PATH VALIDATION
# ------------------------------------------------------------

# Clean up the path first
$SolutionPath = $SolutionPath.Trim()

# Check if path exists at all
if (-not (Test-Path $SolutionPath)) {
    throw "Solution path not found: $SolutionPath"
}

# Determine if it's a directory or file
$item = Get-Item $SolutionPath -ErrorAction SilentlyContinue
if (-not $item) {
    throw "Cannot access solution path: $SolutionPath"
}

if ($item.PSIsContainer) {
    # It's a directory, look for .slnx file in it
    Write-Verbose "Looking for .slnx file in directory: $SolutionPath"
    $slnx = Get-ChildItem -Path $SolutionPath -Filter *.slnx | Select-Object -First 1
    if (-not $slnx) {
        throw "No .slnx file found in directory: $SolutionPath"
    }
} else {
    # It's a file, check it's a .slnx file
    if ([System.IO.Path]::GetExtension($SolutionPath) -ne '.slnx') {
        throw "Specified file is not a .slnx file: $SolutionPath"
    }
    $slnx = $item
}

# Get the solution root directory
$SolutionRoot = $slnx.DirectoryName
Write-Verbose "Solution root: $SolutionRoot"
Write-Verbose "Solution file: $($slnx.Name)"

# ------------------------------------------------------------
# Load solution XML
# ------------------------------------------------------------

[xml]$xml = Get-Content $slnx.FullName
$solutionNode = $xml.Solution

# ------------------------------------------------------------
# Helpers
# ------------------------------------------------------------

function Get-OrCreateFolderNode {
    param (
        [string] $Name
    )

    $node = $solutionNode.Folder | Where-Object { $_.Name -eq $Name }
    if ($node) { return $node }

    Write-Verbose "Creating solution folder: $Name"
    if (-not $DryRun) {
        $node = $xml.CreateElement("Folder")
        $node.SetAttribute("Name", $Name)
        $solutionNode.AppendChild($node) | Out-Null
    }

    $script:Changes += "Add folder: $Name"
    return $node
}

function Ensure-FileReference {
    param (
        [System.Xml.XmlElement] $FolderNode,
        [string] $Path
    )

    # Check if file already referenced
    if ($FolderNode.File | Where-Object { $_.Path -eq $Path }) {
        return
    }

    Write-Verbose "Adding file reference: $Path"

    if (-not $DryRun) {
        $fileNode = $xml.CreateElement("File")
        $fileNode.SetAttribute("Path", $Path)
        $FolderNode.AppendChild($fileNode) | Out-Null
    }

    $script:Changes += "Reference file: $Path"
}

function Ensure-PhysicalFile {
    param (
        [string] $RelativePath
    )

    $source = Join-Path $PlaybookRoot $RelativePath
    $target = Join-Path $SolutionRoot $RelativePath

    if (Test-Path $target) {
        Write-Verbose "File exists: $RelativePath"
        return $true
    }

    if (-not (Test-Path $source)) {
        Write-Warning "Playbook source missing: $RelativePath"
        return $false
    }

    Write-Verbose "Materialising governance file: $RelativePath"

    if (-not $DryRun) {
        $targetDir = Split-Path $target -Parent
        if (-not (Test-Path $targetDir)) {
            New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        }
        Copy-Item $source $target -Force
    }

    $script:Changes += "Create file: $RelativePath"
    return $true
}

# ------------------------------------------------------------
# Materialised governance files (MUST exist in playbook)
# ------------------------------------------------------------

$MaterialisedFiles = @(
    "docs/deviations.md",
    "docs/ai-decision-timeline.md",
    ".github/module-instructions.md"  # This one needs to be materialized
)

$MaterialisedFilesCreated = @()

foreach ($file in $MaterialisedFiles) {
    $created = Ensure-PhysicalFile -RelativePath $file
    if ($created) {
        $MaterialisedFilesCreated += $file
    }
}

# ------------------------------------------------------------
# Add governance files to solution
# ------------------------------------------------------------

# Process docs/governance folder
$GovernanceSourcePath = Join-Path $PlaybookRoot "docs\governance"
if (Test-Path $GovernanceSourcePath) {
    $GovernanceFiles = Get-ChildItem -Path $GovernanceSourcePath -File -Filter "*.md" -ErrorAction SilentlyContinue
    
    if ($GovernanceFiles.Count -gt 0) {
        Write-Verbose "Found $($GovernanceFiles.Count) governance files in playbook"
        
        # Create the governance folder in solution
        $folderNode = Get-OrCreateFolderNode -Name "/docs/governance/"
        
        foreach ($govFile in $GovernanceFiles) {
            # Use the absolute path to the playbook file
            Ensure-FileReference -FolderNode $folderNode -Path $govFile.FullName
        }
    }
}

# ------------------------------------------------------------
# Add prompt files to solution
# ------------------------------------------------------------

$PromptsSourcePath = Join-Path $PlaybookRoot "docs\prompts"
if (Test-Path $PromptsSourcePath) {
    $PromptFiles = Get-ChildItem -Path $PromptsSourcePath -File -Filter "*.md" -ErrorAction SilentlyContinue
    
    if ($PromptFiles.Count -gt 0) {
        Write-Verbose "Found $($PromptFiles.Count) prompt files in playbook"
        
        # Create the prompts folder in solution
        $promptsFolderNode = Get-OrCreateFolderNode -Name "/docs/prompts/"
        
        foreach ($promptFile in $PromptFiles) {
            # Use the absolute path to the playbook file
            Ensure-FileReference -FolderNode $promptsFolderNode -Path $promptFile.FullName
        }
    }
}

# ------------------------------------------------------------
# Add dot-folders to solution
# ------------------------------------------------------------

# Find all folders in playbook that start with a dot
$DotFolders = Get-ChildItem -Path $PlaybookRoot -Directory -Filter ".*" -ErrorAction SilentlyContinue

foreach ($dotFolder in $DotFolders) {
    Write-Verbose "Processing dot-folder: $($dotFolder.Name)"
    
    # Look for ALL files in this dot-folder (including subdirectories)
    $allFiles = Get-ChildItem -Path $dotFolder.FullName -File -Recurse -ErrorAction SilentlyContinue
    
    foreach ($file in $allFiles) {
        # Skip module-instructions.md in .github folder - we'll handle it separately
        if ($dotFolder.Name -eq ".github" -and $file.Name -eq "module-instructions.md") {
            continue
        }
        
        # Get the relative path from the dot-folder root to this file
        $relativeToDotFolder = $file.FullName.Substring($dotFolder.FullName.Length + 1)
        $containingFolder = [System.IO.Path]::GetDirectoryName($relativeToDotFolder)
        
        # Build the solution folder path
        if ([string]::IsNullOrEmpty($containingFolder)) {
            $solutionFolderPath = "/$($dotFolder.Name)/"
        } else {
            $solutionFolderPath = "/$($dotFolder.Name)/$containingFolder/".Replace("\", "/")
        }
        
        # Get or create the containing folder in solution
        $fileFolderNode = Get-OrCreateFolderNode -Name $solutionFolderPath
        
        # Use the absolute path to the playbook file
        Ensure-FileReference -FolderNode $fileFolderNode -Path $file.FullName
    }
}

# ------------------------------------------------------------
# Add materialized files to solution folder (ONLY IF CREATED)
# ------------------------------------------------------------

# Create /docs/ folder for materialized files
$docsFolderNode = Get-OrCreateFolderNode -Name "/docs/"

foreach ($file in $MaterialisedFilesCreated) {
    if ($file -like "docs/*") {
        # Reference the local copy (relative path in the solution)
        Ensure-FileReference -FolderNode $docsFolderNode -Path $file
    }
}

# Add the materialized module-instructions.md to .github folder
$moduleInstructionsPath = Join-Path $SolutionRoot ".github\module-instructions.md"
if (Test-Path $moduleInstructionsPath) {
    $githubFolderNode = Get-OrCreateFolderNode -Name "/.github/"
    Ensure-FileReference -FolderNode $githubFolderNode -Path ".github/module-instructions.md"
}

# ------------------------------------------------------------
# Save solution
# ------------------------------------------------------------

if ($Changes.Count -eq 0) {
    Write-Host "Solution already compliant. No changes required."
}
else {
    Write-Host ""
    Write-Host "=== GOVERNANCE SYNC $(if ($DryRun) { '(DRY RUN)' }) ==="
    $Changes | ForEach-Object { Write-Host "* $_" }

    if (-not $DryRun) {
        $xml.Save($slnx.FullName)
        Write-Verbose "Solution file updated."
    }
}

Write-Host ""
Write-Host "Governance sync completed successfully."