param(
  [string]$ScarVersion = "",
  [string]$ScarConfig = "",
  [string]$currentDate,
  [bool]$addNodeBuildTools
)

function Update-EnvPath {
  <#
  .SYNOPSIS
  Update the Environment Variables
  .DESCRIPTION
  Update the Environment Variables without closing PowerShell
  #>
  $env:PATH = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
  $Description.AppendText("`r`nEnv var Path reloaded correctly")
}

function New-RandomCode {
  <#
  .SYNOPSIS
  Generate a random code for the installation

  .DESCRIPTION
  Generates a random code for the installation every time the script is executed
  #>
  return -join (((48..57) + (65..90) + (97..122)) * 80 | Get-Random -Count 32 | ForEach-Object { [char]$_ })
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
  }
  else {
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
    "Env Variable Path" {
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
  }
  else{
    $Description.Text = "$($RequirementsList.QuestionMessage)`r`n"
  }
  Show-Buttons @('$AcceptButton', '$DeclineButton')
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
  }
  else {
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
    Start-Process powershell.exe -ArgumentList "npm-login.ps1 -user $UsernameFinal -token $($TokenTextBox.Text) -registry $NpmRegistry -scope $NpmScope" -NoNewWindow -Wait
    npm config set '@ca:registry' $NpmRegistry
    npm config set '@ca-codegen:registry' $NpmRegistry
    $NpmViewCli = (npm view @ca/cli 2>&1) -join " "
    $DoubleCheck = ($NpmViewCli -like "*ERR!*")
    # Double check if the credentials inserted are correct or not, if they are then go to the next step of the installation, otherwise ask for the correct credentials.
    if (!$DoubleCheck) {
      Hide-LoginNpmScreen
      $Description.Lines = $NpmViewCli
      Remove-WrongToken($TokenTextBox.Text)
      Show-Buttons @('$NextButton', '$CancelButton')
    }
    else {
      Show-NpmLoginError("Npm Login Error!`r`nThe Token or the Username are wrong. Check again your Username and Token.`r`nPS: Be sure that the token is setted as 'All Accessible Organization'.")
    }
  }
  else {
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
  $MustCheckRequirementList = @("Execute ca scar")
  foreach ($Requirement in $Requirements) {
    if ($Requirement.CheckRequirement) {
      $ResultCheckRequirement = Invoke-Expression (New-CommandString $Requirement.CheckRequirement)
      if ( (!(($ResultCheckRequirement[0] -eq $true) -and ($ResultCheckRequirement[1] -eq 'OK'))) -or ( $MustCheckRequirementList -contains $Requirement.Name ) ) {
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
    $DescriptionMessage = "$($Item.Name) $(' ' * $NumberSpaces) |"
    $Description.SelectionStart = $Description.TextLength
    $Description.SelectionLength = 0
    
    if (($RequirementsNotMetList -is [array] -and $RequirementsNotMetList.Contains($Item)) -or $RequirementsNotMetList.Name -eq $Item.Name) {
      $Description.SelectionColor = "Red"
      $Description.AppendText("$DescriptionMessage   KO   |")
    }
    else {
      $Description.SelectionColor = "Green"
      $Description.AppendText("$DescriptionMessage   OK   |")
    }

    $Description.AppendText([Environment]::NewLine)
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
  $script:Logfile = "$HOME\.ca\$NameNoSpaces-$currentDate-caep.log"
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
  $CaepInstallerName = "caep-installer.ps1"
  $CaepInstallerPath = "\`"$(Join-Path $ScriptPathParent $CaepInstallerName)\`""
  $ScriptArgs = ""
  $ScriptCaepContent = ""
  if ($ScarConfig -ne "") {
    $ScriptArgs += " -ScarConfig " + $ScarConfig
  }
  if ($ScarVersion -ne "") {
    $ScriptArgs += " -ScarVersion " + $ScarVersion
  }
  if ($ScriptArgs -ne "") {
    $ScriptCaepContent = $CaepInstallerPath + $ScriptArgs
  }
  else {
    $ScriptCaepContent = $CaepInstallerPath
  }

  $ScriptCmdContent = "start powershell -Command `"Start-Process powershell -verb runas -ArgumentList '-NoExit -file " + $ScriptCaepContent + "'`""
  if (!(Test-Path $StartupPath)) {
    New-Item -Path $StartupPath | Out-Null
    Add-Content -Path $StartupPath -Value "$ScriptCmdContent"
  }
}

function ConvertPSObjectToHashtable { 
  param (
    [Parameter(ValueFromPipeline)]
    $InputObject
  )

  process {
    if ($null -eq $InputObject) { return $null }

    if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) {
      $collection = @(
        foreach ($object in $InputObject) { ConvertPSObjectToHashtable $object }
      )

      Write-Output -NoEnumerate $collection
    }
    elseif ($InputObject -is [psobject]) {
      $hash = @{}

      foreach ($property in $InputObject.PSObject.Properties) {
        $hash[$property.Name] = ConvertPSObjectToHashtable $property.Value
      }

      $hash
    }
    else {
      $InputObject
    }
  }
}


function Download-ScarConfigJson {
  <#
  .SYNOPSIS
  Download scarface.config.json
  .DESCRIPTION
  Download scarface.config.json
  #>

  $scarConfigPath = "C:\dev\scarface\scarface.config.json"
  if ( Test-Path $scarConfigPath) {
    Remove-Item -Path $scarConfigPath -Force
  }
  New-Item -Path $scarConfigPath -Force | Out-Null

  Write-Host "downloading $ScarConfig"
  $ScarConfigObj = (Invoke-WebRequest -Uri $ScarConfig -UseBasicParsing).Content
  Set-Content -Path $scarConfigPath -Value $scarConfigObj
  $scarConfigObj = $ScarConfigObj | ConvertFrom-Json

  if ($ScarConfigObj.overrideRequirement) {
    Write-Host "downloading " + $ScarConfigObj.overrideRequirement
    $retval = (Invoke-WebRequest -Uri $ScarConfigObj.overrideRequirement -UseBasicParsing).Content | ConvertFrom-Json
    return $retval
  }
  return $false
}

function Override-Requirement($Requirements) {
  <#
  .SYNOPSIS
  Override custom json to Requirements
  .DESCRIPTION
  Override custom json to Requirements
  #>

  $overrideJson = Download-ScarConfigJson
  if (!($overrideJson)) {
    Write-Host "No override found"
    return $Requirements
  }
  
  foreach ($Requirement in $Requirements) {
    foreach ($overrideRequirement in $overrideJson) {
      if ($Requirement.Name -eq $overrideRequirement.Name) {
        $hashtableReq = ConvertPSObjectToHashtable $overrideRequirement
        foreach ($element in $hashtableReq.GetEnumerator()) {
          if ($element.Key -in $Requirement.PSobject.Properties.Name) {
            $Requirement.($element.Key) = $element.Value
          }
        }
        break
      }
    }
  }
  
  return $Requirements
}

. .\scripts\common.ps1

# Create scar folder beforehand with download directory
$downloadExeFolder = "C:\dev\scarface\download\"
if ( !( Test-Path -Path $downloadExeFolder ) ) {
  Write-Host "$downloadExeFolder not found. Creating it..."
  New-Item -Path $downloadExeFolder -ItemType Directory
}

#---------------------------------------------------------[Logic]--------------------------------------------------------

# Variables
$InstallRequirementsLogfile = "$($HOME)\.ca\install_requirements_$($currentDate).log"
$RandomCode = New-RandomCode

$ScriptPath = $MyInvocation.MyCommand.Path

$IndexRequirement = 0
$BackofficeProjectPath = "C:\dev\scarface\back-office"

# Import scripts
. .\requirement-actions.ps1 -RandomCode $RandomCode -currentDate $currentDate -ScarVersion $ScarVersion -ScarConfig $ScarConfig
. .\send-logs.ps1 -ScriptPath $ScriptPath -currentDate $currentDate

# Main checks
$InternetStatus = Get-NetAdapter | Where-Object { ($_.Name -like "*Ethernet*" -or $_.Name -like "*Wi-Fi*") -and ($_.Status -eq "Up") }
$AdminStatus = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# Check if the user opened PowerShell as Admin, if not then stop the installation, otherwise check the requirements
if (-not $AdminStatus) {
  $Description.AppendText("PLEASE OPEN POWERSHELL AS ADMINISTRATOR!!!")
  Show-Buttons @('$DoneButton')
}
elseif (-not $InternetStatus) {
  $Description.AppendText("PLEASE CONNECT TO INTERNET!!!")
  Show-Buttons @('$DoneButton')
}
else {
  # Resolve the Requirement's dependencies
  $RequirementsJsonPath = ".\requirements.json"

  $RequirementsList = Get-Content $RequirementsJsonPath | ConvertFrom-Json

  for ($i = 0; $i -lt $RequirementsList.Count; $i++) {
    $RequirementsList[$i].Dependencies = (Resolve-Dependencies $RequirementsList[$i].Dependencies) | Select-Object -Unique
  }

  $RequirementsList = @($RequirementsList | Sort-Object -Property { $_.Dependencies.Count })

  $RequirementsList = Override-Requirement -Requirements $RequirementsList

  $RequirementsNotMetList = Invoke-CheckRequirements $RequirementsList

  Invoke-AppendRequirementDescription

  $RequirementsList = $RequirementsNotMetList

  Remove-BackofficeProject
  New-StartupCmd
}
# SIG # Begin signature block
# MIIkygYJKoZIhvcNAQcCoIIkuzCCJLcCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUxg2mq5oq5zVoFwLI6bItIWbX
# PIqggh6lMIIFOTCCBCGgAwIBAgIQDue4N8WIaRr2ZZle0AzJjDANBgkqhkiG9w0B
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
# jKvj+QrJVF3UuWp0nr1Irpgwggb2MIIE3qADAgECAhEAkDl/mtJKOhPyvZFfCDip
# QzANBgkqhkiG9w0BAQwFADB9MQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRl
# ciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdv
# IExpbWl0ZWQxJTAjBgNVBAMTHFNlY3RpZ28gUlNBIFRpbWUgU3RhbXBpbmcgQ0Ew
# HhcNMjIwNTExMDAwMDAwWhcNMzMwODEwMjM1OTU5WjBqMQswCQYDVQQGEwJHQjET
# MBEGA1UECBMKTWFuY2hlc3RlcjEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMSww
# KgYDVQQDDCNTZWN0aWdvIFJTQSBUaW1lIFN0YW1waW5nIFNpZ25lciAjMzCCAiIw
# DQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAJCycT954dS5ihfMw5fCkJRy7Vo6
# bwFDf3NaKJ8kfKA1QAb6lK8KoYO2E+RLFQZeaoogNHF7uyWtP1sKpB8vbH0uYVHQ
# jFk3PqZd8R5dgLbYH2DjzRJqiB/G/hjLk0NWesfOA9YAZChWIrFLGdLwlslEHzld
# nLCW7VpJjX5y5ENrf8mgP2xKrdUAT70KuIPFvZgsB3YBcEXew/BCaer/JswDRB8W
# KOFqdLacRfq2Os6U0R+9jGWq/fzDPOgNnDhm1fx9HptZjJFaQldVUBYNS3Ry7qAq
# MfwmAjT5ZBtZ/eM61Oi4QSl0AT8N4BN3KxE8+z3N0Ofhl1tV9yoDbdXNYtrOnB78
# 6nB95n1LaM5aKWHToFwls6UnaKNY/fUta8pfZMdrKAzarHhB3pLvD8Xsq98tbxpU
# UWwzs41ZYOff6Bcio3lBYs/8e/OS2q7gPE8PWsxu3x+8Iq+3OBCaNKcL//4dXqTz
# 7hY4Kz+sdpRBnWQd+oD9AOH++DrUw167aU1ymeXxMi1R+mGtTeomjm38qUiYPvJG
# DWmxt270BdtBBcYYwFDk+K3+rGNhR5G8RrVGU2zF9OGGJ5OEOWx14B0MelmLLsv0
# ZCxCR/RUWIU35cdpp9Ili5a/xq3gvbE39x/fQnuq6xzp6z1a3fjSkNVJmjodgxpX
# fxwBws4cfcz7lhXFAgMBAAGjggGCMIIBfjAfBgNVHSMEGDAWgBQaofhhGSAPw0F3
# RSiO0TVfBhIEVTAdBgNVHQ4EFgQUJS5oPGuaKyQUqR+i3yY6zxSm8eAwDgYDVR0P
# AQH/BAQDAgbAMAwGA1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgw
# SgYDVR0gBEMwQTA1BgwrBgEEAbIxAQIBAwgwJTAjBggrBgEFBQcCARYXaHR0cHM6
# Ly9zZWN0aWdvLmNvbS9DUFMwCAYGZ4EMAQQCMEQGA1UdHwQ9MDswOaA3oDWGM2h0
# dHA6Ly9jcmwuc2VjdGlnby5jb20vU2VjdGlnb1JTQVRpbWVTdGFtcGluZ0NBLmNy
# bDB0BggrBgEFBQcBAQRoMGYwPwYIKwYBBQUHMAKGM2h0dHA6Ly9jcnQuc2VjdGln
# by5jb20vU2VjdGlnb1JTQVRpbWVTdGFtcGluZ0NBLmNydDAjBggrBgEFBQcwAYYX
# aHR0cDovL29jc3Auc2VjdGlnby5jb20wDQYJKoZIhvcNAQEMBQADggIBAHPa7Why
# y8K5QKExu7QDoy0UeyTntFsVfajp/a3Rkg18PTagadnzmjDarGnWdFckP34PPNn1
# w3klbCbojWiTzvF3iTl/qAQF2jTDFOqfCFSr/8R+lmwr05TrtGzgRU0ssvc7O1q1
# wfvXiXVtmHJy9vcHKPPTstDrGb4VLHjvzUWgAOT4BHa7V8WQvndUkHSeC09NxKoT
# j5evATUry5sReOny+YkEPE7jghJi67REDHVBwg80uIidyCLxE2rbGC9ueK3EBbTo
# hAiTB/l9g/5omDTkd+WxzoyUbNsDbSgFR36bLvBk+9ukAzEQfBr7PBmA0QtwuVVf
# R745ZM632iNUMuNGsjLY0imGyRVdgJWvAvu00S6dOHw14A8c7RtHSJwialWC2fK6
# CGUD5fEp80iKCQFMpnnyorYamZTrlyjhvn0boXztVoCm9CIzkOSEU/wq+sCnl6jq
# tY16zuTgS6Ezqwt2oNVpFreOZr9f+h/EqH+noUgUkQ2C/L1Nme3J5mw2/ndDmbhp
# LXxhL+2jsEn+W75pJJH/k/xXaZJL2QU/bYZy06LQwGTSOkLBGgP70O2aIbg/r6ay
# UVTVTMXKHxKNV8Y57Vz/7J8mdq1kZmfoqjDg0q23fbFqQSduA4qjdOCKCYJuv+P2
# t7yeCykYaIGhnD9uFllLFAkJmuauv2AV3Yb1MYIFjzCCBYsCAQEwgZAwfDELMAkG
# A1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMH
# U2FsZm9yZDEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMSQwIgYDVQQDExtTZWN0
# aWdvIFJTQSBDb2RlIFNpZ25pbmcgQ0ECEA7nuDfFiGka9mWZXtAMyYwwCQYFKw4D
# AhoFAKCBhDAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgEL
# MQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUO8t+4gDFPr7Ogo1X9/JO
# ocQe2jQwJAYKKwYBBAGCNwIBDDEWMBSgEoAQAEMAQQAgAFQAbwBvAGwAczANBgkq
# hkiG9w0BAQEFAASCAQAyrPdw3jhPb6E3OzV1qQA4pNWd0Z4jhiRzVg9GMoQ20Dp4
# Fol8ns2K7MXBlpP695q05tf2ufj2U9OQysT3YmlM7fHuMbMIp+dVapdtlfGzhYCF
# MLX/wBX3TKIK6Ll0Vy/SjcAN8tUtwsZjr5oN2E+UC0YNdhfwacKrSMRJnSGs3naf
# vlLhhlCT2V/NhZWcLceKVVMQuamMQoYA9O5rTj/sQrGwXpKwiH8AqM8bM4YSpL5J
# XhhQEEWfOgPeRxeNwFZIMtmUZPOvdCF6iUIOVpZnepo05OB4nyYDj4W5wuTls+zy
# jZ1RtLSc6LT484VwC96QP0V8sQlvv73ZkP1efutuoYIDTDCCA0gGCSqGSIb3DQEJ
# BjGCAzkwggM1AgEBMIGSMH0xCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVy
# IE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGDAWBgNVBAoTD1NlY3RpZ28g
# TGltaXRlZDElMCMGA1UEAxMcU2VjdGlnbyBSU0EgVGltZSBTdGFtcGluZyBDQQIR
# AJA5f5rSSjoT8r2RXwg4qUMwDQYJYIZIAWUDBAICBQCgeTAYBgkqhkiG9w0BCQMx
# CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMzAyMDgwOTM4NTdaMD8GCSqG
# SIb3DQEJBDEyBDA8+VLOaYL0l8998ketYLBfEYvDEQG7IBCq8yrS2yH5gE0OODss
# aqWBqJhqz6HIpMswDQYJKoZIhvcNAQEBBQAEggIAGID7RQCJ/OlUYrnyseiVy54n
# +OhpPwMNPRU85wsJ8hODX8oPsSZQSixpln7Ld8Hs2cVuKyLD2K0+gkkEWMXQUPWa
# 0G1ToYOqcRG6enUGoCKfOUI3R+ezVe/J9aVK3NT9nAJ9RzPVqmIUketWDEB6yOAD
# Ddfat14IpdtdhEc8jwapV/wV+kYhWkniX0Eb1a1mVFp+eMmK7tfIfp1uxFJpMrVK
# DIDtCkmXMrKCWJgLTW4icUfS5VWS/j7R43EwWrQrWxT+/F3HAey6u4XBYFLEHQxi
# 7GZtw2wB79JA26EVtX/z+g4uiwL2YKp09VBR3pOKwU0F0dTaM0qepGh5HMPCsWL/
# cDvsiPqAuxUV3p1pNrch1TfupYxpz0F8wMH0/kRNokGLs90LgXzYtWg6aZ/AP0Ks
# ePrRaZ5JyoF6K2x0rf30oXCZGer3Eoa8XvQlEZAeVB75xGSv+j01+07m+vuxlcQl
# mI/A5Fq59JY+qo/0yKWOKxbUD4RdRu9Hr3IrbY4YwAMJ8WqKNLoXoIkm0kDti9AE
# s3otusQj14nGJs+mgAHWF+T3Xb8AZM1XI7JuVX2CjbWe3Tp7eyWMbrPoTsUYcfux
# Fz3EU68Xf70F0gaaNvQeIL9NxmDydtK5O3CvXX42KaKMDKtOZrJowonSkSWoPKu0
# V7N5WUjJUzxjJVCtPjs=
# SIG # End signature block
