param(
  [string]$ScarVersion = "",
  [string]$ScarConfig = ""
)

function New-RandomCode {
  <#
  .SYNOPSIS
  Generate a random code for the installation

  .DESCRIPTION
  Generates a random code for the installation every time the script is executed
  #>
  return -join (((48..57)+(65..90)+(97..122)) * 80 | Get-Random -Count 32 | ForEach-Object{ [char]$_ })
}

function Invoke-AcceptRequirement {
  <#
  .SYNOPSIS
  Execute a specific Action based on the type of Requirement
  .DESCRIPTION
  Once the user press the Accept button it will execute the Action specific to that Requirement
  #>
  # Get the current Requirement
  $CurrentRequirement = $RequirementsList[$IndexRequirement]
  # Save a message that will take track of the Requirements accepted by the user
  if ($CurrentRequirement.MaxVersion) {
    $Message = "ACCEPTED, Name = $($CurrentRequirement.Name), Version = $($CurrentRequirement.MaxVersion)`r`n$('-'*70)"
  } else {
    $Message = "ACCEPTED, Name = $($CurrentRequirement.Name)`r`n$('-'*70)"
  }
  Add-Content -Path $InstallRequirementsLogfile -Value $Message -Force

  # Calling only Show-Buttons will hide all the buttons
  Show-Buttons
  # It will execute a determinatedd function based on the type of the current requirement
  switch ($CurrentRequirement.Type) {
    "Software" {
      Invoke-DownloadInstallRequirementAction -Requirement $CurrentRequirement
    }
    "Feature" {
      Invoke-EnableFeatureAction -Requirement $CurrentRequirement
    }
    "Env Variable" {
      Invoke-EnvironmentVariableAction -Requirement $CurrentRequirement
    }
    "PostInstallSoftware" {
      Invoke-PostInstallAction -Requirement $CurrentRequirement
    }
    "Permission" {
      Invoke-PermissionAction -Requirement $CurrentRequirement
    }
    "Connection" {
      Invoke-ConnectionAction -Requirement $CurrentRequirement
    }
    "PreInstallSoftware" {
      Invoke-PreInstallAction -Requirement $CurrentRequirement
    }
    "Activity" {
      Invoke-ActivityAction -Requirement $CurrentRequirement
    }
    Default {
      Write-Error "$($CurrentRequirement.Type) not defined!!!"
    }
  }
  # Updates the Environment Variables
  Update-EnvPath
  # Execute the post action for the current Requirement if present.
  if ($CurrentRequirement.PostAction) {
    Show-ButtonsPostAction $CurrentRequirement.PostAction
  }
  # Once everything has been done the index of the current requirement will be incremented
  $script:IndexRequirement++
}

function Step-NextAction {
  <#
  .SYNOPSIS
  Show the Accept/Decline question for the next Requirement
  .DESCRIPTION
  Shows the Accept/Decline question for the next Requirement
  #>
  if ($IndexRequirement -lt $RequirementsList.Count) {
    $Description.Text = "$($RequirementsList[$IndexRequirement].QuestionMessage)`r`n"
    Show-Buttons @('$AcceptButton', '$DeclineButton')
  }
}
function Invoke-DeclineRequirement {
  <#
  .SYNOPSIS
  Append the declined message to the GUI
  .DESCRIPTION
  Shows on the GUI the decline message of the current Requirement
  #>
  $Requirement = $RequirementsList[$IndexRequirement]
  $MessageDeclined = Invoke-Expression (New-CommandString $Requirement.DeclineMessage)
  $Description.AppendText($MessageDeclined)
  # Save a message that will take track of the Requirements declined by the user
  if ($Requirement.MaxVersion) {
    $Message = "DECLINED, Name = $($Requirement.Name), Version = $($Requirement.MaxVersion)`r`n$('-'*70)"
  } else {
    $Message = "DECLINED, Name = $($Requirement.Name)`r`n$('-'*70)"
  }
  Add-Content -Path $InstallRequirementsLogfile -Value $Message -Force
  # Shows the Done button to close the installer
  Show-Buttons @('$DoneButton')
}

function Invoke-LoginNpm {
  <#
  .SYNOPSIS
  Login to npm
  .DESCRIPTION
  Takes the input inserted by the user and will try to login to npm
  #>
  # Variables Login npm
  $NpmRegistry = "https://devops.codearchitects.com:444/Code%20Architects/_packaging/ca-npm/npm/registry/"
  $NpmScope = "@ca"
  $NpmLoginResultCheckRequirementLogfile = "$($HOME)\.ca\npm_login_resultCheckRequirement_$($CurrentDate).log"
  # Check if the fields are empty it won't login
  if (($UsernameTextBox.Text -ne "") -and ($TokenTextBox.Text -ne "")) {
    # Correct the Username inserted by the User
    $UsernameSplitEmail = ($UsernameTextBox.Text).split("@")
    $UsernameWithoutEmail = $UsernameSplitEmail[0]
    $UsernameSplitBS = $UsernameWithoutEmail.split("\")
    $UsernameWithoutBS = $UsernameSplitBS[$UsernameSplitBS.Length - 1]
    $UsernameSplitS = $UsernameWithoutBS.split("/")
    $UsernameFinal = $UsernameSplitS[$UsernameSplitS.Length - 1]
    # Execute the login
    Start-Process powershell.exe -ArgumentList "npm-login.ps1 -user $UsernameFinal -token $($TokenTextBox.Text) -registry $NpmRegistry -scope $NpmScope" -WindowStyle hidden -RedirectStandardOutput $OutLogfile -RedirectStandardError $ErrLogfile -Wait
    Get-Content $ErrLogfile, $OutLogfile | Set-Content $NpmLoginResultCheckRequirementLogfile
    npm config set '@ca:registry' $NpmRegistry
    npm config set '@ca-codegen:registry' $NpmRegistry
    $NpmViewCli = (npm view @ca/cli 2>&1) -join " "
    $DoubleCheck = ($NpmViewCli -like "*ERR!*")
    # Double check if the credentials inserted are correct or not, if they are then go to the next step of the installation, otherwise ask for the correct credentials.
    if (!$DoubleCheck) {
      Hide-LoginNpmScreen
      $NpmLoginMessage = Get-Content $NpmLoginResultCheckRequirementLogfile
      $Description.Lines = $NpmLoginMessage
      Remove-WrongToken($TokenTextBox.Text)
      Show-Buttons @('$NextButton', '$CancelButton')
    } else {
      Show-NpmLoginError("Npm Login Error!`r`nThe Token or the Username are wrong. Check again your Username and Token.`r`nPS: Be sure that the token is setted as 'All Accessible Organization'.")
    }
  } else {
    Show-NpmLoginError("Username and Token can't be NULL! Please enter the Username and Password.")
  }
}

function Remove-WrongToken($CorrectToken) {
  <#
  .SYNOPSIS
  Remove the wrong tokens from the .tokens.json
  .DESCRIPTION
  If the login to npm was successful it will remove all the wrong tokens in the .tokens.json file
  #>
  $TokenPath = "~\.token.json"
  $TokenList = Get-Content $TokenPath | ConvertFrom-Json
  $NewTokenList = @()
  foreach ($t in $TokenList) {
    if ($t.token -eq $CorrectToken) {
      $NewTokenList += $t
    }
  }
  $NewTokenList | ConvertTo-Json | Set-Content -Path $TokenPath -Force
}

function Show-NpmLoginError($Msg) {
  <#
  .SYNOPSIS
  Show a message of error for the login to npm
  .DESCRIPTION
  Append to the Textbox the message of error for the npm login
  #>
  $Description.Text = ""
  $Description.SelectionStart = $Description.TextLength
  $Description.SelectionLength = 0
  $Description.SelectionColor = "Red"
  $Description.AppendText($Msg)
}

function Remove-BackofficeProject {
  <#
  .SYNOPSIS
  Remove the back-office project
  .DESCRIPTION
  If the project of test "back-office" was already create, delete it
  #>
  if (Test-Path $BackofficeProjectPath) {
    Remove-Item -Path $BackofficeProjectPath -Force -Recurse
  }
}

function Resolve-Dependencies($Dependencies) {
  <#
  .SYNOPSIS
  Resolve the dependencies of all the Requirements
  .DESCRIPTION
  Creates a new list of Requirements with their dependencies resolved
  #>
  $ResultRequirementDependencies = @()
  if ($Dependencies.Count -ne 0) {
    $ResultRequirementDependencies += $Dependencies
    foreach ($Dependency in $Dependencies) {
      foreach ($Requirement in $RequirementsList) {
        if ($Requirement.Name -eq $Dependency) {
          $ResultRequirementDependencies += Resolve-Dependencies $Requirement.Dependencies
        }
      }
    }
  }
  return $ResultRequirementDependencies
}

function Invoke-CheckRequirements($Requirements) {
  <#
  .SYNOPSIS
  Check if the Requirement was satisfied or not
  .DESCRIPTION
  For each Requirement it will check if it's satisfied or not,
  if the Requirement isn't satisfied then add it to the list of Requirements that have to be satisfied through the installer
  #>
  $ResultCheckRequirementList = @()
  # List of Requirements that have to be executed, no matter what
  $MustCheckRequirementList = @("Npm Login")
  foreach ($Requirement in $Requirements) {
    New-Logfiles $Requirement
    if ($Requirement.CheckRequirement) {
      $ResultCheckRequirement = Invoke-Expression (New-CommandString $Requirement.CheckRequirement)
      if (!(($ResultCheckRequirement[0] -eq $true) -and ($ResultCheckRequirement[1] -eq 'OK')) -or $MustCheckRequirementList.Contains($Requirement.Name)) {
        $ResultCheckRequirementList += $Requirement
      }
    }
  }
  return $ResultCheckRequirementList
}

function Invoke-AppendRequirementDescription {
  <#
  .SYNOPSIS
  Show on the GUI, each Requirement and their status
  .DESCRIPTION
  Shows each Requirement and their status that indicates if they were satisfied (OK) or not satisfied (KO) on the GUI
  #>
  $Description.AppendText("Requirement $(' ' * 16)| Status |`r`n$('-' * 37)|`r`n")
  foreach ($Item in $RequirementsList) {
    $NumberSpaces = 26 - ($Item.Name | Measure-Object -Character).Characters
    $DescriptionMessage ="$($Item.Name) $(' ' * $NumberSpaces) |"
    if ($RequirementsNotMetList.Contains($Item)) {
      $Description.SelectionStart = $Description.TextLength
      $Description.SelectionLength = 0
      $Description.SelectionColor = "Red"
      $Description.AppendText("$DescriptionMessage   KO   |")
      $Description.AppendText([Environment]::NewLine)
    } else {
      $Description.SelectionStart = $Description.TextLength
      $Description.SelectionLength = 0
      $Description.SelectionColor = "Green"
      $Description.AppendText("$DescriptionMessage   OK   |")
      $Description.AppendText([Environment]::NewLine)
    }
  }
}

function New-Logfiles($Requirement) {
  <#
  .SYNOPSIS
  Create the log files
  
  .DESCRIPTION
  Creates the files .out, .err and .log for the specific Requirement
  #>
  Invoke-NameLogfile $Requirement
  if (-not(Test-Path $OutLogfile)) {
    New-Item -Path $OutLogfile -Force | Out-Null
  }
  if (-not(Test-Path $ErrLogfile)) {
    New-Item -Path $ErrLogfile -Force | Out-Null
  }
  if (-not(Test-Path $Logfile)) {
    New-Item -Path $Logfile -Force | Out-Null
  }
}

function Invoke-NameLogfile($Requirement) {
  <#
  .SYNOPSIS
  Create the logfiles' names
  .DESCRIPTION
  Creates the full path of the file for a specific Requirement
  #>
  $NameNoSpaces = $Requirement.Name -replace " ", ""
  $script:Logfile = "$HOME\.ca\$RandomCode-$NameNoSpaces-$CurrentDate.log"
  $script:OutLogfile = "$HOME\.ca\$RandomCode-$NameNoSpaces-$CurrentDate.out"
  $script:ErrLogfile = "$HOME\.ca\$RandomCode-$NameNoSpaces-$CurrentDate.err"
}

function Update-EnvPath {
  <#
  .SYNOPSIS
  Update the Environment Variables
  .DESCRIPTION
  Update the Environment Variables without closing PowerShell
  #>
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
  $Description.AppendText("`r`nEnv var Path reloaded correctly")
}

function Close-Installer {
  <#
  .SYNOPSIS
  Actions to clean the computer before closing the installer
  .DESCRIPTION
  Actions needed to be run before cloging the installer, such as:
  kill the client's side process, removing the startup command, update the scarface.config.json and send the installation's results
  #>
  try {
    $NetStat4200 = (netstat -ano | findstr :4200).split(" ") | Select-Object -Unique
    $ClientPID = $NetStat4200[5]
    taskkill /PID $ClientPID /F
  }
  catch {
    Write-Host "No process running on port 4200"
  }
  Remove-StartupCmd
  Update-ScarfaceConfigJson
  Send-InstallationLogs
  $InstallForm.Close()
}

function Update-ScarfaceConfigJson {
  <#
  .SYNOPSIS
  Update the scarface.config.json
  .DESCRIPTION
  Removes some of the elements inside the file, such as:
  application, domain, scenario, author and prefix
  So that the next time the user execute the command "ca scar" those fields will be asked to them
  #>
  $ScarfaceConfigJsonPath = "C:\dev\scarface\scarface.config.json"
  $ScarfaceConfigJson = Get-Content -Path $ScarfaceConfigJsonPath -Raw | ConvertFrom-Json
  $ElementsToRemove = @("application", "domain", "scenario", "author", "prefix")
  foreach ($Element in $ElementsToRemove) {
    $ScarfaceConfigJson.PSObject.Properties.Remove($Element)
  }
  $ScarfaceConfigJson | ConvertTo-Json -Depth 5 | Out-File -Encoding "ASCII" $ScarfaceConfigJsonPath -Force
}

function New-StartupCmd {
  <#
  .SYNOPSIS
  Create a .cmd that will execute the CAEP installer at startup
  .DESCRIPTION
  Creates a .cmd that will execute the CAEP installer at startup until they won't complete it
  #>
  $ScriptPathParent = Split-Path -Parent $ScriptPath
  $CaepInstallerName = "\caep-installer.ps1"
  $ScriptArgs = ""
  if ($ScarConfig -ne "") {
    $ScriptArgs += " -ScarConfig " + $ScarConfig
  }
  if ($ScarVersion -ne "") {
    $ScriptArgs += " -ScarVersion " + $ScarVersion
  }
  if ($ScriptArgs -ne "") {
    $ScriptPathQuotes = "start powershell -Command `"Start-Process powershell -verb runas -ArgumentList '-NoExit -file " + $ScriptPathParent + $CaepInstallerName + $ScriptArgs +  "'`""
  } else {
    $ScriptPathQuotes = "start powershell -Command `"Start-Process powershell -verb runas -ArgumentList '-NoExit -file " + $ScriptPathParent + $CaepInstallerName + "'`""
  }
  
  if (!(Test-Path $StartupPath)) {
    New-Item -Path $StartupPath | Out-Null
    Add-Content -Path $StartupPath -Value "$ScriptPathQuotes"
  }
}

. .\scripts\common.ps1

#---------------------------------------------------------[Logic]--------------------------------------------------------

# Variables
$CurrentDate = (Get-Date -Format yyyyMMdd-hhmm).ToString()
$InstallRequirementsLogfile = "$($HOME)\.ca\install_requirements_$($CurrentDate).log"
$RandomCode = New-RandomCode

$ScriptPath = $MyInvocation.MyCommand.Path

$Logfile
$OutLogfile
$ErrLogfile

$IndexRequirement = 0
$BackofficeProjectPath = "C:\dev\scarface\back-office"
# Import scripts
. .\requirement-actions.ps1 -RandomCode $RandomCode -CurrentDate $CurrentDate -ScarVersion $ScarVersion -ScarConfig $ScarConfig
. .\send-logs.ps1 -ScriptPath $ScriptPath -CurrentDate $CurrentDate


# Main checks
$InternetStatus = Get-NetAdapter | Where-Object { ($_.Name -like "*Ethernet*" -or $_.Name -like "*Wi-Fi*") -and ($_.Status -eq "Up") }
$AdminStatus = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# Check if the user opened PowerShell as Admin, if not then stop the installation, otherwise check the requirements
if (-not $AdminStatus) {
  $Description.AppendText("PLEASE OPEN POWERSHELL AS ADMINISTRATOR!!!")
  Show-Buttons @('$DoneButton')
} elseif (-not $InternetStatus) {
  $Description.AppendText("PLEASE CONNECT TO INTERNET!!!")
  Show-Buttons @('$DoneButton')
} else {
  # Resolve the Requirement's dependencies
  $RequirementsJsonPath = ".\requirements.json"

  $RequirementsList = Get-Content $RequirementsJsonPath | ConvertFrom-Json

  for ($i = 0; $i -lt $RequirementsList.Count; $i++) {
    $RequirementsList[$i].Dependencies = (Resolve-Dependencies $RequirementsList[$i].Dependencies) | Select-Object -Unique
  }

  $RequirementsList = @($RequirementsList | Sort-Object -Property {$_.Dependencies.Count})

  $RequirementsNotMetList = Invoke-CheckRequirements $RequirementsList

  Invoke-AppendRequirementDescription

  $RequirementsList = $RequirementsNotMetList

  Remove-BackofficeProject
  New-StartupCmd
}

# SIG # Begin signature block
# MIIk2wYJKoZIhvcNAQcCoIIkzDCCJMgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUqWTgAEv16N9CE4WRzJRTp7pn
# y3uggh62MIIFOTCCBCGgAwIBAgIQDue4N8WIaRr2ZZle0AzJjDANBgkqhkiG9w0B
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
# BBQ49Re9rYyeirYeHtyOe6huoPgjszAkBgorBgEEAYI3AgEMMRYwFKASgBAAQwBB
# ACAAVABvAG8AbABzMA0GCSqGSIb3DQEBAQUABIIBAJ5e/hs+R71i8UW9+QzNCbpk
# EaFt8oOCh8IEcHqHoD/1KqwBUeipcB3SOmshG04nDNkAGV/RQKbpVKQolDqus7Wy
# 91na/VC0ae5gYADfFhSRSjBk3g2ud7bIyHThB7++JTaeiySHu4R0tE3fWPYAoP0Y
# ir3/3WyvBFufTNUB2ERBe1wC6NDSe7hRr39f372Oaxe5RstFxL2fdQ3MtsrhD8PY
# cAHocU/wQa59VBYgZqQ3NFk5Daxf9pbl7sKafIconz5Mlh1Q5BOOlIC8VaWRsk5M
# 2z3b10cIsksz6R2GdqTVJvEvzABEcR+ih9qEjyL1NGQYbzjRA2yRidLFhNpPHp+h
# ggNMMIIDSAYJKoZIhvcNAQkGMYIDOTCCAzUCAQEwgZIwfTELMAkGA1UEBhMCR0Ix
# GzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEY
# MBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMSUwIwYDVQQDExxTZWN0aWdvIFJTQSBU
# aW1lIFN0YW1waW5nIENBAhEAjHegAI/00bDGPZ86SIONazANBglghkgBZQMEAgIF
# AKB5MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIy
# MDUwNjE0MjUwOVowPwYJKoZIhvcNAQkEMTIEMHf8RW1h8cqr1zolef7soQta2T+q
# fH3SLVy6OmJHf5T2sJ2748of3/fZ0QfEfq8yvDANBgkqhkiG9w0BAQEFAASCAgAK
# piH2nckf66NvBtvkIXmYZdl5EWDztZ1jqsJrxrXIYNw18eMfuWoWmVoQZvC4FAo9
# tW6YVd/Ppml7UH5gdR4HfYcrvpZrJnjadItpRqkW6G3liSYpivI7A8bz/NIOehij
# eWIFRtZJqv6Pc0TGyNIyNdHiDi7gbAuy+IeAsrBn36weeKpO+9ka+Qqvy8wlbZS6
# E3DxmrxZKX5ooWyV+wujQPnxv6vuuZOHQ1u+mK5fLCt5Y8JvpjdFLseCeu+mslw6
# F/CDatStIckuqsrOhIGRl6eP9yJ+hIoaqaB5NdMNY6WRfkDipYEDWGInhHmZcp6b
# 28DXtNsItM/4LTK0IG+XsspSzCTV5qXP8FoUKpnUezOgG9FrOoPWS+TglY48NiBN
# Rk/FTHnSglsY9jglbFWLu4aFFtlwjfayxezr+oZlI1Ub2A3qrJlgJesp6uT+cHaU
# faLReIZ0wc6SkkJZ2FTM2Zh8dELhAIk7Fw50EJpNSgZoSzKWjGmeaMtuovNz7XNq
# sI618+7ZdOhzBhT2lyw+xzaDXNGvg17+JpeV1C0V7gpzYwWqN2nR/YNYzN8cHJZF
# OiGsPDrqaXV9072b3PviMMUMLvFynqlmauOWKKOX/GAJoba8zZsTdjt/WpTm9IIt
# NB50nS96KJv6hczV1g10wJo8jJN4BB/bopaE5cZaSw==
# SIG # End signature block
