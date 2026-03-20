param (
    [Parameter(Mandatory=$true)][string]$Owner,
    [Parameter(Mandatory=$true)][string]$Module,
    [Parameter(Mandatory=$true)][string]$Description,
    [Parameter(Mandatory=$true)][string]$FrameworkRoot,
    [Parameter(Mandatory=$true)][string]$Destination
)

$ErrorActionPreference = "Stop"

Write-Host "Starting Oqtane Module Scaffold Process..."

# 1. Framework Version Extraction
$constantsPath = Join-Path $FrameworkRoot "Oqtane.Shared\Shared\Constants.cs"
if (-not (Test-Path $constantsPath)) {
    throw "Could not find Constants.cs at $constantsPath"
}
$constantsText = Get-Content $constantsPath -Raw
if ($constantsText -match 'public static readonly string Version\s*=\s*"([^"]+)"') {
    $FrameworkVersion = $matches[1]
    Write-Host "Discovered Framework Version: $FrameworkVersion"
} else {
    throw "Failed to extract Framework Version from Constants.cs"
}

# 2. Destination Preparation
if (Test-Path $Destination) {
    Write-Host "Removing existing destination folder: $Destination"
    Remove-Item -Path $Destination -Recurse -Force
}
New-Item -ItemType Directory -Path $Destination -Force | Out-Null

# 3. Copy Template
$templatePath = Join-Path $FrameworkRoot "Oqtane.Server\wwwroot\Modules\Templates\External"
if (-not (Test-Path $templatePath)) {
    throw "Could not find External template at $templatePath"
}
Write-Host "Copying External template..."
Copy-Item -Path "$templatePath\*" -Destination $Destination -Recurse -Force

Write-Host "Cleaning up extraneous build output (.vs, bin, obj)..."
Get-ChildItem -Path $Destination -Directory -Recurse | Where-Object { $_.Name -match "^(obj|bin|\.vs)$" } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

# 4. Compute RootFolder
# We calculate relative path from Destination to FrameworkRoot manually or using Uri
$uriFramework = [System.Uri]::new($FrameworkRoot + "\")
$uriDestination = [System.Uri]::new($Destination + "\")
$relativeUri = $uriDestination.MakeRelativeUri($uriFramework)
$RootFolder = [System.Uri]::UnescapeDataString($relativeUri.ToString()).Replace('/', '\')
if ($RootFolder.EndsWith("\")) { $RootFolder = $RootFolder.Substring(0, $RootFolder.Length - 1) }
Write-Host "Computed RootFolder: $RootFolder"

# 5. Rename Folders and Files
Write-Host "Renaming folders and files..."
# Folders (bottom up to avoid path tracking issues)
$dirs = Get-ChildItem -Path $Destination -Directory -Recurse | Sort-Object -Property @{Expression={$_.FullName.Length};Descending=$true}
foreach ($d in $dirs) {
    if ($d.Name -match '\[.*\]') {
        $newName = $d.Name.Replace('[Owner]', $Owner).Replace('[Module]', $Module)
        Rename-Item -Path $d.FullName -NewName $newName
    }
}
# Files
$files = Get-ChildItem -Path $Destination -File -Recurse
foreach ($f in $files) {
    if ($f.Name -match '\[.*\]') {
        $newName = $f.Name.Replace('[Owner]', $Owner).Replace('[Module]', $Module)
        Rename-Item -Path $f.FullName -NewName $newName
    }
}

# 6. Token Replacement Rules
$ServerManagerType = "${Owner}.Module.${Module}.Manager.${Module}Manager, ${Owner}.Module.${Module}.Server.Oqtane"

$files = Get-ChildItem -Path $Destination -File -Recurse
$extensionsToSkip = @(".png", ".dll", ".exe", ".pdb", ".git")
Write-Host "Replacing tokens in files..."

$ClientRef = "<ProjectReference Include=`"..\Client\${Owner}.Module.${Module}.Client.csproj`" />"
$SharedRef = "<ProjectReference Include=`"..\Shared\${Owner}.Module.${Module}.Shared.csproj`" />"
$ServerRef = "<ProjectReference Include=`"..\Server\${Owner}.Module.${Module}.Server.csproj`" />"

foreach ($f in $files) {
    if ($extensionsToSkip -contains $f.Extension.ToLower()) { continue }

    $content = [System.IO.File]::ReadAllText($f.FullName)
    $originalContent = $content

    $content = $content.Replace("[Owner]", $Owner)
    $content = $content.Replace("[Module]", $Module)
    $content = $content.Replace("[Description]", $Description)
    $content = $content.Replace("[ServerManagerType]", $ServerManagerType)
    $content = $content.Replace("[FrameworkVersion]", $FrameworkVersion)
    $content = $content.Replace("[RootFolder]", $RootFolder)
    
    # MSBuild Reference Tokens
    $content = $content.Replace("[ClientReference]", $ClientRef)
    $content = $content.Replace("[ServerReference]", $ServerRef)
    $content = $content.Replace("[SharedReference]", $SharedRef)
    
    # Specific framework references patching for external modules
    if ($f.Name -eq "${Owner}.Module.${Module}.Client.csproj") {
        $fwRefs = @"
  <ItemGroup>
    <Reference Include="Oqtane.Client">
      <HintPath>..\..\$RootFolder\Oqtane.Server\bin\Debug\net10.0\Oqtane.Client.dll</HintPath>
    </Reference>
    <Reference Include="Oqtane.Shared">
      <HintPath>..\..\$RootFolder\Oqtane.Server\bin\Debug\net10.0\Oqtane.Shared.dll</HintPath>
    </Reference>
  </ItemGroup>
</Project>
"@
        $content = $content.Replace("</Project>", $fwRefs)
    }
    
    if ($f.Name -eq "${Owner}.Module.${Module}.Server.csproj") {
        $fwRefs = @"
  <ItemGroup>
    <Reference Include="Oqtane.Server">
      <HintPath>..\..\$RootFolder\Oqtane.Server\bin\Debug\net10.0\Oqtane.Server.dll</HintPath>
    </Reference>
    <Reference Include="Oqtane.Shared">
      <HintPath>..\..\$RootFolder\Oqtane.Server\bin\Debug\net10.0\Oqtane.Shared.dll</HintPath>
    </Reference>
  </ItemGroup>
</Project>
"@
        $content = $content.Replace("</Project>", $fwRefs)
    }
    
    if ($f.Name -eq "${Owner}.Module.${Module}.Shared.csproj") {
        $fwRefs = @"
  <ItemGroup>
    <Reference Include="Oqtane.Shared">
      <HintPath>..\..\$RootFolder\Oqtane.Server\bin\Debug\net10.0\Oqtane.Shared.dll</HintPath>
    </Reference>
  </ItemGroup>
</Project>
"@
        $content = $content.Replace("</Project>", $fwRefs)
    }

    if ($originalContent -ne $content) {
        [System.IO.File]::WriteAllText($f.FullName, $content)
    }
}

# 7. SLNX Reordering and Forward Slashes
$slnxPath = Join-Path $Destination "${Owner}.Module.${Module}.slnx"
if (Test-Path $slnxPath) {
    # Match Protocol rules explicitly
    $slnxContent = @"
<Solution>
  <Project Path="Client/${Owner}.Module.${Module}.Client.csproj" />
  <Project Path="Package/${Owner}.Module.${Module}.Package.csproj" />
  <Project Path="Server/${Owner}.Module.${Module}.Server.csproj" />
  <Project Path="Shared/${Owner}.Module.${Module}.Shared.csproj" />
  <Project Path="../$RootFolder/Oqtane.Server/Oqtane.Server.csproj">
    <Build Project="false" />
  </Project>
</Solution>
"@
    [System.IO.File]::WriteAllText($slnxPath, $slnxContent)
    Write-Host "Rewrote $slnxPath to match scaffold protocol constraints."
}

# 8. Token Exhaustion Validation
Write-Host "Validating token exhaustion..."
$exhaustionFailed = $false
foreach ($f in $files) {
    if ($extensionsToSkip -contains $f.Extension.ToLower()) { continue }
    $content = [System.IO.File]::ReadAllText($f.FullName)
    
    # Strip known valid attributes
    $testContent = $content.Replace("[Key]", "").Replace("[HttpGet]", "").Replace("[HttpPost]", "").Replace("[FromBody]", "")
    $testContent = $testContent -replace '\[Table\([^\]]*\)\]', '' -replace '\[ForeignKey\([^\]]*\)\]', '' -replace '\[Route\([^\]]*\)\]', '' -replace '\[Authorize\([^\]]*\)\]', ''

    $tokenMatches = [regex]::Matches($testContent, "\[[A-Za-z0-9]+\]")
    foreach ($m in $tokenMatches) {
        $token = $m.Value
        Write-Warning "Unresolved token found in $($f.Name): $token"
        $exhaustionFailed = $true
    }
}

if ($exhaustionFailed) {
    throw "Exhaustion validation failed. Unresolved tokens found."
}

Write-Host "===================================="
Write-Host "Scaffolding complete successfully!"
Write-Host "Module Path: $Destination"
Write-Host "Framework: $FrameworkVersion"
Write-Host "===================================="
