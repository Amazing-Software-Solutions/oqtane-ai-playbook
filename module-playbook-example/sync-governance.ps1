<#
.SYNOPSIS
  Synchronises Oqtane AI governance files into a solution without removing anything.

.DESCRIPTION
  - Adds missing governance file references to .slnx
  - Ensures required governance files physically exist
  - Removes any references to files in module-playbook-example and replaces with materialized copies
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
# Helper function to get relative path (compatible with older .NET)
# ------------------------------------------------------------

function Get-RelativePath {
    param (
        [string] $Path,
        [string] $RelativeTo
    )
    
    # Normalize paths
    $Path = [System.IO.Path]::GetFullPath($Path)
    $RelativeTo = [System.IO.Path]::GetFullPath($RelativeTo)
    
    # Make sure RelativeTo ends with a directory separator
    if (-not $RelativeTo.EndsWith([System.IO.Path]::DirectorySeparatorChar)) {
        $RelativeTo += [System.IO.Path]::DirectorySeparatorChar
    }
    
    # Split paths into parts
    $pathParts = $Path.Split([System.IO.Path]::DirectorySeparatorChar)
    $baseParts = $RelativeTo.Split([System.IO.Path]::DirectorySeparatorChar)
    
    # Find common prefix length
    $i = 0
    while ($i -lt $baseParts.Length -and $i -lt $pathParts.Length -and $baseParts[$i] -eq $pathParts[$i]) {
        $i++
    }
    
    # Build relative path
    $relative = @()
    
    # Add ".." for each remaining part in base path
    for ($j = $i; $j -lt $baseParts.Length - 1; $j++) {  # -1 because last part is empty due to trailing slash
        $relative += ".."
    }
    
    # Add remaining parts from target path
    for ($j = $i; $j -lt $pathParts.Length; $j++) {
        $relative += $pathParts[$j]
    }
    
    # Join with forward slashes
    return ($relative -join '/')
}

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

function Remove-FileReference {
    param (
        [string] $PathPattern
    )

    $nodesToRemove = @()
    
    # Find all File nodes where Path contains the pattern
    foreach ($folder in $solutionNode.Folder) {
        foreach ($file in $folder.File) {
            if ($file.Path -like $PathPattern) {
                $nodesToRemove += [PSCustomObject]@{
                    Folder = $folder
                    File = $file
                }
            }
        }
    }

    foreach ($node in $nodesToRemove) {
        Write-Verbose "Removing file reference: $($node.File.Path)"
        if (-not $DryRun) {
            [void]$node.Folder.RemoveChild($node.File)
        }
        $script:Changes += "Remove reference: $($node.File.Path)"
    }
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
# SANITY CHECK - Remove any references to files in module-playbook-example
# ------------------------------------------------------------

Write-Verbose "Performing sanity check - removing references to playbook files"

# Remove any references to files in the module-playbook-example folder
Remove-FileReference -PathPattern "*module-playbook-example*"

# Also remove references to specific files that we're going to materialize
# This handles cases where they might be referenced from other locations
$MaterialisedFiles = @(
    "docs/deviations.md",
    "docs/ai-decision-timeline.md",
    ".github/module-instructions.md",
    ".github/copilot-instructions.md",
    ".amazonq/rules/instructions.md"
)

foreach ($file in $MaterialisedFiles) {
    # Get just the filename part for pattern matching
    $fileName = Split-Path $file -Leaf
    Remove-FileReference -PathPattern "*$fileName"
}

# ------------------------------------------------------------
# Materialised governance files (MUST exist in playbook)
# ------------------------------------------------------------

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
            # Use the relative path from solution root
            $relativePath = Get-RelativePath -Path $govFile.FullName -RelativeTo $SolutionRoot
            Ensure-FileReference -FolderNode $folderNode -Path $relativePath
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
            # Use the relative path from solution root
            $relativePath = Get-RelativePath -Path $promptFile.FullName -RelativeTo $SolutionRoot
            Ensure-FileReference -FolderNode $promptsFolderNode -Path $relativePath
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
        # Skip specific files we handle separately
        $skipFile = $false
        
        if ($dotFolder.Name -eq ".github" -and ($file.Name -eq "module-instructions.md" -or $file.Name -eq "copilot-instructions.md")) {
            $skipFile = $true
        }
        
        if ($dotFolder.Name -eq ".amazonq" -and $file.FullName -like "*\.amazonq\rules\instructions.md") {
            $skipFile = $true
        }
        
        if ($skipFile) {
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
        
        # Use the relative path from solution root
        $relativePath = Get-RelativePath -Path $file.FullName -RelativeTo $SolutionRoot
        Ensure-FileReference -FolderNode $fileFolderNode -Path $relativePath
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

# Add materialized files to their respective folders

# .github folder files
$githubFolderNode = Get-OrCreateFolderNode -Name "/.github/"

$moduleInstructionsPath = Join-Path $SolutionRoot ".github\module-instructions.md"
if (Test-Path $moduleInstructionsPath) {
    Ensure-FileReference -FolderNode $githubFolderNode -Path ".github/module-instructions.md"
}

$copilotInstructionsPath = Join-Path $SolutionRoot ".github\copilot-instructions.md"
if (Test-Path $copilotInstructionsPath) {
    Ensure-FileReference -FolderNode $githubFolderNode -Path ".github/copilot-instructions.md"
}

# .amazonq\rules folder files
$amazonqRulesFolderNode = Get-OrCreateFolderNode -Name "/.amazonq/rules/"

$amazonqInstructionsPath = Join-Path $SolutionRoot ".amazonq\rules\instructions.md"
if (Test-Path $amazonqInstructionsPath) {
    Ensure-FileReference -FolderNode $amazonqRulesFolderNode -Path ".amazonq/rules/instructions.md"
}

# ------------------------------------------------------------
# Add Oqtane project references (Client and Shared)
# ------------------------------------------------------------

Write-Host "Looking for Oqtane framework projects..."

# Look for any Oqtane.Server.csproj file in parent directories to locate framework root
$currentDir = $SolutionRoot
$maxDepth = 5
$depth = 0
$frameworkRoot = $null

while ($depth -lt $maxDepth -and -not $frameworkRoot) {
    Write-Verbose "Searching in: $currentDir"
    
    # Look for Oqtane.Server.csproj in this directory or immediate subdirectories
    $possiblePath = Join-Path $currentDir "Oqtane.Server\Oqtane.Server.csproj"
    if (Test-Path $possiblePath) {
        $frameworkRoot = $currentDir
        break
    }
    
    # Also check in subdirectories one level deep
    $subDirs = Get-ChildItem -Path $currentDir -Directory -ErrorAction SilentlyContinue
    foreach ($subDir in $subDirs) {
        $testPath = Join-Path $subDir.FullName "Oqtane.Server\Oqtane.Server.csproj"
        if (Test-Path $testPath) {
            $frameworkRoot = $subDir.FullName
            break
        }
    }
    
    if ($frameworkRoot) { break }
    
    # Move up one directory
    $currentDir = Split-Path $currentDir -Parent
    $depth++
}

if ($frameworkRoot) {
    Write-Host "Found Oqtane framework root: $frameworkRoot" -ForegroundColor Green
    
    # Calculate relative path from solution root to framework root
    $relativePath = Get-RelativePath -Path $frameworkRoot -RelativeTo $SolutionRoot
    
    Write-Host "Relative path to framework: $relativePath" -ForegroundColor Yellow
    
    # Construct Client and Shared project paths
    $clientProjectPath = "$relativePath/Oqtane.Client/Oqtane.Client.csproj"
    $sharedProjectPath = "$relativePath/Oqtane.Shared/Oqtane.Shared.csproj"
    
    # Clean up paths
    $clientProjectPath = $clientProjectPath -replace '\\', '/' -replace '//', '/'
    $sharedProjectPath = $sharedProjectPath -replace '\\', '/' -replace '//', '/'
    
    Write-Host "Client project path: $clientProjectPath" -ForegroundColor Yellow
    Write-Host "Shared project path: $sharedProjectPath" -ForegroundColor Yellow
    
    # Find which folder contains the Server project (if any)
    $serverFolder = $null
    foreach ($folder in $solutionNode.Folder) {
        $serverProjectInFolder = $folder.Project | Where-Object { $_.Path -like "*Oqtane.Server*" }
        if ($serverProjectInFolder) {
            $serverFolder = $folder
            Write-Host "Found Server project in folder: $($folder.Name)" -ForegroundColor Green
            break
        }
    }
    
    if ($serverFolder) {
        # Add Client and Shared to the same folder as Server
        Write-Host "Adding Client and Shared to existing folder: $($serverFolder.Name)" -ForegroundColor Green
        
        # Check if Client project already exists in this folder
        $existingClient = $serverFolder.Project | Where-Object { $_.Path -replace '\\', '/' -eq $clientProjectPath }
        if (-not $existingClient) {
            Write-Host "Adding Oqtane.Client project: $clientProjectPath" -ForegroundColor Green
            if (-not $DryRun) {
                $clientNode = $xml.CreateElement("Project")
                $clientNode.SetAttribute("Path", $clientProjectPath)
                
                # Add Build element with Project="false"
                $buildNode = $xml.CreateElement("Build")
                $buildNode.SetAttribute("Project", "false")
                $clientNode.AppendChild($buildNode) | Out-Null
                
                $serverFolder.AppendChild($clientNode) | Out-Null
            }
            $script:Changes += "Add project to folder $($serverFolder.Name): Oqtane.Client"
        } else {
            Write-Host "Oqtane.Client project already exists in folder" -ForegroundColor Yellow
        }
        
        # Check if Shared project already exists in this folder
        $existingShared = $serverFolder.Project | Where-Object { $_.Path -replace '\\', '/' -eq $sharedProjectPath }
        if (-not $existingShared) {
            Write-Host "Adding Oqtane.Shared project: $sharedProjectPath" -ForegroundColor Green
            if (-not $DryRun) {
                $sharedNode = $xml.CreateElement("Project")
                $sharedNode.SetAttribute("Path", $sharedProjectPath)
                
                # Add Build element with Project="false"
                $buildNode = $xml.CreateElement("Build")
                $buildNode.SetAttribute("Project", "false")
                $sharedNode.AppendChild($buildNode) | Out-Null
                
                $serverFolder.AppendChild($sharedNode) | Out-Null
            }
            $script:Changes += "Add project to folder $($serverFolder.Name): Oqtane.Shared"
        } else {
            Write-Host "Oqtane.Shared project already exists in folder" -ForegroundColor Yellow
        }
    } else {
        # No folder found, add to solution root
        Write-Host "Server project not in a folder - adding Client and Shared to solution root" -ForegroundColor Yellow
        
        # Check if Client project already exists at root
        $existingClient = $solutionNode.Project | Where-Object { $_.Path -replace '\\', '/' -eq $clientProjectPath }
        if (-not $existingClient) {
            Write-Host "Adding Oqtane.Client project: $clientProjectPath" -ForegroundColor Green
            if (-not $DryRun) {
                $clientNode = $xml.CreateElement("Project")
                $clientNode.SetAttribute("Path", $clientProjectPath)
                
                # Add Build element with Project="false"
                $buildNode = $xml.CreateElement("Build")
                $buildNode.SetAttribute("Project", "false")
                $clientNode.AppendChild($buildNode) | Out-Null
                
                $solutionNode.AppendChild($clientNode) | Out-Null
            }
            $script:Changes += "Add project: Oqtane.Client"
        } else {
            Write-Host "Oqtane.Client project already exists" -ForegroundColor Yellow
        }
        
        # Check if Shared project already exists at root
        $existingShared = $solutionNode.Project | Where-Object { $_.Path -replace '\\', '/' -eq $sharedProjectPath }
        if (-not $existingShared) {
            Write-Host "Adding Oqtane.Shared project: $sharedProjectPath" -ForegroundColor Green
            if (-not $DryRun) {
                $sharedNode = $xml.CreateElement("Project")
                $sharedNode.SetAttribute("Path", $sharedProjectPath)
                
                # Add Build element with Project="false"
                $buildNode = $xml.CreateElement("Build")
                $buildNode.SetAttribute("Project", "false")
                $sharedNode.AppendChild($buildNode) | Out-Null
                
                $solutionNode.AppendChild($sharedNode) | Out-Null
            }
            $script:Changes += "Add project: Oqtane.Shared"
        } else {
            Write-Host "Oqtane.Shared project already exists" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "Could not find Oqtane framework root (Oqtane.Server.csproj) in parent directories" -ForegroundColor Red
    Write-Host "Searched up to $maxDepth levels from: $SolutionRoot" -ForegroundColor Yellow
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