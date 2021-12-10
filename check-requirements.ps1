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
    $requirement.Status = "KO (Value in Env Var PATH Not Found)"
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

# Microsoft-Windows-Subsystem-Linux
try {
  if ((Get-WinSystemLocale).DisplayName -like "*English*") {
    $wslWindowsFeature = (dism /online /get-featureinfo /featurename:Microsoft-Windows-Subsystem-Linux) | Select-String "Disabled"
  } else {
    $wslWindowsFeature = (dism /online /get-featureinfo /featurename:Microsoft-Windows-Subsystem-Linux) | Select-String "Disattivata"
  }
  
  if ($wslWindowsFeature) {
    $wslEnableStatus = "OK"
  } else {
    $wslEnableStatus = "KO (Not enabled)"
  }
}
catch {
  $wslEnableStatus = "KO (Not Found)"
}

$wslRequirement = New-Object Requirement
$wslRequirement.Requirement = "Windows Subsystem Linux"
$wslRequirement.Status = $wslEnableStatus

# VirtualMachinePlatform
try {
  if ((Get-WinSystemLocale).DisplayName -like "*English*") {
    $vmpWindowsFeature = (dism /online /get-featureinfo /featurename:VirtualMachinePlatform) | Select-String "Disabled"
  } else {
    $vmpWindowsFeature = (dism /online /get-featureinfo /featurename:VirtualMachinePlatform) | Select-String "Disattivata"
  }

  if ($vmpWindowsFeature) {
    $vmpEnableStatus = "OK"
  } else {
    $vmpEnableStatus = "KO (Not enabled)"
  }
}
catch {
  $vmpEnableStatus = "KO (Not Found)"
}

$vmpRequirement = New-Object Requirement
$vmpRequirement.Requirement = "Virtual Machine Platform"
$vmpRequirement.Status = $vmpEnableStatus

# WSL2 Update
try {
  if (([System.Text.Encoding]::Unicode.GetString([System.Text.Encoding]::Default.GetBytes(($(wsl --status)).Split("`r`n"))) | Where-Object { ($_ -like "*Kernel version*") -or ($_ -like "*Versione del kernel*") })) {
    $wslUpdateStatus = "OK"
  } else {
    $wslUpdateStatus = "KO (Not Found)"
  }
}
catch {
  $wslUpdateStatus = "KO (Not Found)"
}

$wslUpdateRequirement = New-Object Requirement
$wslUpdateRequirement.Requirement = "Wsl Update"
$wslUpdateRequirement.Status = $wslUpdateStatus

# Linux Distribution
try {
  if (-not ([System.Text.Encoding]::Unicode.GetString([System.Text.Encoding]::Default.GetBytes(($(wsl -l -v)))) | Where-Object { $_ -like "*distribution*" })) {
    $linuxDistroStatus = "OK"
  } else {
    $linuxDistroStatus = "KO (Not Found)"
  }
}
catch {
  $linuxDistroStatus = "KO (Not Found)"
}

$linuxDistroRequirement = New-Object Requirement
$linuxDistroRequirement.Requirement = "Linux Distribution"
$linuxDistroRequirement.Status = $linuxDistroStatus

# Administrator permission
try {
  (Get-LocalGroupMember Administrators).Name | ForEach-Object { if ($_.ToLower() -like "*$($(whoami).ToLower())") {$isAdmin = $true} }
  if ($isAdmin) {
    $adminPermissionPresent = "OK"
  } else {
    $adminPermissionPresent = "KO (No admin permission)"
  }
}
catch {
  $adminPermissionPresent = "KO (Unknown)"
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
    $azDevOpsStatus = "OK (Reachable)"
  } else {
    $azDevOpsStatus = "KO (Unreachable with HTTPS protocol)"
  }
} else {
  $azDevOpsStatus = "KO (Unreachable with TCP protocol)"
}
$azDevOpsRequirement = New-Object Requirement
$azDevOpsRequirement.Requirement = "Code Architects Azure DevOps Server"
$azDevOpsRequirement.Status = $azDevOpsStatus

# Registry npm
try {
  $npmRegistryAvailable = (Invoke-WebRequest -Uri https://registry.npmjs.org -UseBasicParsing -DisableKeepAlive).StatusCode

  if ($npmRegistryAvailable -eq 200) {
    $npmRegistryStatus = "OK (Reachable)"
  } else {
    $npmRegistryStatus = "KO (Unreachable)"
  }
}
catch {
  $npmRegistryStatus = "KO (Error)"
}

$npmRegistryRequirement = New-Object Requirement
$npmRegistryRequirement.Requirement = "Public registry npm"
$npmRegistryRequirement.Status = $npmRegistryStatus

# Registry NuGet
try {
  $nugetRegistryAvailable = (Invoke-WebRequest -Uri https://api.nuget.org/v3/index.json -UseBasicParsing).StatusCode

  if ($nugetRegistryAvailable -eq 200) {
    $nugetRegistryStatus = "OK (Reachable)"
  } else {
    $nugetRegistryStatus = "KO (Unreachable)"
  }
}
catch {
  $nugetRegistryStatus = "KO (Error)"
}

$nugetRegistryRequirement = New-Object Requirement
$nugetRegistryRequirement.Requirement = "Public registry NuGet"
$nugetRegistryRequirement.Status = $nugetRegistryStatus

# Virtual Machine
$IsVirtualMachine = (((Get-CimInstance win32_computersystem).model -eq 'VMware Virtual Platform') -or ((Get-CimInstance win32_computersystem).model -eq 'Virtual Machine'))
if (-not $IsVirtualMachine) {
  $VirtualMachineStatus = "OK (is a Physical Machine)"
} else {
  $VirtualMachineStatus = "WARNING (is a Virtual Machine)"
}

$VirtualMachineRequirement = New-Object Requirement
$VirtualMachineRequirement.Requirement = "Machine"
$VirtualMachineRequirement.Status = $VirtualMachineStatus

# Proxy
$ProxyData = Get-ItemProperty -Path "Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" | Select-Object "Proxy*"
if ($ProxyData.ProxyEnable -eq 0) {
  $ProxyActiveStatus = "OK (Is not active)"
} else {
  $ProxyActiveStatus = "WARNING (Is active)"
}

$ProxyRequirement = New-Object Requirement
$ProxyRequirement.Requirement = "Proxy"
$ProxyRequirement.Status = $ProxyActiveStatus

# table
$requirements += $VirtualMachineRequirement
$requirements += $ProxyRequirement
$requirements += (GetRequirementObj -requirements $requirements -name "Git" -version $gitVersion -minVersion $minGitVersion)
$requirements += (GetRequirementObj -requirements $requirements -name "Node.js" -version $nodeVersion -minVersion $minNodeVersion)
$requirements += (GetRequirementObj -requirements $requirements -name "npm" -version $npmVersion -minVersion $minNpmVersion -maxVersion $maxNpmVersion)
$requirements += (GetRequirementObj -requirements $requirements -name "DotNet Core" -version $dotnetVersion -minVersion $minDotnetVersion)
$requirements += (GetRequirementObj -requirements $requirements -name "Visual Studio Code" -version $codeVersion -minVersion $minCodeVersion)
$requirements += (GetRequirementObj -requirements $requirements -name "Visual Studio" -version $VSVersion -minVersion $minVSVersion)
$requirements += $wslRequirement
$requirements += $vmpRequirement
$requirements += $wslUpdateRequirement
$requirements += $linuxDistroRequirement
$requirements += (GetRequirementObj -requirements $requirements -name "Docker" -version $dockerVersion -minVersion $mindockerVersion)
$requirements += $adminRequirement
$requirements += $azDevOpsRequirement
$requirements += $npmRegistryRequirement
$requirements += $nugetRegistryRequirement
$pathRequired | ForEach-Object {
  $envRequirements += GetEnvPathRequirementObj $_
}

Write-Host "Software Requirements"
$requirements | Format-Table

Write-Host "Environment Variables Requirements"
$envRequirements | Format-Table


$requirements | ForEach-Object { if($_.Status -like "KO*") { $FoundError = $true } }
$envRequirements | ForEach-Object { if($_.Status -like "KO*") { $FoundError = $true } }

# SIG # Begin signature block
# MIIk2wYJKoZIhvcNAQcCoIIkzDCCJMgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUUJoM+3AnHb1BGGUq410A7w/5
# BE6ggh62MIIFOTCCBCGgAwIBAgIQDue4N8WIaRr2ZZle0AzJjDANBgkqhkiG9w0B
# AQsFADB8MQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
# MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxJDAi
# BgNVBAMTG1NlY3RpZ28gUlNBIENvZGUgU2lnbmluZyBDQTAeFw0yMTAxMjUwMDAw
# MDBaFw0yNDAxMjUyMzU5NTlaMIGgMQswCQYDVQQGEwJJVDEOMAwGA1UEEQwFNzAw
# MjkxDTALBgNVBAgMBEJhcmkxGzAZBgNVBAcMElNhbnRlcmFtbyBpbiBDb2xsZTEZ
# MBcGA1UECQwQVmlhIENhbXBhbmlhLDEvMzEcMBoGA1UECgwTQ29kZSBBcmNoaXRl
# Y3RzIFNybDEcMBoGA1UEAwwTQ29kZSBBcmNoaXRlY3RzIFNybDCCASIwDQYJKoZI
# hvcNAQEBBQADggEPADCCAQoCggEBALaj4vlKflM4B+dR8Cz8Z7RA4CUe2iR2WGp9
# /qTN2Eg+7RG74V7gBsOqyllqNdmUecwqwbiRbPB4+s83rYxwRZf1s/cEmtcKWUpu
# g4Kde2XKIMz8IigS5P+4qFStWeY5VkybU1CDWyHpj4iUiYyy3D6BbLxIhwTyjVDz
# 6h/VIlAqDt6tNSIkACdp0CRPDe1/I3HLVLVRqSbek473Enbijb4H3oSrsnCqF7Xx
# +UBa7zUNo5fZNBRJb4IfRq17uKQ8oNz+2KcIB74hsXm1X2v8Igm6upua/Td8kZ0b
# CuuogqPoUbEKXTNMd5D32JUAi7KpgKWE4CCbG7zk7ivGpAii6OUCAwEAAaOCAZAw
# ggGMMB8GA1UdIwQYMBaAFA7hOqhTOjHVir7Bu61nGgOFrTQOMB0GA1UdDgQWBBTz
# X2/Q/EHWaGVPiGGw0uJSmluXeDAOBgNVHQ8BAf8EBAMCB4AwDAYDVR0TAQH/BAIw
# ADATBgNVHSUEDDAKBggrBgEFBQcDAzARBglghkgBhvhCAQEEBAMCBBAwSgYDVR0g
# BEMwQTA1BgwrBgEEAbIxAQIBAwIwJTAjBggrBgEFBQcCARYXaHR0cHM6Ly9zZWN0
# aWdvLmNvbS9DUFMwCAYGZ4EMAQQBMEMGA1UdHwQ8MDowOKA2oDSGMmh0dHA6Ly9j
# cmwuc2VjdGlnby5jb20vU2VjdGlnb1JTQUNvZGVTaWduaW5nQ0EuY3JsMHMGCCsG
# AQUFBwEBBGcwZTA+BggrBgEFBQcwAoYyaHR0cDovL2NydC5zZWN0aWdvLmNvbS9T
# ZWN0aWdvUlNBQ29kZVNpZ25pbmdDQS5jcnQwIwYIKwYBBQUHMAGGF2h0dHA6Ly9v
# Y3NwLnNlY3RpZ28uY29tMA0GCSqGSIb3DQEBCwUAA4IBAQBlnIYjhWZ4sTIbd/yg
# CjBcY2IKtXvL5Nts38z5c/7NtoJrP5C7MyjdVfgP5hTcXGVsKbZu1FwI+qlmcKcl
# YO9fiNP8qOIxDKrlETyduXknx70mjok/ZrrbrPYiCIRf3imGWb0dU6U1iDsphhng
# My2352B8K4RICeHd/pLY8PGyM276RIVRL9qv/welyakOoqs9n8JPz4SkQKZ1LELb
# rHtxU9gSC6M/Sz3T0wLCF+qZw388HgpT0iv1PCWr3LFuzY1FxD9hOaGrVQKu1GeM
# VBqF3Ac+jRy308kqZlzwvR5s6mYFyEvxS9CoUNBERBEFgULSkGH5O7SVjUcbiK8w
# BlToMIIFgTCCBGmgAwIBAgIQOXJEOvkit1HX02wQ3TE1lTANBgkqhkiG9w0BAQwF
# ADB7MQswCQYDVQQGEwJHQjEbMBkGA1UECAwSR3JlYXRlciBNYW5jaGVzdGVyMRAw
# DgYDVQQHDAdTYWxmb3JkMRowGAYDVQQKDBFDb21vZG8gQ0EgTGltaXRlZDEhMB8G
# A1UEAwwYQUFBIENlcnRpZmljYXRlIFNlcnZpY2VzMB4XDTE5MDMxMjAwMDAwMFoX
# DTI4MTIzMTIzNTk1OVowgYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpOZXcgSmVy
# c2V5MRQwEgYDVQQHEwtKZXJzZXkgQ2l0eTEeMBwGA1UEChMVVGhlIFVTRVJUUlVT
# VCBOZXR3b3JrMS4wLAYDVQQDEyVVU0VSVHJ1c3QgUlNBIENlcnRpZmljYXRpb24g
# QXV0aG9yaXR5MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAgBJlFzYO
# w9sIs9CsVw127c0n00ytUINh4qogTQktZAnczomfzD2p7PbPwdzx07HWezcoEStH
# 2jnGvDoZtF+mvX2do2NCtnbyqTsrkfjib9DsFiCQCT7i6HTJGLSR1GJk23+jBvGI
# GGqQIjy8/hPwhxR79uQfjtTkUcYRZ0YIUcuGFFQ/vDP+fmyc/xadGL1RjjWmp2bI
# cmfbIWax1Jt4A8BQOujM8Ny8nkz+rwWWNR9XWrf/zvk9tyy29lTdyOcSOk2uTIq3
# XJq0tyA9yn8iNK5+O2hmAUTnAU5GU5szYPeUvlM3kHND8zLDU+/bqv50TmnHa4xg
# k97Exwzf4TKuzJM7UXiVZ4vuPVb+DNBpDxsP8yUmazNt925H+nND5X4OpWaxKXwy
# hGNVicQNwZNUMBkTrNN9N6frXTpsNVzbQdcS2qlJC9/YgIoJk2KOtWbPJYjNhLix
# P6Q5D9kCnusSTJV882sFqV4Wg8y4Z+LoE53MW4LTTLPtW//e5XOsIzstAL81VXQJ
# SdhJWBp/kjbmUZIO8yZ9HE0XvMnsQybQv0FfQKlERPSZ51eHnlAfV1SoPv10Yy+x
# UGUJ5lhCLkMaTLTwJUdZ+gQek9QmRkpQgbLevni3/GcV4clXhB4PY9bpYrrWX1Uu
# 6lzGKAgEJTm4Diup8kyXHAc/DVL17e8vgg8CAwEAAaOB8jCB7zAfBgNVHSMEGDAW
# gBSgEQojPpbxB+zirynvgqV/0DCktDAdBgNVHQ4EFgQUU3m/WqorSs9UgOHYm8Cd
# 8rIDZsswDgYDVR0PAQH/BAQDAgGGMA8GA1UdEwEB/wQFMAMBAf8wEQYDVR0gBAow
# CDAGBgRVHSAAMEMGA1UdHwQ8MDowOKA2oDSGMmh0dHA6Ly9jcmwuY29tb2RvY2Eu
# Y29tL0FBQUNlcnRpZmljYXRlU2VydmljZXMuY3JsMDQGCCsGAQUFBwEBBCgwJjAk
# BggrBgEFBQcwAYYYaHR0cDovL29jc3AuY29tb2RvY2EuY29tMA0GCSqGSIb3DQEB
# DAUAA4IBAQAYh1HcdCE9nIrgJ7cz0C7M7PDmy14R3iJvm3WOnnL+5Nb+qh+cli3v
# A0p+rvSNb3I8QzvAP+u431yqqcau8vzY7qN7Q/aGNnwU4M309z/+3ri0ivCRlv79
# Q2R+/czSAaF9ffgZGclCKxO/WIu6pKJmBHaIkU4MiRTOok3JMrO66BQavHHxW/BB
# C5gACiIDEOUMsfnNkjcZ7Tvx5Dq2+UUTJnWvu6rvP3t3O9LEApE9GQDTF1w52z97
# GA1FzZOFli9d31kWTz9RvdVFGD/tSo7oBmF0Ixa1DVBzJ0RHfxBdiSprhTEUxOip
# akyAvGp4z7h/jnZymQyd/teRCBaho1+VMIIF9TCCA92gAwIBAgIQHaJIMG+bJhjQ
# guCWfTPTajANBgkqhkiG9w0BAQwFADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgT
# Ck5ldyBKZXJzZXkxFDASBgNVBAcTC0plcnNleSBDaXR5MR4wHAYDVQQKExVUaGUg
# VVNFUlRSVVNUIE5ldHdvcmsxLjAsBgNVBAMTJVVTRVJUcnVzdCBSU0EgQ2VydGlm
# aWNhdGlvbiBBdXRob3JpdHkwHhcNMTgxMTAyMDAwMDAwWhcNMzAxMjMxMjM1OTU5
# WjB8MQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAw
# DgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxJDAiBgNV
# BAMTG1NlY3RpZ28gUlNBIENvZGUgU2lnbmluZyBDQTCCASIwDQYJKoZIhvcNAQEB
# BQADggEPADCCAQoCggEBAIYijTKFehifSfCWL2MIHi3cfJ8Uz+MmtiVmKUCGVEZ0
# MWLFEO2yhyemmcuVMMBW9aR1xqkOUGKlUZEQauBLYq798PgYrKf/7i4zIPoMGYmo
# bHutAMNhodxpZW0fbieW15dRhqb0J+V8aouVHltg1X7XFpKcAC9o95ftanK+ODtj
# 3o+/bkxBXRIgCFnoOc2P0tbPBrRXBbZOoT5Xax+YvMRi1hsLjcdmG0qfnYHEckC1
# 4l/vC0X/o84Xpi1VsLewvFRqnbyNVlPG8Lp5UEks9wO5/i9lNfIi6iwHr0bZ+UYc
# 3Ix8cSjz/qfGFN1VkW6KEQ3fBiSVfQ+noXw62oY1YdMCAwEAAaOCAWQwggFgMB8G
# A1UdIwQYMBaAFFN5v1qqK0rPVIDh2JvAnfKyA2bLMB0GA1UdDgQWBBQO4TqoUzox
# 1Yq+wbutZxoDha00DjAOBgNVHQ8BAf8EBAMCAYYwEgYDVR0TAQH/BAgwBgEB/wIB
# ADAdBgNVHSUEFjAUBggrBgEFBQcDAwYIKwYBBQUHAwgwEQYDVR0gBAowCDAGBgRV
# HSAAMFAGA1UdHwRJMEcwRaBDoEGGP2h0dHA6Ly9jcmwudXNlcnRydXN0LmNvbS9V
# U0VSVHJ1c3RSU0FDZXJ0aWZpY2F0aW9uQXV0aG9yaXR5LmNybDB2BggrBgEFBQcB
# AQRqMGgwPwYIKwYBBQUHMAKGM2h0dHA6Ly9jcnQudXNlcnRydXN0LmNvbS9VU0VS
# VHJ1c3RSU0FBZGRUcnVzdENBLmNydDAlBggrBgEFBQcwAYYZaHR0cDovL29jc3Au
# dXNlcnRydXN0LmNvbTANBgkqhkiG9w0BAQwFAAOCAgEATWNQ7Uc0SmGk295qKoyb
# 8QAAHh1iezrXMsL2s+Bjs/thAIiaG20QBwRPvrjqiXgi6w9G7PNGXkBGiRL0C3da
# nCpBOvzW9Ovn9xWVM8Ohgyi33i/klPeFM4MtSkBIv5rCT0qxjyT0s4E307dksKYj
# alloUkJf/wTr4XRleQj1qZPea3FAmZa6ePG5yOLDCBaxq2NayBWAbXReSnV+pbjD
# bLXP30p5h1zHQE1jNfYw08+1Cg4LBH+gS667o6XQhACTPlNdNKUANWlsvp8gJRAN
# GftQkGG+OY96jk32nw4e/gdREmaDJhlIlc5KycF/8zoFm/lv34h/wCOe0h5DekUx
# wZxNqfBZslkZ6GqNKQQCd3xLS81wvjqyVVp4Pry7bwMQJXcVNIr5NsxDkuS6T/Fi
# kyglVyn7URnHoSVAaoRXxrKdsbwcCtp8Z359LukoTBh+xHsxQXGaSynsCz1XUNLK
# 3f2eBVHlRHjdAd6xdZgNVCT98E7j4viDvXK6yz067vBeF5Jobchh+abxKgoLpbn0
# nu6YMgWFnuv5gynTxix9vTp3Los3QqBqgu07SqqUEKThDfgXxbZaeTMYkuO1dfih
# 6Y4KJR7kHvGfWocj/5+kUZ77OYARzdu1xKeogG/lU9Tg46LC0lsa+jImLWpXcBw8
# pFguo/NbSwfcMlnzh6cabVgwggbsMIIE1KADAgECAhAwD2+s3WaYdHypRjaneC25
# MA0GCSqGSIb3DQEBDAUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMKTmV3IEpl
# cnNleTEUMBIGA1UEBxMLSmVyc2V5IENpdHkxHjAcBgNVBAoTFVRoZSBVU0VSVFJV
# U1QgTmV0d29yazEuMCwGA1UEAxMlVVNFUlRydXN0IFJTQSBDZXJ0aWZpY2F0aW9u
# IEF1dGhvcml0eTAeFw0xOTA1MDIwMDAwMDBaFw0zODAxMTgyMzU5NTlaMH0xCzAJ
# BgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcT
# B1NhbGZvcmQxGDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDElMCMGA1UEAxMcU2Vj
# dGlnbyBSU0EgVGltZSBTdGFtcGluZyBDQTCCAiIwDQYJKoZIhvcNAQEBBQADggIP
# ADCCAgoCggIBAMgbAa/ZLH6ImX0BmD8gkL2cgCFUk7nPoD5T77NawHbWGgSlzkeD
# tevEzEk0y/NFZbn5p2QWJgn71TJSeS7JY8ITm7aGPwEFkmZvIavVcRB5h/RGKs3E
# Wsnb111JTXJWD9zJ41OYOioe/M5YSdO/8zm7uaQjQqzQFcN/nqJc1zjxFrJw06PE
# 37PFcqwuCnf8DZRSt/wflXMkPQEovA8NT7ORAY5unSd1VdEXOzQhe5cBlK9/gM/R
# EQpXhMl/VuC9RpyCvpSdv7QgsGB+uE31DT/b0OqFjIpWcdEtlEzIjDzTFKKcvSb/
# 01Mgx2Bpm1gKVPQF5/0xrPnIhRfHuCkZpCkvRuPd25Ffnz82Pg4wZytGtzWvlr7a
# TGDMqLufDRTUGMQwmHSCIc9iVrUhcxIe/arKCFiHd6QV6xlV/9A5VC0m7kUaOm/N
# 14Tw1/AoxU9kgwLU++Le8bwCKPRt2ieKBtKWh97oaw7wW33pdmmTIBxKlyx3GSuT
# lZicl57rjsF4VsZEJd8GEpoGLZ8DXv2DolNnyrH6jaFkyYiSWcuoRsDJ8qb/fVfb
# Enb6ikEk1Bv8cqUUotStQxykSYtBORQDHin6G6UirqXDTYLQjdprt9v3GEBXc/Bx
# o/tKfUU2wfeNgvq5yQ1TgH36tjlYMu9vGFCJ10+dM70atZ2h3pVBeqeDAgMBAAGj
# ggFaMIIBVjAfBgNVHSMEGDAWgBRTeb9aqitKz1SA4dibwJ3ysgNmyzAdBgNVHQ4E
# FgQUGqH4YRkgD8NBd0UojtE1XwYSBFUwDgYDVR0PAQH/BAQDAgGGMBIGA1UdEwEB
# /wQIMAYBAf8CAQAwEwYDVR0lBAwwCgYIKwYBBQUHAwgwEQYDVR0gBAowCDAGBgRV
# HSAAMFAGA1UdHwRJMEcwRaBDoEGGP2h0dHA6Ly9jcmwudXNlcnRydXN0LmNvbS9V
# U0VSVHJ1c3RSU0FDZXJ0aWZpY2F0aW9uQXV0aG9yaXR5LmNybDB2BggrBgEFBQcB
# AQRqMGgwPwYIKwYBBQUHMAKGM2h0dHA6Ly9jcnQudXNlcnRydXN0LmNvbS9VU0VS
# VHJ1c3RSU0FBZGRUcnVzdENBLmNydDAlBggrBgEFBQcwAYYZaHR0cDovL29jc3Au
# dXNlcnRydXN0LmNvbTANBgkqhkiG9w0BAQwFAAOCAgEAbVSBpTNdFuG1U4GRdd8D
# ejILLSWEEbKw2yp9KgX1vDsn9FqguUlZkClsYcu1UNviffmfAO9Aw63T4uRW+VhB
# z/FC5RB9/7B0H4/GXAn5M17qoBwmWFzztBEP1dXD4rzVWHi/SHbhRGdtj7BDEA+N
# 5Pk4Yr8TAcWFo0zFzLJTMJWk1vSWVgi4zVx/AZa+clJqO0I3fBZ4OZOTlJux3LJt
# QW1nzclvkD1/RXLBGyPWwlWEZuSzxWYG9vPWS16toytCiiGS/qhvWiVwYoFzY16g
# u9jc10rTPa+DBjgSHSSHLeT8AtY+dwS8BDa153fLnC6NIxi5o8JHHfBd1qFzVwVo
# mqfJN2Udvuq82EKDQwWli6YJ/9GhlKZOqj0J9QVst9JkWtgqIsJLnfE5XkzeSD2b
# NJaaCV+O/fexUpHOP4n2HKG1qXUfcb9bQ11lPVCBbqvw0NP8srMftpmWJvQ8eYtc
# ZMzN7iea5aDADHKHwW5NWtMe6vBE5jJvHOsXTpTDeGUgOw9Bqh/poUGd/rG4oGUq
# NODeqPk85sEwu8CgYyz8XBYAqNDEf+oRnR4GxqZtMl20OAkrSQeq/eww2vGnL8+3
# /frQo4TZJ577AWZ3uVYQ4SBuxq6x+ba6yDVdM3aO8XwgDCp3rrWiAoa6Ke60WgCx
# jKvj+QrJVF3UuWp0nr1IrpgwggcHMIIE76ADAgECAhEAjHegAI/00bDGPZ86SION
# azANBgkqhkiG9w0BAQwFADB9MQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRl
# ciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdv
# IExpbWl0ZWQxJTAjBgNVBAMTHFNlY3RpZ28gUlNBIFRpbWUgU3RhbXBpbmcgQ0Ew
# HhcNMjAxMDIzMDAwMDAwWhcNMzIwMTIyMjM1OTU5WjCBhDELMAkGA1UEBhMCR0Ix
# GzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEY
# MBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMSwwKgYDVQQDDCNTZWN0aWdvIFJTQSBU
# aW1lIFN0YW1waW5nIFNpZ25lciAjMjCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCC
# AgoCggIBAJGHSyyLwfEeoJ7TB8YBylKwvnl5XQlmBi0vNX27wPsn2kJqWRslTOrv
# QNaafjLIaoF9tFw+VhCBNToiNoz7+CAph6x00BtivD9khwJf78WA7wYc3F5Ok4e4
# mt5MB06FzHDFDXvsw9njl+nLGdtWRWzuSyBsyT5s/fCb8Sj4kZmq/FrBmoIgOrfv
# 59a4JUnCORuHgTnLw7c6zZ9QBB8amaSAAk0dBahV021SgIPmbkilX8GJWGCK7/Gs
# zYdjGI50y4SHQWljgbz2H6p818FBzq2rdosggNQtlQeNx/ULFx6a5daZaVHHTqad
# KW/neZMNMmNTrszGKYogwWDG8gIsxPnIIt/5J4Khg1HCvMmCGiGEspe81K9EHJaC
# IpUqhVSu8f0+SXR0/I6uP6Vy9MNaAapQpYt2lRtm6+/a35Qu2RrrTCd9TAX3+CNd
# xFfIJgV6/IEjX1QJOCpi1arK3+3PU6sf9kSc1ZlZxVZkW/eOUg9m/Jg/RAYTZG7p
# 4RVgUKWx7M+46MkLvsWE990Kndq8KWw9Vu2/eGe2W8heFBy5r4Qtd6L3OZU3b05/
# HMY8BNYxxX7vPehRfnGtJHQbLNz5fKrvwnZJaGLVi/UD3759jg82dUZbk3bEg+6C
# viyuNxLxvFbD5K1Dw7dmll6UMvqg9quJUPrOoPMIgRrRRKfM97gxAgMBAAGjggF4
# MIIBdDAfBgNVHSMEGDAWgBQaofhhGSAPw0F3RSiO0TVfBhIEVTAdBgNVHQ4EFgQU
# aXU3e7udNUJOv1fTmtufAdGu3tAwDgYDVR0PAQH/BAQDAgbAMAwGA1UdEwEB/wQC
# MAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwQAYDVR0gBDkwNzA1BgwrBgEEAbIx
# AQIBAwgwJTAjBggrBgEFBQcCARYXaHR0cHM6Ly9zZWN0aWdvLmNvbS9DUFMwRAYD
# VR0fBD0wOzA5oDegNYYzaHR0cDovL2NybC5zZWN0aWdvLmNvbS9TZWN0aWdvUlNB
# VGltZVN0YW1waW5nQ0EuY3JsMHQGCCsGAQUFBwEBBGgwZjA/BggrBgEFBQcwAoYz
# aHR0cDovL2NydC5zZWN0aWdvLmNvbS9TZWN0aWdvUlNBVGltZVN0YW1waW5nQ0Eu
# Y3J0MCMGCCsGAQUFBzABhhdodHRwOi8vb2NzcC5zZWN0aWdvLmNvbTANBgkqhkiG
# 9w0BAQwFAAOCAgEASgN4kEIz7Hsagwk2M5hVu51ABjBrRWrxlA4ZUP9bJV474TnE
# W7rplZA3N73f+2Ts5YK3lcxXVXBLTvSoh90ihaZXu7ghJ9SgKjGUigchnoq9pxr1
# AhXLRFCZjOw+ugN3poICkMIuk6m+ITR1Y7ngLQ/PATfLjaL6uFqarqF6nhOTGVWP
# CZAu3+qIFxbradbhJb1FCJeA11QgKE/Ke7OzpdIAsGA0ZcTjxcOl5LqFqnpp23Wk
# PnlomjaLQ6421GFyPA6FYg2gXnDbZC8Bx8GhxySUo7I8brJeotD6qNG4JRwW5sDV
# f2gaxGUpNSotiLzqrnTWgufAiLjhT3jwXMrAQFzCn9UyHCzaPKw29wZSmqNAMBew
# KRaZyaq3iEn36AslM7U/ba+fXwpW3xKxw+7OkXfoIBPpXCTH6kQLSuYThBxN6w21
# uIagMKeLoZ+0LMzAFiPJkeVCA0uAzuRN5ioBPsBehaAkoRdA1dvb55gQpPHqGRuA
# VPpHieiYgal1wA7f0GiUeaGgno62t0Jmy9nZay9N2N4+Mh4g5OycTUKNncczmYI3
# RNQmKSZAjngvue76L/Hxj/5QuHjdFJbeHA5wsCqFarFsaOkq5BArbiH903ydN+Qq
# BtbD8ddo408HeYEIE/6yZF7psTzm0Hgjsgks4iZivzupl1HMx0QygbKvz98xggWP
# MIIFiwIBATCBkDB8MQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5j
# aGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0
# ZWQxJDAiBgNVBAMTG1NlY3RpZ28gUlNBIENvZGUgU2lnbmluZyBDQQIQDue4N8WI
# aRr2ZZle0AzJjDAJBgUrDgMCGgUAoIGEMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3
# AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEW
# BBTNA0sFiIVphKhsJfSUOYZ9tVeMhzAkBgorBgEEAYI3AgEMMRYwFKASgBAAQwBB
# ACAAVABvAG8AbABzMA0GCSqGSIb3DQEBAQUABIIBAJB2hOdFzExBUh6jOEG0yhGd
# jd9PgXoAZJgSYl/a0pypvmQ5fuAA1w3V/r6yy7BLpJGw4ZH3F+b7xeWBUoLp6vFI
# BoCvv8Mx7+F7sNOHiNLjNXVY9GIi8pDYm/nuH3eifcElR8vP/+uepIxpz194+ek0
# L26jNun7iOhIoQewiyWNK2JIunxOS4cLUNO7IrfpzufJByjesU1bC95cX9Ff1mTW
# K76A3FlSV/m0u65K9KVpQ7NEpFk2PyHod5gWlXhVYzN0IZEyIqSrjq4KMIgkgrhC
# orFE/MEp7NoZ3prpeze4zc+k+KHNKsH09WnJRsGebwvrpxp9VVMPuPoFCOz453mh
# ggNMMIIDSAYJKoZIhvcNAQkGMYIDOTCCAzUCAQEwgZIwfTELMAkGA1UEBhMCR0Ix
# GzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEY
# MBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMSUwIwYDVQQDExxTZWN0aWdvIFJTQSBU
# aW1lIFN0YW1waW5nIENBAhEAjHegAI/00bDGPZ86SIONazANBglghkgBZQMEAgIF
# AKB5MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
# MTIxMDA5MzY0NFowPwYJKoZIhvcNAQkEMTIEMHETNLqTDlFmhw/bWID/ImZF+m8W
# k/zn/VhnZnZObWpCUnsgG3xMbceNjGQCvJpZvDANBgkqhkiG9w0BAQEFAASCAgAs
# ZV0M1UGLl0lUk3ceufrWwCM+fiAj08j48SSKRnPYFXVhUPVLhHAZHbbnLIVKjKO+
# i6sx/KqYQgsMSqAvDy2V/NMttkJegJI0vYJ2iNtbtP80HPXOaqgLU84b4+Bco4C9
# yOtgBrnQUojsYfTUU/uXw91wlPGWzTJrmIjKvPE+hLR/V7bCz+WajFBwPE5KGLmA
# O09j/054niGYPaily1fSArOawab5zNg7izqXkjSf9LQuCR4uJLetHkoRF+aZEbYN
# xo8wezf2a5gMntN795QH6yZSKlpnn+wmODyKSL/X+HG9ssAVzMFQpO49h/2gnpe8
# nhD3p9giWhkB9gG9yOpIRmSosZz08IFkQXmr+IEJdgd9pZh7nlguugxRkVYPHYnQ
# N8toUbt4itbQ5frKvJ7xxKZYV/Cm+HlYCzTOU8OPMIkoyQH5seOhatWWkp5xEW2l
# ETT3lsnDEaVCmqLTDIe6g14wjoK4HO1e6kzRZEGizWSKnWdzk9U977b+bmEzzfKT
# cuzXJGZKRN8IwHuNWNi1osUZCnn03o4WVDwPftDyiiio3czOT0J3Shhba/bDDXg1
# GxSJbsuRUzXGjntjcKszd8KYFVoa33JPcBi72bClCMj6+p4VJuv29jiw2yy2IniZ
# IWwgSKPMQLktzW8tmY6n/A83ZMQclOEw134s/B41Pw==
# SIG # End signature block
