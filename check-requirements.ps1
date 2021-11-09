$global:ProgressPreference = "SilentlyContinue"
Class Requirement {
  [string]$Requirement
  [string]$Status
  [string]$Version
}

Class EnvRequirement {
  [string]$EnvironmentVariable
  [string]$Status
}

[EnvRequirement[]]$envRequirements = @()
[Requirement[]]$requirements = @()
[string[]]$pathRequired = @(
  "C:\\windows\\system32",
  "C:\\windows\\system32\\wbem",
  "C:\\windows",
  "C:\\windows\\system32\\windowspowershell\\v1.0"
)

function CheckValueInEnvPath([string]$value) {
  $envPath = $env:PATH += ";"
  return (($envPath).ToLower() -match ("$value;").ToLower()) -or (($envPath).ToLower() -match ("$value\\;").ToLower());
}

function GetRequirementObj($name, $version, [version]$minVersion, [version]$maxVersion = "$([int]::MaxValue).$([int]::MaxValue).$([int]::MaxValue)") {
  $requirement = New-Object Requirement
  $requirement.Requirement = $name
  if ($version -eq $false) {
    $requirement.Status = "KO (Not Found)"
    $requirement.Version = $null
  } elseif([version]$version -lt $minVersion) {
    $requirement.Status = "KO (min version: $($minVersion.ToString()))"
    $requirement.Version = $version.ToString()
  } elseif ([version]$version -gt $maxVersion) {
    $requirement.Status = "KO (max version: $($maxVersion.ToString()))"
    $requirement.Version = $version.ToString()
  } else {
    $requirement.Status = "OK"
    $requirement.Version = $version
  }
  return $requirement
}

function GetEnvPathRequirementObj($name) {
  $requirement = New-Object EnvRequirement
  $requirement.EnvironmentVariable = "PATH: $name"
  if (CheckValueInEnvPath $name) {
    $requirement.Status = "OK"
  } else {
    $requirement.Status = "Value in Env Var PATH Not Found"
  }
  return $requirement
}

[version]$minCodeVersion = "1.60.0"
[version]$minVSVersion = "16.8.0"
[version]$minGitVersion = "2.27.0"
[version]$minNodeVersion = "14.0.0"
[version]$minNpmVersion = "6.0.0"
[version]$maxNpmVersion = "7.0.0"
[version]$minDotnetVersion = "3.1.0"
[version]$minDockerVersion = "20.0.0"

[version]$codeVersion
[version]$VSVersion
[version]$gitVersion
[version]$nodeVersion
[version]$dotnetVersion

# vs code
try {
  $codeVersion = (code --version)[0]
}
catch {
  $codeVersion = $false
}

# VS
try {
  [version[]]$VSVersions = &"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -property catalog_productDisplayVersion
  $VSVersion = ($VSVersions | Sort-Object -Descending)[0]
}
catch {
  $VSVersion = $false
}

# git
try {
  $gitVersion = (git --version).replace("git version","").replace(".windows","").Trim()
}
catch {
  $gitVersion = $false
}

# node.js
try {
  $nodeVersion = (node --version).replace("v","")
}
catch {
  $nodeVersion = $false
}

# npm
try {
  $npmVersion = npm --version
}
catch {
  $npmVersion = $false
}

# dotnet
try {
  $dotnetVersion = (dotnet --version)
}
catch {
  $dotnetVersion = $false
}

# docker
try {
  $dockerVersion = (docker --version).replace(",", "").replace("Docker version", "").replace("build", "").Trim().Split(" ")[0]
}
catch {
  $dockerVersion = $false
}

# Administrator permission
try {
  (Get-LocalGroupMember Administrators).Name | ForEach-Object { if ($_.ToLower() -eq $(whoami).ToLower()) {$isAdmin = $true} }
  if ($isAdmin) {
    $adminPermissionPresent = "OK"
  } else {
    $adminPermissionPresent = "NO"
  }
}
catch {
  $adminPermissionPresent = "UNKNOWN"
}

$adminRequirement = New-Object Requirement
$adminRequirement.Requirement = "Administrator Permission"
$adminRequirement.Status = $adminPermissionPresent

# Azure DevOps
$azureDevOpsAvailable = (Test-NetConnection devops.codearchitects.com -port 444).TcpTestSucceeded
if ($azureDevOpsAvailable) {
  try {
    Invoke-WebRequest https://devops.codearchitects.com:444/
  } catch {
    $status = $_.Exception.Response.StatusCode.value__
  }

  if ($status -eq 401) {
    $azDevOpsStatus = "Reachable"
  } else {
    $azDevOpsStatus = "Unreachable with HTTPS protocol"
  }
} else {
  $azDevOpsStatus = "Unreachable with TCP protocol"
}
$azDevOpsRequirement = New-Object Requirement
$azDevOpsRequirement.Requirement = "Code Architects Azure DevOps Server"
$azDevOpsRequirement.Status = $azDevOpsStatus

# table
$requirements += (GetRequirementObj -requirements $requirements -name "Visual Studio" -version $VSVersion -minVersion $minVSVersion)
$requirements += (GetRequirementObj -requirements $requirements -name "Visual Studio Code" -version $codeVersion -minVersion $minCodeVersion)
$requirements += (GetRequirementObj -requirements $requirements -name "Git" -version $gitVersion -minVersion $minGitVersion)
$requirements += (GetRequirementObj -requirements $requirements -name "Node.js" -version $nodeVersion -minVersion $minNodeVersion)
$requirements += (GetRequirementObj -requirements $requirements -name "DotNet Core" -version $dotnetVersion -minVersion $minDotnetVersion)
$requirements += (GetRequirementObj -requirements $requirements -name "Docker" -version $dockerVersion -minVersion $mindockerVersion)
$requirements += (GetRequirementObj -requirements $requirements -name "npm" -version $npmVersion -minVersion $minNpmVersion -maxVersion $maxNpmVersion)
$requirements += $adminRequirement
$requirements += $azDevOpsRequirement
$pathRequired | ForEach-Object {
  $envRequirements += GetEnvPathRequirementObj $_
}

Write-Host "Software Requirements"
$requirements | Format-Table

Write-Host "Environment Variables Requirements"
$envRequirements | Format-Table