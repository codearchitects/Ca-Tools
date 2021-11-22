param(
  [switch]$Silent,
  [string]$ScarVersion = ""
)

#---------------------------------------------------------[Initialisations]--------------------------------------------------------
# Init PowerShell Gui
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#---------------------------------------------------------[Form]--------------------------------------------------------

[System.Windows.Forms.Application]::EnableVisualStyles()

$InstallForm                    = New-Object System.Windows.Forms.Form
$InstallForm.ClientSize         = '600,400'
$InstallForm.Text               = "Install Ca Platform"
$InstallForm.BackColor          = "#ffffff"
$InstallForm.TopMost            = $false

$Title                          = New-Object System.Windows.Forms.Label
$Title.Text                     = "Install Ca Platform"
$Title.AutoSize                 = $true
$Title.Width                    = 25
$Title.Height                   = 10
$Title.Location                 = New-Object System.Drawing.Point(20,20)
$Title.Font                     = 'Microsoft Sans Serif,13,style=Bold'

$Description                    = New-Object System.Windows.Forms.TextBox
$Description.Text               = ""
$Description.AutoSize           = $false
$Description.Multiline          = $true
$Description.ReadOnly           = $true
$Description.Scrollbars         = "Vertical"
$Description.Width              = 560
$Description.Height             = 250
$Description.Location           = New-Object System.Drawing.Point(20,50)
$Description.Font               = 'Microsoft Sans Serif,10'

$UsernameLabel                  = New-Object System.Windows.Forms.Label
$UsernameLabel.Text             = "Username:"
$UsernameLabel.AutoSize         = $true
$UsernameLabel.Width            = 25
$UsernameLabel.Height           = 20
$UsernameLabel.Location         = New-Object System.Drawing.Point(70,143)
$UsernameLabel.Font             = 'Microsoft Sans Serif,10,style=Bold'
$UsernameLabel.Visible          = $false

$UsernameTextBox                = New-Object System.Windows.Forms.TextBox
$UsernameTextBox.Multiline      = $false
$UsernameTextBox.Width          = 200
$UsernameTextBox.Height         = 20
$UsernameTextBox.Location       = New-Object System.Drawing.Point(150,140)
$UsernameTextBox.Font           = 'Microsoft Sans Serif,10'
$UsernameTextBox.Visible        = $false

$TokenLabel                     = New-Object System.Windows.Forms.Label
$TokenLabel.Text                = "Token:"
$TokenLabel.AutoSize            = $true
$TokenLabel.Width               = 25
$TokenLabel.Height              = 20
$TokenLabel.Location            = New-Object System.Drawing.Point(70,173)
$TokenLabel.Font                = 'Microsoft Sans Serif,10,style=Bold'
$TokenLabel.Visible             = $false

$TokenTextBox                   = New-Object System.Windows.Forms.TextBox
$TokenTextBox.Multiline         = $false
$TokenTextBox.Width             = 200
$TokenTextBox.Height            = 20
$TokenTextBox.Location          = New-Object System.Drawing.Point(150,170)
$TokenTextBox.Font              = 'Microsoft Sans Serif,10'
$TokenTextBox.Visible           = $false

$NextButton                     = New-Object System.Windows.Forms.Button
$NextButton.BackColor           = "#ff7b00"
$NextButton.Text                = "Next"
$NextButton.Width               = 90
$NextButton.Height              = 30
$NextButton.Location            = New-Object System.Drawing.Point(450,330)
$NextButton.Font                = 'Microsoft Sans Serif,10'
$NextButton.ForeColor           = "#ffffff"

$LoginButton                     = New-Object System.Windows.Forms.Button
$LoginButton.BackColor           = "#ff7b00"
$LoginButton.Text                = "Login"
$LoginButton.Width               = 90
$LoginButton.Height              = 30
$LoginButton.Location            = New-Object System.Drawing.Point(450,330)
$LoginButton.Font                = 'Microsoft Sans Serif,10'
$LoginButton.ForeColor           = "#ffffff"
$LoginButton.Visible             = $false

$DoneButton                     = New-Object System.Windows.Forms.Button
$DoneButton.BackColor           = "#ff7b00"
$DoneButton.Text                = "Done"
$DoneButton.Width               = 90
$DoneButton.Height              = 30
$DoneButton.Location            = New-Object System.Drawing.Point(450,330)
$DoneButton.Font                = 'Microsoft Sans Serif,10'
$DoneButton.ForeColor           = "#ffffff"
$DoneButton.Visible             = $false

$AcceptButton                     = New-Object System.Windows.Forms.Button
$AcceptButton.BackColor           = "#ff7b00"
$AcceptButton.Text                = "Accept"
$AcceptButton.Width               = 90
$AcceptButton.Height              = 30
$AcceptButton.Location            = New-Object System.Drawing.Point(450,330)
$AcceptButton.Font                = 'Microsoft Sans Serif,10'
$AcceptButton.ForeColor           = "#ffffff"
$AcceptButton.Visible             = $false

$DeclineButton                   = New-Object System.Windows.Forms.Button
$DeclineButton.BackColor         = "#ffffff"
$DeclineButton.Text              = "Decline"
$DeclineButton.Width             = 90
$DeclineButton.Height            = 30
$DeclineButton.Location          = New-Object System.Drawing.Point(350,330)
$DeclineButton.Font              = 'Microsoft Sans Serif,10'
$DeclineButton.ForeColor         = "#000"
$DeclineButton.Visible           = $false

$CancelButton                   = New-Object System.Windows.Forms.Button
$CancelButton.BackColor         = "#ffffff"
$CancelButton.Text              = "Cancel"
$CancelButton.Width             = 90
$CancelButton.Height            = 30
$CancelButton.Location          = New-Object System.Drawing.Point(350,330)
$CancelButton.Font              = 'Microsoft Sans Serif,10'
$CancelButton.ForeColor         = "#000"
$CancelButton.DialogResult      = [System.Windows.Forms.DialogResult]::Cancel
$InstallForm.CancelButton       = $CancelButton
$InstallForm.Controls.Add($CancelButton)

$InstallForm.controls.AddRange(@($Title,
$Description,
$UsernameLabel,
$TokenLabel,
$UsernameTextBox,
$TokenTextBox,
$LoginButton,
$NextButton,
$CancelButton,
$DoneButton,
$AcceptButton,
$DeclineButton))

#---------------------------------------------------------[Functions]--------------------------------------------------------
<# ShowDoneButton
Hide all the buttons and shows the Done button
#>
function ShowDoneButton {
  $CancelButton.Visible = $false
  $NextButton.Visible = $false
  $DeclineButton.Visible = $false
  $AcceptButton.Visible = $false
  $DoneButton.Visible = $true
}

<# ShowAcceptDeclineButton
Shows the Accept and Decline buttons,
to let the user choice if he wants the script to download and install the requirement automatically
#>
function ShowAcceptDeclineButton {
  $DeclineButton.Visible = $true
  $AcceptButton.Visible = $true
  $CancelButton.Visible = $false
  $NextButton.Visible = $false
}

<# HideAcceptDeclineButton
Hides the Accept and Decline buttons
#>
function HideAcceptDeclineButton {
  $CancelButton.Visible = $true
  $NextButton.Visible = $true
  $DeclineButton.Visible = $false
  $AcceptButton.Visible = $false
}

<# ShowMainScreen
Shows the Intro screen, after all requirements are met
#>
function ShowMainScreen {
  $Title.Text = "Intro"
  $Description.Text = "With the install-platform.ps1, we are going to:`r`n 1) Install Ca-Tools`r`n 2) Login to npm`r`n 3) Intall Ca-Platform`r`n 4) Installing VSCode extensions`r`n 5) Execute ca scar`r`n`r`nCheck the Documentation for more information."
  $script:StatusInstallation++
}

<# ShowDownloadAndInstallRequirementScreen
Shows the screen asking for the permission to download and install the $CurrentRequirement
#>
function ShowDownloadAndInstallRequirementScreen {
  $Title.Text = "Download Requirements"
  ShowAcceptDeclineButton
  $script:CurrentRequirement = $RequirementsNotMet[$IndexRequirement]
  
  if ($CurrentRequirement.Status -like "*Not enabled*") {
    $Description.Text = "Do you want to enable $($CurrentRequirement.Requirement)?`r`n"
  }
  elseif ($CurrentRequirement.Requirement -ne "npm" -and $CurrentRequirement.Status -like "*Not Found*") {
    $Description.Text = "Do you want to download and install automatically $($CurrentRequirement.Requirement)?`r`n"
  }
  else {
    $Description.Text = "The version $($CurrentRequirement.Version) of $($CurrentRequirement.Requirement) is not supported"
    if ($CurrentRequirement.Requirement -ne "npm") {
      $Description.AppendText("Do you want to change the version of $CurrentRequirement.Requirement automatically?")
    }
  }
}

<# CheckRequirments
Checks if the requirements are met or not.
Shows the result of the check.
If a requirement isn't met than store it inside the variable $RequirementsNotMet or $EnvironmentRequirementsNotMet
#>
function CheckRequirements {
  . ./check-requirements.ps1

  $Title.Text = "Check Requirements"
  $Description.Text = "SOFTWARE REQUIREMENTS`r`n------------------------------------------------------------------------------------`r`n"
  $Description.Text += "Status`tVersion`tRequirements`r`n"
  foreach ($item in $requirements) {
    $Description.AppendText("$($item.Status)`t$($item.Version)`t$($item.Requirement)`r`n")
    if ($item.Status -like "*KO*") {
      $script:RequirementsNotMet += $item
    }
  }
  $Description.Text += "`r`nENVIRONMENT VARIABLES REQUIREMENTS`r`n------------------------------------------------------------------------------------`r`n"
  $Description.Text += "Status`tEnvironment Requirements`r`n"
  foreach ($item in $envRequirements) {
    $Description.AppendText("$($item.Status)`t$($item.EnvironmentVariable)`r`n")
    if ($item.Status -like "*KO*") {
      $script:EnvironmentRequirementsNotMet += $item
    }
  }

  if ($EnvironmentRequirementsNotMet.Count -ne 0) {
    # $Description.Text += "`r`nMeet all environment requirements or contact Technical Operators"
  }
}

<# CheckNpmVersion
Checks the current npm version, if npm isn't recognized by PowerShell print an error message
#>
function CheckNpmVersion {
  try {
    return npm --version
  }
  catch {
    $Description.AppendText("`r`nERROR!!! npm not installed!")
  }
}

<# CheckNpmLogin
Checks if the user has already logged in with npm
#>
function CheckNpmLogin {
  CreateLogfiles
  $CheckNpmLoginPath = "$($HOME)\check-npm-login.log"
  Start-Process npm -ArgumentList "view @ca/cli" -WindowStyle hidden -RedirectStandardOutput $OutLogfile -RedirectStandardError $ErrorLogfile -Wait
  Get-Content $OutLogfile, $ErrorLogfile | Set-Content $CheckNpmLoginPath
  Start-Process npm -ArgumentList "view @ca-codegen/core" -WindowStyle hidden -RedirectStandardOutput $OutLogfile -RedirectStandardError $ErrorLogfile -Wait
  Get-Content $OutLogfile, $ErrorLogfile | Add-Content $CheckNpmLoginPath
  $ErrorsNpm = Get-Content $CheckNpmLoginPath | Where-Object { $_ -like "*ERR!*" -or $_ -like "*error*" }
  Remove-Item $CheckNpmLoginPath
  return ($ErrorsNpm.Count -eq 0)
}

<# ReloadEnvPath
Reload the Env Variables Path, used after every complete installation
#>
function ReloadEnvPath {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
  $Description.Text += "`r`nEnv var Path reloaded correctly"
}

<# AcceptInstallRequirement
It needs as param a requirement.
It will be the one to be downloaded and installed on the machine, with the function DownloadAndInstallRequirement.
#>
function AcceptInstallRequirement($Requirement) {
  $Description.Text = "You have accepted.`r`nIt will start to download and install $($Requirement.Requirement) automatically"
  DownloadAndInstallRequirement $Requirement
}

<# DeclineInstallRequirement
It needs as param a requirement, which will be printed on the GUI.
At the and it will show the done button to close the installation. 
#>
function DeclineInstallRequirement($Requirement) {
  $Description.Text = "You have declined.`r`nDownload $($Requirement.Requirement) manually to proceed with the installation."
  ShowDoneButton
}

<# CreateRecommendationVS
Creates a string with all the recommendation for VS with the flag --add in front of them
#>
function CreateRecommendationsVS {
  foreach ($item in $RecommendationsVS) {
    $Result += "--add $item "
  }
  return $Result
}

<# Generate random code
Generate a random code to name the .exe and .msi
#>
function GenerateRandomCode {
  return -join (((48..57)+(65..90)+(97..122)) * 80 | Get-Random -Count 32 | ForEach-Object{ [char]$_ })
}

<# CreateLogfiles
Creates the logfiles used to save the output of some process
#>
function CreateLogfiles {
  if (-not(Test-Path $OutLogfile)) {
    New-Item -Path $OutLogfile -Force | Out-Null
  }
  if (-not(Test-Path $ErrorLogfile)) {
    New-Item -Path $ErrorLogfile -Force | Out-Null
  }
  if (-not(Test-Path $VSCodeExtentionsLogfile)) {
    New-Item -Path $VSCodeExtentionsLogfile -Force | Out-Null
  }
  if (-not(Test-Path $FullLogfile)) {
    New-Item -Path $FullLogfile -Force | Out-Null
  }
  if (-not(Test-Path $CaScarErrorLogfile)) {
    New-Item -Path $CaScarErrorLogfile -Force | Out-Null
  }
}

function RemoveInstallers {
  Get-ChildItem -Path "$HOME\Downloads" | ForEach-Object { if ($_.Name -like "*$RandomCode*") { Remove-Item "$HOME\Downloads\$_" } }
}

#---------------------------------------------------------[Variables]--------------------------------------------------------
# Variables for install ca-tools
$setupCaToolsMsi = "Setup_CaTools.msi"
$setupCaToolsMsiPath = Join-Path ${PWD} $setupCaToolsMsi
# Variables for install ca-platform
$setupPlatformExe = "setup-ca-platform.exe"
$CaToolsPath = "C:\Program Files\Ca-Tools"
$setupPlatformExePath = Join-Path $CaToolsPath $setupPlatformExe
# Variables for ca scar
$testScarPath = "C:\dev\scarface"
# Variables download requirements
$RandomCode = GenerateRandomCode
$VisualStudioExePath = "$HOME\Downloads\$RandomCode-VisualStudio-2022.exe"
$VisualStudioCodeExePath = "$HOME\Downloads\$RandomCode-VSCode-User-x64.exe"
$GitExePath = "$HOME\Downloads\$RandomCode-Git-x64.exe"
$NodejsMsiPath = "$HOME\Downloads\$RandomCode-Node-x64.msi"
$DotNetExePath = "$HOME\Downloads\$RandomCode-Dotnet-x64.exe"
$DockerExePath = "$HOME\Downloads\$RandomCode-Docker-x64.exe"
$VisualStudioDownloadLink = "https://aka.ms/vs/17/release/vs_community.exe"
$VisualStudioCodeDownloadLink = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
$GitDownloadLink = "https://github.com/git-for-windows/git/releases/download/v2.34.0.windows.1/Git-2.34.0-64-bit.exe"
$NodejsDownloadLink = "https://nodejs.org/dist/v16.13.0/node-v16.13.0-x64.msi"
$DotNetDownloadLink = "https://download.visualstudio.microsoft.com/download/pr/0f71eaf1-ce85-480b-8e11-c3e2725b763a/9044bfd1c453e2215b6f9a0c224d20fe/dotnet-sdk-6.0.100-win-x64.exe"
$DockerDownloadLink = "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe"
# Variables Save Log
$CurrentDate = (Get-Date -Format yyyyMMdd-hhmm).ToString()
$FullLogfile = "$($HOME)\.ca\install_ca_platform_$($CurrentDate).log"
$OutLogfile = "$($HOME)\.ca\install_ca_platform_$($CurrentDate).out"
$ErrorLogfile = "$($HOME)\.ca\install_ca_platform_$($CurrentDate).err"
$CaScarErrorLogfile = "$($HOME)\.ca\ca_scar_errors_$($CurrentDate).log"
$VSCodeExtentionsLogfile = "$($HOME)\vscode_extensions_$($CurrentDate).txt"
# Variables Login npm
$NpmRegistry = "https://devops.codearchitects.com:444/Code%20Architects/_packaging/ca-npm/npm/registry/"
$NpmScope = "@ca"
# Visual Studio and Visual Studio Code's recommendations that have to be installed
$RecommendationsVSCode = @(
  "Mikael.Angular-BeastCode",
  "steoates.autoimport",
  "HookyQR.beautify",
  "donjayamanne.githistory",
  "christian-kohler.path-intellisense",
  "vscode-icons-team.vscode-icons",
  "redhat.vscode-yaml",
  "ms-vscode.vscode-typescript-tslint-plugin",
  "msjsdiag.debugger-for-chrome",
  "spmeesseman.vscode-taskexplorer",
  "Gruntfuggly.triggertaskonsave",
  "angular.ng-template"
)
$RecommendationsVS = @(
  "Microsoft.VisualStudio.Workload.NetWeb",
  "Microsoft.VisualStudio.Workload.CoreEditor",
  "Microsoft.VisualStudio.Workload.ManagedDesktop",
  "Microsoft.VisualStudio.Workload.Universal",
  "Microsoft.NetCore.Component.Runtime.5.0",
  "Microsoft.NetCore.Component.Runtime.3.1"
)
# Stores the requirements that aren't met
$RequirementsNotMet = @()
$EnvironmentRequirementsNotMet = @()
# Store the current requirement not met that should be installed
$CurrentRequirement
# Increases every time a step is complete
$StatusInstallation = 0
# Increases every time a requirments is downloaded and installed correctly
$IndexRequirement = 0


#---------------------------------------------------------[Logic]--------------------------------------------------------
<# DownloadAndInstallRequirement
Download and install the requirement passed as param
#>
function DownloadAndInstallRequirement($Requirement) {
  switch ($Requirement.Requirement) {
    "Visual Studio" {
      $Description.AppendText("`r`nDownloading Visual Studio 2022 from https://visualstudio.microsoft.com/it/downloads/...")
      Invoke-RestMethod $VisualStudioDownloadLink -OutFile "$VisualStudioExePath"
      $Description.AppendText("`r`nDownload of Visual Studio 2022 complete.")
      $Description.AppendText("`r`nInstalling Visual Studio 2022...")
      $RecommendationsVSWithAdd = CreateRecommendationsVS
      Start-Process "$VisualStudioExePath" -ArgumentList "$RecommendationsVSWithAdd --passive --norestart" -Wait
      $Description.AppendText("`r`nInstall of Visual Studio 2022 complete.")
    }
    "Visual Studio Code" {
      $Description.AppendText("`r`nDownloading Visual Studio Code x64 from https://code.visualstudio.com/download...")
      Invoke-RestMethod $VisualStudioCodeDownloadLink -OutFile "$VisualStudioCodeExePath"
      $Description.AppendText("`r`nDownload of Visual Studio Code x64 complete.")
      $Description.AppendText("`r`nInstalling Visual Studio Code x64...")
      Start-Process "$VisualStudioCodeExePath" -ArgumentList "/VERYSILENT /NORESTART" -Wait
      $Description.AppendText("`r`nInstall of Visual Studio Code x64 complete.")
      InstallVSCodeExtensions
    }
    "Git" {
      $Description.AppendText("`r`nDownloading Git x64 from https://git-scm.com/download/win...")
      Invoke-RestMethod $GitDownloadLink -OutFile "$GitExePath"
      $Description.AppendText("`r`nDownload of Git x64 complete.")
      $Description.AppendText("`r`nInstalling Git x64...")
      Start-Process "$GitExePath" -ArgumentList "/VERYSILENT" -Wait
      $Description.AppendText("`r`nInstall of Git x64 complete.")
    }
    "Node.js" {
      $Description.AppendText("`r`nDownloading Node.js LTS from https://nodejs.org/en/download...")
      Invoke-RestMethod $NodejsDownloadLink -OutFile "$NodejsMsiPath"
      $Description.AppendText("`r`nDownload of Node.js LTS complete.")
      $Description.AppendText("`r`nInstalling Node.js LTS...")
      Start-Process msiexec.exe -Wait -ArgumentList "/I $NodejsMsiPath /quiet"
      $Description.AppendText("`r`nInstall of Node.js LTS complete.")
    }
    "DotNet Core" {
      $Description.AppendText("`r`nDownloading .NET 6.0 SDK from https://dotnet.microsoft.com/download/dotnet/thank-you/sdk-6.0.100-windows-x64-installer...")
      Invoke-RestMethod $DotNetDownloadLink -OutFile "$DotNetExePath"
      $Description.AppendText("`r`nDownload of .NET 6.0 SDK complete.")
      $Description.AppendText("`r`nInstalling .NET 6.0 SDK...")
      Start-Process "$DotNetExePath" -ArgumentList "/q /norestart" -Wait
      $Description.AppendText("`r`nInstall of .NET 6.0 SDK complete.")
    }
    "Windows Subsystem Linux" {
      $Description.AppendText("`r`nEnabling Windows Subsystem Linux...")
      & dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
      $Description.AppendText("`r`nWindows Subsystem Linux feature enabled")
    }
    "Virtual Machine Platform" {
      $Description.AppendText("`r`nEnabling Virtual Machine feature...")
      & dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
      $Description.AppendText("`r`nVirtual Machine feature enabled")
      $Description.AppendText("`r`nRestart the machine to complete enabling the features")
    }
    "Wsl Update" {
      $Description.AppendText("`r`nUpdating wsl 2...")
      wsl --update
      $Description.AppendText("`r`nUpdate of wsl 2 complete.")
      $Description.AppendText("`r`nSetting wsl 2 as your default version...")
      wsl --set-default-version 2
      $Description.AppendText("`r`nSet of wsl 2 as your default version complete.")
    }
    "Linux Distribution" {
      $Description.AppendText("`r`nInstalling Ubuntu 18.04 LTS...")
      wsl --install -d Ubuntu-18.04
      $Description.AppendText("`r`nInstall of Ubuntu 18.04 LTS complete.")
      $Description.AppendText("`r`nOpened Ubuntu 18.04 LTS. Create an account on Ubuntu")
    }
    "Docker" {
      $Description.AppendText("`r`nDownloading Docker Desktop from https://docs.docker.com/desktop/windows/install...")
      Invoke-RestMethod $DockerDownloadLink -OutFile "$DockerExePath"
      $Description.AppendText("`r`nDownload of Docker Desktop complete.")
      $Description.AppendText("`r`nInstalling Docker Desktop...")
      Start-Process "$DockerExePath" -ArgumentList "install --quiet" -Wait # Redirect Err and Out
      $Description.AppendText("`r`nInstall of Docker Desktop complete.")
      $Description.AppendText("`r`nLog out to complete the installation.")
    }
    "npm" {
      $NpmVersion = CheckNpmVersion
      if ($NpmVersion -lt 6.0.0 -or $NpmVersion -gt 7.0.0) {
        $Description.AppendText("`r`nCurrent version of npm is $NpmVersion.`r`nChanging the version of npm to 6.14.15...")
        npm i -g npm@6
        $NewNpmVersion = npm --version
        $Description.AppendText("`r`nVersion of npm updated to $NewNpmVersion")
      }
    }
    Default {
      $Description.AppendText("`r`nDefault")
    }
  }
  RemoveInstallers
  $script:IndexRequirement++
  if ($Requirement.Requirement -ne "Virtual Machine Platform") {
    ReloadEnvPath
    HideAcceptDeclineButton
  }
  else {
    ShowDoneButton
  }
}

<# InstallSetupCaTools
Check if there's already the setup-catools.msi, if there isn't then download it.
After the download it will start the install of setup-catools.msi, which can be silenced.
At the end it will reload the env path.
#>
function InstallSetupCaTools {
  $Title.Text = "Install Setup Ca-Tools"
  if(-not (Test-Path $setupCaToolsMsiPath)) {
    $Description.Text = "Download $setupCaToolsMsi"
    $latestRelease = Invoke-RestMethod https://api.github.com/repos/codearchitects/Ca-Tools/releases/latest
    $releaseDownloadUrl = $latestRelease.assets[0].browser_download_url
    Invoke-RestMethod $releaseDownloadUrl -OutFile $setupCaToolsMsiPath
  } else {
    $Description.Text = "$setupCaToolsMsi already exists"
  }
  $Description.Text += "`r`nInstalling Ca-Tools"
  if ($Silent.IsPresent) {
    $Description.AppendText("`r`nSilent install")
    Start-Process msiexec.exe -Wait -ArgumentList "/I $setupCaToolsMsiPath /quiet"
  } else {
    Start-Process -Wait -FilePath $setupCaToolsMsiPath
  }
  
  $Description.Text += "`r`nCa-Tools Installed"
  ReloadEnvPath
  $script:StatusInstallation++
}

<# ShowLoginNpm
Shows the login to npm screen to the userm
if the CheckNpmLogin is successful then select the user credential and ask to login or change the credantials
#>
function ShowLoginNpm {
  if (CheckNpmLogin) {
    $Title.Text = "Login npm"
    $Description.Text = "I have found an Azure DevOps account, do you want to login with it?"
    $TokenPath = "~/.token.json"
    $TokenParsed = Get-Content  $TokenPath | ConvertFrom-Json
    $Index = $TokenParsed.Count - 1
    $UsernameTextBox.Text = $TokenParsed[$Index].user
    $TokenTextBox.Text = $TokenParsed[$Index].token
  } else {
    $Description.Text = "We have not found any Azure DevOps account.`r`nPlease enter the Azure DevOps Username and the Token"
  }
  $Description.Height = 50
  $UsernameLabel.Visible = $true
  $UsernameTextBox.Visible = $true
  $TokenLabel.Visible = $true
  $TokenTextBox.Visible = $true
  $LoginButton.Visible = $true
  $NextButton.Visible = $false
}

<# LoginNpm
Login to npm with the value inside the $UsernameTextBox and $TokenTextBox
#>
function LoginNpm {
  $Description.Text = ""
  $Description.Height = 150
  $UsernameLabel.Visible = $false
  $UsernameTextBox.Visible = $false
  $TokenLabel.Visible = $false
  $TokenTextBox.Visible = $false
  #TODO cambiare & con Start-Process
  & npm-login.ps1 -user $UsernameTextBox.Text -token $TokenTextBox.Text -registry $NpmRegistry -scope $NpmScope *> $HOME\NpmLoginMessage.txt
  $NpmLoginMessage = Get-Content $HOME\NpmLoginMessage.txt
  Remove-Item $HOME\NpmLoginMessage.txt
  $Description.Lines = $NpmLoginMessage
  npm config set @ca-codegen:registry $NpmRegistry
  $LoginButton.Visible = $false
  $NextButton.Visible = $true
  $script:StatusInstallation++
}

<# InstallCaPlatform
Installs the ca-platform, it will print errors if they are found
#>
function InstallCaPlatform {
  $Title.Text = "Install Ca-Platform"
  $Description.Text = "Installing Ca-Platform... (It will take a few minutes)"
  CreateLogfiles
  Start-Process $setupPlatformExePath -ArgumentList "-s" -WindowStyle hidden -RedirectStandardOutput $OutLogfile -RedirectStandardError $ErrorLogfile -Wait
  Get-Content $OutLogfile, $ErrorLogfile | Set-Content $FullLogfile

  $ArrayErrors = Get-Content $FullLogfile | Where-Object { $_ -like "*Error*" -or $_ -like "*ERR!*" }
  if ($ArrayErrors.Count -ne 0) {
    $Description.Text += "`r`nERRORS FOUND:"
    $ArrayErrors | ForEach-Object {  $Description.Text += "`r`n$_" }
    $Description.Text += "`r`nCheck the full logfile in the path $FullLogfile"
    ShowDoneButton
  } else {
    $Description.Text +="`r`n$setupPlatformExe executed correctly"
    ReloadEnvPath
  }
  $script:StatusInstallation++
}

<# InstallVSCodeExtensions
Install the recommendated extensions for Visual Studio Code automatically
#>
function InstallVSCodeExtensions {
  $Description.AppendText("`r`nInstalling VSCode extensions`r`n")
  CreateLogfiles
  foreach ($item in $RecommendationsVSCode) {
    Start-Process code -ArgumentList "--install-extension $item --force" -WindowStyle hidden -RedirectStandardOutput $OutLogfile -RedirectStandardError $ErrorLogfile -Wait
    Get-Content $OutLogfile, $ErrorLogfile | Add-Content $VSCodeExtentionsLogfile
    $Description.Lines += Get-Content $OutLogfile, $ErrorLogfile
    $Description.Text += "`r`n"
    $Description.SelectionStart = $Description.TextLength;
	  $Description.ScrollToCaret()
  }
  $Description.AppendText("`r`nInstallation of VSCode extensions completed`r`n")
}

<# ExecuteCaScar
Run the command ca scar to create a project of test
#>
function ExecuteCaScar {
  $Title.Text = "Execute ca scar"
  $Description.Text = "Executing ca scar... (it will take a few minutes)"
  if (-not (Test-Path $testScarPath)) {
    New-Item -ItemType Directory -Path $testScarPath -Force
  }

  if ($ScarVersion -ne "") {
    npm i -g "@ca/generator-scarface@$ScarVersion"
  }
  
  Set-Location $testScarPath
  CreateLogfiles
  Start-Process $HOME\AppData\Roaming\npm\ca.cmd -ArgumentList "scar" #-WindowStyle hidden -RedirectStandardOutput $OutLogfile -RedirectStandardError $ErrorLogfile -Wait
  $script:StatusInstallation++
  # New-Item $CaScarErrorLogfile
  # Get-Content $OutLogfile, $ErrorLogfile | Set-Content $CaScarErrorLogfile
  # $ArrayErrors = Get-Content $CaScarErrorLogfile | Where-Object { $_ -like "*Error*" -or $_ -like "*ERR!*" }
  # if ($ArrayErrors.Count -ne 0) {
  #   $Description.Text += "`r`nERRORS FOUND:"
  #   $ArrayErrors | ForEach-Object {  $Description.Text += "`r`n$_" }
  #   $Description.Text += "`r`nCheck the full logfile in the path $CaScarErrorLogfile"
  #   ShowDoneButton
  # } else {
  #   $Description.Text +="`r`nca scar executed correctly"
  #   $script:StatusInstallation++
  # }
}

<# NextScreen
Function used to go to the next step of the installation
#>
function NextScreen {
  switch ($StatusInstallation) {
    0 {
      if ($IndexRequirement -lt $RequirementsNotMet.Count) {
        ShowDownloadAndInstallRequirementScreen
      }
      else {
        ShowMainScreen
      }
    }
    1 {
      InstallSetupCaTools
      # $Description.Text = "InstallSetupCaTools"
      # $script:StatusInstallation++
    }
    2 {
      ShowLoginNpm
      # $Description.Text = "ShowLoginNpm"
      # $script:StatusInstallation++
    }
    3 {
      InstallCaPlatform
      # $Description.Text = "InstallCaPlatform"
      # $script:StatusInstallation++
    }
    4 {
      # ExecuteCaScar
      $Description.Text = "ExecuteCaScar"
      $script:StatusInstallation++
    }
    5 {
      $Title.Text = "End"
      $Description.Text = "Installation complete"
      ShowDoneButton
    }
  }
}

# Adds a function to the button
$NextButton.Add_Click({ NextScreen })
$LoginButton.Add_Click({ LoginNpm })
$DoneButton.Add_Click({ $InstallForm.Close() })
$AcceptButton.Add_Click({ AcceptInstallRequirement $CurrentRequirement })
$DeclineButton.Add_Click({ DeclineInstallRequirement $CurrentRequirement })

Get-NetAdapter | ForEach-Object { if (($_.Name -eq "Ethernet" -or $_.Name -eq "Wi-Fi") -and $_.Status -eq "Up") { $InternetStatus = $true } }
if (-not $InternetStatus) {
  $Description.Text = "PLEASE CONNECT TO INTERNET!!!"
  ShowDoneButton
}
# Check if the user opened PowerShell as Admin, if not then stop the installation, otherwise check the requirements
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  $Description.Text = "PLEASE OPEN POWERSHELL AS ADMINISTRATOR!!!"
  ShowDoneButton
}
else {
  CheckRequirements
}

# Shows the GUI
[void]$InstallForm.ShowDialog()
