param(
  [string]$ScarVersion = "0.0.0-beta.63"
)

#---------------------------------------------------------[Initialisations]--------------------------------------------------------
# Init PowerShell Gui
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
. .\generate-scar-config.ps1

#---------------------------------------------------------[Form]--------------------------------------------------------

[System.Windows.Forms.Application]::EnableVisualStyles()

$InstallForm                    = New-Object System.Windows.Forms.Form
$InstallForm.ClientSize         = '800,500'
$InstallForm.Text               = "Install CAEP"
$InstallForm.BackColor          = "#ffffff"
$InstallForm.TopMost            = $false

$Title                          = New-Object System.Windows.Forms.Label
$Title.Text                     = "Install Code Architects Enterprise Platform"
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
$Description.Width              = 700
$Description.Height             = 300
$Description.Location           = New-Object System.Drawing.Point(20,50)
$Description.Font               = 'Consolas,10'

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
$NextButton.Location            = New-Object System.Drawing.Point(550,400)
$NextButton.Font                = 'Microsoft Sans Serif,10'
$NextButton.ForeColor           = "#ffffff"

$LoginButton                     = New-Object System.Windows.Forms.Button
$LoginButton.BackColor           = "#ff7b00"
$LoginButton.Text                = "Login"
$LoginButton.Width               = 90
$LoginButton.Height              = 30
$LoginButton.Location            = New-Object System.Drawing.Point(550,400)
$LoginButton.Font                = 'Microsoft Sans Serif,10'
$LoginButton.ForeColor           = "#ffffff"
$LoginButton.Visible             = $false

$DoneButton                     = New-Object System.Windows.Forms.Button
$DoneButton.BackColor           = "#ff7b00"
$DoneButton.Text                = "Done"
$DoneButton.Width               = 90
$DoneButton.Height              = 30
$DoneButton.Location            = New-Object System.Drawing.Point(550,400)
$DoneButton.Font                = 'Microsoft Sans Serif,10'
$DoneButton.ForeColor           = "#ffffff"
$DoneButton.Visible             = $false

$AcceptButton                     = New-Object System.Windows.Forms.Button
$AcceptButton.BackColor           = "#ff7b00"
$AcceptButton.Text                = "Accept"
$AcceptButton.Width               = 90
$AcceptButton.Height              = 30
$AcceptButton.Location            = New-Object System.Drawing.Point(550,400)
$AcceptButton.Font                = 'Microsoft Sans Serif,10'
$AcceptButton.ForeColor           = "#ffffff"
$AcceptButton.Visible             = $false

$RestartButton                     = New-Object System.Windows.Forms.Button
$RestartButton.BackColor           = "#ff7b00"
$RestartButton.Text                = "Restart"
$RestartButton.Width               = 90
$RestartButton.Height              = 30
$RestartButton.Location            = New-Object System.Drawing.Point(550,400)
$RestartButton.Font                = 'Microsoft Sans Serif,10'
$RestartButton.ForeColor           = "#ffffff"
$RestartButton.Visible             = $false

$LogoutButton                     = New-Object System.Windows.Forms.Button
$LogoutButton.BackColor           = "#ff7b00"
$LogoutButton.Text                = "Logout"
$LogoutButton.Width               = 90
$LogoutButton.Height              = 30
$LogoutButton.Location            = New-Object System.Drawing.Point(550,400)
$LogoutButton.Font                = 'Microsoft Sans Serif,10'
$LogoutButton.ForeColor           = "#ffffff"
$LogoutButton.Visible             = $false

$DeclineButton                   = New-Object System.Windows.Forms.Button
$DeclineButton.BackColor         = "#ffffff"
$DeclineButton.Text              = "Decline"
$DeclineButton.Width             = 90
$DeclineButton.Height            = 30
$DeclineButton.Location          = New-Object System.Drawing.Point(450,400)
$DeclineButton.Font              = 'Microsoft Sans Serif,10'
$DeclineButton.ForeColor         = "#000"
$DeclineButton.Visible           = $false

$YesButton                     = New-Object System.Windows.Forms.Button
$YesButton.BackColor           = "#ff7b00"
$YesButton.Text                = "Yes"
$YesButton.Width               = 90
$YesButton.Height              = 30
$YesButton.Location            = New-Object System.Drawing.Point(550,400)
$YesButton.Font                = 'Microsoft Sans Serif,10'
$YesButton.ForeColor           = "#ffffff"
$YesButton.Visible             = $false

$NoButton                   = New-Object System.Windows.Forms.Button
$NoButton.BackColor         = "#ffffff"
$NoButton.Text              = "No"
$NoButton.Width             = 90
$NoButton.Height            = 30
$NoButton.Location          = New-Object System.Drawing.Point(450,400)
$NoButton.Font              = 'Microsoft Sans Serif,10'
$NoButton.ForeColor         = "#000"
$NoButton.Visible           = $false

$CancelButton                   = New-Object System.Windows.Forms.Button
$CancelButton.BackColor         = "#ffffff"
$CancelButton.Text              = "Cancel"
$CancelButton.Width             = 90
$CancelButton.Height            = 30
$CancelButton.Location          = New-Object System.Drawing.Point(450,400)
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
$DeclineButton,
$RestartButton,
$LogoutButton,
$YesButton,
$NoButton))

#---------------------------------------------------------[Functions]--------------------------------------------------------

function ShowNextButton {
  $CancelButton.Visible = $true
  $NextButton.Visible = $true
  $DeclineButton.Visible = $false
  $AcceptButton.Visible = $false
  $DoneButton.Visible = $false
  $LoginButton.Visible = $false
  $LogoutButton.Visible = $false
  $RestartButton.Visible = $false
  $YesButton.Visible = $false
  $NoButton.Visible = $false
}

<# ShowDoneButton
Hide all the buttons and shows the Done button
#>
function ShowDoneButton {
  $CancelButton.Visible = $false
  $NextButton.Visible = $false
  $DeclineButton.Visible = $false
  $AcceptButton.Visible = $false
  $LogoutButton.Visible = $false
  $RestartButton.Visible = $false
  $YesButton.Visible = $false
  $NoButton.Visible = $false
  $DoneButton.Visible = $true
}

<# ShowRestartButton
Hide all the buttons and shows the Restart button
#>
function ShowRestartButton {
  $CancelButton.Visible = $false
  $NextButton.Visible = $false
  $DeclineButton.Visible = $false
  $AcceptButton.Visible = $false
  $LogoutButton.Visible = $false
  $RestartButton.Visible = $true
  $YesButton.Visible = $false
  $NoButton.Visible = $false
  $DoneButton.Visible = $false
}

<# ShowLogoutButton
Hide all the buttons and shows the Logout button
#>
function ShowLogoutButton {
  $CancelButton.Visible = $false
  $NextButton.Visible = $false
  $DeclineButton.Visible = $false
  $AcceptButton.Visible = $false
  $LogoutButton.Visible = $true
  $RestartButton.Visible = $false
  $YesButton.Visible = $false
  $NoButton.Visible = $false
  $DoneButton.Visible = $false
}

<# ShowAcceptDeclineButton
Shows the Accept and Decline buttons,
to let the user choice if he wants the script to download and install the requirement automatically
#>
function ShowAcceptDeclineButton {
  $CancelButton.Visible = $false
  $NextButton.Visible = $false
  $DeclineButton.Visible = $true
  $AcceptButton.Visible = $true
  $LogoutButton.Visible = $false
  $RestartButton.Visible = $false
  $YesButton.Visible = $false
  $NoButton.Visible = $false
  $DoneButton.Visible = $false
}

function ShowYesNoButtons {
  $CancelButton.Visible = $false
  $NextButton.Visible = $false
  $DeclineButton.Visible = $false
  $AcceptButton.Visible = $false
  $DoneButton.Visible = $false
  $LogoutButton.Visible = $false
  $RestartButton.Visible = $false
  $YesButton.Visible = $true
  $NoButton.Visible = $true
}

<# ShowMainScreen
Shows the Intro screen, after all requirements are met
#>
function ShowMainScreen {
  $Title.Text = "Intro"
  $Description.Text = "With the gui-install-platform.ps1, we are going to:`r`n 1) Install Ca-Tools`r`n 2) Login to npm`r`n 3) Intall CA Enterprise Platform`r`n 4) Execute CA Scarface`r`n`r`nCheck the Documentation for more information."
  $script:StatusInstallation++
}

<# ShowDownloadAndInstallRequirementScreen
Shows the screen asking for the permission to download and install the $CurrentRequirement
#>
function ShowDownloadAndInstallRequirementScreen {
  $Title.Text = "Download Requirements"
  $script:CurrentRequirement = $RequirementsNotMet[$IndexRequirement]

  if ($CurrentRequirement.Status -like "*WARNING*") {
    AcceptInstallRequirement $CurrentRequirement
  } else {
    ShowAcceptDeclineButton
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
}

<# CheckRequirments
Checks if the requirements are met or not.
Shows the result of the check.
If a requirement isn't met than store it inside the variable $RequirementsNotMet or $EnvironmentRequirementsNotMet
#>
function CheckRequirements {
  . ./check-requirements.ps1

  $script:ProxyData = $ProxyData
  $Title.Text = "Check Requirements"
  $MaxSpacesStatus = 39
  $MaxSpacesRequirement = 38
  $Space = " "
  $Dash = "-"
  $Description.AppendText("SOFTWARE REQUIREMENTS`r`n$($Dash * 75)`r`n")
  $Description.AppendText("Requirements$($Space * 26)Status$($Space * 33)Version`r`n")
  foreach ($item in $requirements) {
    $CountCharStatus = ($item.Status | Measure-Object -Character).Characters
    $CountCharRequirement = ($item.Requirement | Measure-Object -Character).Characters
    $NumberSpacesStatus = $MaxSpacesStatus - $CountCharStatus
    $NumberSpacesRequirement = $MaxSpacesRequirement - $CountCharRequirement
    $Description.AppendText("$($item.Requirement)$($Space * $NumberSpacesRequirement)$($item.Status)$($Space * $NumberSpacesStatus)$($item.Version)`r`n")
    if (-not ($item.Status -like "*OK*") -and ($item.Requirement -ne "Proxy")) {
      $script:RequirementsNotMet += $item
      if ($item.Requirement -eq "Visual Studio Code") {
        $script:VisualStudioCodeAutoExtension = $true
      }
    }
  }

  $MaxSpacesEnvRequirement = 55

  $Description.AppendText("`r`nENVIRONMENT VARIABLES REQUIREMENTS`r`n$($Dash * 75)`r`n")
  $Description.AppendText("Environment Requirements$($Space * 31)Status`r`n")
  foreach ($item in $envRequirements) {
    $CountCharEnvRequirement = ($item.EnvironmentVariable | Measure-Object -Character).Characters
    $NumberSpacesEnvRequirement = $MaxSpacesEnvRequirement - $CountCharEnvRequirement
    $Description.AppendText("$($item.EnvironmentVariable)$($Space * $NumberSpacesEnvRequirement)$($item.Status)`r`n")
    if ($item.Status -like "*KO*") {
      $script:EnvironmentRequirementsNotMet += $item
    }
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
  Start-Process npm -ArgumentList "view @ca/cli" -WindowStyle hidden -RedirectStandardOutput $OutLogfile -RedirectStandardError $ErrorLogfile -Wait
  Get-Content $OutLogfile, $ErrorLogfile | Set-Content $CheckNpmLoginLogfile
  Start-Process npm -ArgumentList "view @ca-codegen/core" -WindowStyle hidden -RedirectStandardOutput $OutLogfile -RedirectStandardError $ErrorLogfile -Wait
  Get-Content $OutLogfile, $ErrorLogfile | Add-Content $CheckNpmLoginLogfile
  $ErrorsNpm = Get-Content $CheckNpmLoginLogfile | Where-Object { $_ -like "*ERR!*" -or $_ -like "*error*" }
  return ($ErrorsNpm.Count -eq 0)
}

function CheckProxy {
  if ($ProxyData.ProxyEnable -eq 1) {
    $ProxyDataSplit = $ProxyData.ProxyServer -split ":"
    if ($ProxyDataSplit.Count -eq 2) {
      $ProxyAddress = $ProxyDataSplit[0]
      $ProxyPort = $ProxyDataSplit[1]
    } else {
      $ProxyAddress = $ProxyDataSplit[1].replace("/","")
      $ProxyPort = $ProxyDataSplit[2]
    }
    if ((Test-NetConnection -ComputerName $ProxyAddress -Port $ProxyPort).TcpTestSucceeded) {
      # Copia docker config.json
      if (Test-Path $DockerConfigPath) {
        $DockerConfigJson = Get-Content $DockerConfigPath
        if (-not [String]::IsNullOrWhiteSpace($DockerConfigJson)) {
          $DockerConfigJson | Out-File "$DockerConfigPath.old.$CurrentDate"
        }
        else {
          New-Item -Path "$DockerConfigPath.old.$CurrentDate"
        }
        $DockerConfigObj = $DockerConfigJson | ConvertFrom-Json
        $DockerConfigObj.PSObject.Properties.Remove('proxies')
        $Proxies = @{
          'defalut' = @{
            'httpProxy'  = $ProxyData.ProxyServer
            'httpsProxy' = $ProxyData.ProxyServer
          }
        }
        $DockerConfigObj | Add-Member -NotePropertyName proxies -NotePropertyValue $Proxies
        # Sostituisci proxy docker config.json
        Set-Content -Path $DockerConfigPath -Value ($DockerConfigObj | ConvertTo-Json -Depth 5)
      }

      # Copia .npmrc
      if (Test-Path $NpmrcFilePath) {
        Get-Content $NpmrcFilePath | Out-File "$NpmrcFilePath.old.$CurrentDate"
      }
      $ProxyServer = $ProxyData.ProxyServer
      # Sostituisci proxy .npmrc
      Start-Process npm -ArgumentList "config set proxy $ProxyServer" -WindowStyle hidden -Wait
      Start-Process npm -ArgumentList "config set https-proxy $ProxyServer" -WindowStyle hidden -Wait
      
      if (Test-Path "C:\cacert") {
        $Result = Get-ChildItem -Path C:\cacert -Name -Include *.pem
        if ($Result.Count -eq 1) {
          $cacertPemPath = "C:\cacert\$Result"
          Start-Process npm -ArgumentList "config set cafile $cacertPemPath" -WindowStyle hidden -Wait
        }
        else {
          $Description.Text = "`r`nThere must be 1 file .pem!!!"
          ShowDoneButton
        }
      }
    } else {
      $Description.Text = "Connection Error to $($ProxyData.ProxyServer)!"
    }
  }
  elseif (Test-Path $NpmrcFilePath) {
    # In case the Proxy isn't activem but there's a proxy setted to the config of npm or docker, remove it.
    if (Test-Path $NpmrcFilePath) {
      Get-Content $NpmrcFilePath | Out-File "$NpmrcFilePath.old.$CurrentDate"
      Start-Process npm -ArgumentList "config delete proxy" -WindowStyle hidden -Wait
      Start-Process npm -ArgumentList "config delete https-proxy" -WindowStyle hidden -Wait
      Start-Process npm -ArgumentList "config delete cafile" -WindowStyle hidden -Wait
    }
    if (Test-Path $DockerConfigPath) {
      $DockerConfigJson = Get-Content $DockerConfigPath
      $DockerConfigJson | Out-File "$DockerConfigPath.old.$CurrentDate"
      $DockerConfigObj = $DockerConfigJson | ConvertFrom-Json
      $DockerConfigObj.PSObject.Properties.Remove('proxies')
      Set-Content -Path $DockerConfigPath -Value ($DockerConfigObj | ConvertTo-Json -Depth 5)
    }
  }  
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
  switch ($Requirement.Status) {
    "KO (Not Found)" {
      $Description.Text = "You have accepted.`r`nIt will start to download and install $($Requirement.Requirement) automatically"
    }
    "KO (Not enabled)" {
      $Description.Text = "You have accepted.`r`nIt will start to enable $($Requirement.Requirement) automatically"
    }
  }
  DownloadAndInstallRequirement $Requirement
}

<# DeclineInstallRequirement
It needs as param a requirement, which will be printed on the GUI.
At the and it will show the done button to close the installation. 
#>
function DeclineInstallRequirement($Requirement) {
  $DownloadLinkMessage = GetDownloadLink $Requirement.Requirement
  switch ($Requirement.Status) {
    "KO (Not Found)" {
      $Description.Text = "You have declined.`r`n$DownloadLinkMessage"
    }
    "KO (Not enabled)" {
      $Description.Text = "You have declined.`r`nEnable $($Requirement.Requirement) manually to proceed with the installation."
    }
  }
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

<# GenerateRandomCode
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
  if (-not(Test-Path $NpmLoginResultLogfile)) {
    New-Item -Path $NpmLoginResultLogfile -Force | Out-Null
  }
  if (-not(Test-Path $NpmUpdateVersionLogfile)) {
    New-Item -Path $NpmUpdateVersionLogfile -Force | Out-Null
  }
  if (-not(Test-Path $DockerInstallLogfile)) {
    New-Item -Path $DockerInstallLogfile -Force | Out-Null
  }
  if (-not(Test-Path $CheckNpmLoginLogfile)) {
    New-Item -Path $CheckNpmLoginLogfile -Force | Out-Null
  }
}

function RemoveInstallers {
  if ($PSVersionTable.PSVersion.Major -eq 5) {
    Get-ChildItem -Path "$HOME\Downloads" | ForEach-Object { if ($_.Name -like "*$RandomCode*") { Remove-Item "$HOME\Downloads\$_" } }
  } else {
    Get-ChildItem -Path "$HOME\Downloads" | ForEach-Object { if ($_.Name -like "*$RandomCode*") { Remove-Item "$_" } }
  }
}

function GetDownloadLink($RequirementName) {
  switch ($RequirementName) {
    "Visual Studio" {
      return "Download $Requirementname manually to proceed with the installation from the following link $VisualStudioAppLink."
    }
    "Visual Studio Code" {
      return "Download $Requirementname manually to proceed with the installation from the following link $VisualStudioCodeAppLink."
    }
    "Git" {
      return "Download $Requirementname manually to proceed with the installation from the following link $GitAppLink."
    }
    "Node.js" {
      return "Download $Requirementname manually to proceed with the installation from the following link $NodejsAppLink."
    }
    "DotNet Core" {
      return "Download $Requirementname manually to proceed with the installation from the following link $DotNetAppLink."
    }
    "Windows Subsystem Linux" {
      return "Run the command & dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart, to enable WSL."
    }
    "Virtual Machine Platform" {
      return "Run the command & dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart, to enable VMP.`r`nThen restart the machine."
    }
    "Wsl Update" {
      return "Run the commands: wsl --update and wsl --set-default-version 2, to update to WSL 2."
    }
    "Linux Distribution" {
      return "Run the command wsl --install -d Ubuntu-20.04, to download the Linux Distribution."
    }
    "Docker" {
      return "Download $Requirementname manually to proceed with the installation from the following link $VisualStudioAppLink.`r`nAfter the install run the command wsl --set-default Ubuntu-20.04, at the end logout from the machine."
    }
    "npm" {
      return "Run the command npm i -g npm@6, to downgrade npm"
    }
  }
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
$ScarfaceConfigPath = "C:\dev\scarface\scarface.config.json"
# Variables download requirements
$RandomCode = GenerateRandomCode

$VisualStudioExePath = "$HOME\Downloads\$RandomCode-VisualStudio-2022.exe"
$VisualStudioCodeExePath = "$HOME\Downloads\$RandomCode-VSCode-User-x64.exe"
$GitExePath = "$HOME\Downloads\$RandomCode-Git-x64.exe"
$NodejsMsiPath = "$HOME\Downloads\$RandomCode-Node-x64.msi"
$DotNetExePath = "$HOME\Downloads\$RandomCode-Dotnet-x64.exe"
$DockerExePath = "$HOME\Downloads\$RandomCode-Docker-x64.exe"

$VisualStudioDownloadLink = "https://visualstudio.microsoft.com/it/downloads/"
$VisualStudioCodeDownloadLink = "https://code.visualstudio.com/download"
$GitDownloadLink = "https://git-scm.com/download/win"
$NodejsDownloadLink = "https://nodejs.org/en/download"
$DotNetDownloadLink = "https://dotnet.microsoft.com/download/dotnet/thank-you/sdk-6.0.100-windows-x64-installer"
$DockerDownloadLink = "https://docs.docker.com/desktop/windows/install"

$VisualStudioAppLink = "https://aka.ms/vs/17/release/vs_community.exe"
$VisualStudioCodeAppLink = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
$GitAppLink = "https://github.com/git-for-windows/git/releases/download/v2.34.0.windows.1/Git-2.34.0-64-bit.exe"
$NodejsAppLink = "https://nodejs.org/dist/v16.13.0/node-v16.13.0-x64.msi"
$DotNetAppLink = "https://download.visualstudio.microsoft.com/download/pr/0f71eaf1-ce85-480b-8e11-c3e2725b763a/9044bfd1c453e2215b6f9a0c224d20fe/dotnet-sdk-6.0.100-win-x64.exe"
$DockerAppLink = "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe"
# Variables Save Log
$CurrentDate = (Get-Date -Format yyyyMMdd-hhmm).ToString()
$OutLogfile = "$($HOME)\.ca\install_ca_platform_$($CurrentDate).out"
$ErrorLogfile = "$($HOME)\.ca\install_ca_platform_$($CurrentDate).err"
$FullLogfile = "$($HOME)\.ca\install_ca_platform_$($CurrentDate).log"
$CaScarErrorLogfile = "$($HOME)\.ca\ca_scar_errors_$($CurrentDate).log"
$VSCodeExtentionsLogfile = "$($HOME)\.ca\vscode_extensions_$($CurrentDate).log"
$NpmLoginResultLogfile = "$($HOME)\.ca\npm_login_result_$($CurrentDate).log"
$NpmUpdateVersionLogfile = "$($HOME)\.ca\npm_update_version_$($CurrentDate).log"
$DockerInstallLogfile = "$($HOME)\.ca\docker_install_$($CurrentDate).log"
$CheckNpmLoginLogfile = "$($HOME)\.ca\check_npm_login_$($CurrentDate).log"
$AnswerNestedVirtualizationPath = "$($HOME)\.ca\answer_nested_virtualization_$($CurrentDate).log"
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
# Check if Visual Studio Code is already installed
$VisualStudioCodeAutoExtension = $false
# Proxy variables
$ProxyData
$DockerConfigPath = "$HOME\.docker\config.json"
$NpmrcFilePath = "$HOME\.npmrc"

#---------------------------------------------------------[Logic]--------------------------------------------------------

<# DownloadAndInstallRequirement
Download and install the requirement passed as param
#>
function DownloadAndInstallRequirement($Requirement) {
  $NextButton.Visible = $false
  $AcceptButton.Visible = $false
  $NextButton.Enabled = $false
  $AcceptButton.Enabled = $false
  switch ($Requirement.Requirement) {
    "Visual Studio" {
      $Description.AppendText("`r`nDownloading Visual Studio 2022 from $VisualStudioDownloadLink...")
      Invoke-RestMethod $VisualStudioAppLink -OutFile "$VisualStudioExePath"
      $Description.AppendText("`r`nDownload of Visual Studio 2022 complete.")
      $Description.AppendText("`r`nInstalling Visual Studio 2022...")
      $RecommendationsVSWithAdd = CreateRecommendationsVS
      Start-Process "$VisualStudioExePath" -ArgumentList "$RecommendationsVSWithAdd --passive --norestart" -Wait
      $Description.AppendText("`r`nInstall of Visual Studio 2022 complete.")
    }
    "Visual Studio Code" {
      $Description.AppendText("`r`nDownloading Visual Studio Code x64 from $VisualStudioCodeDownloadLink...")
      Invoke-RestMethod $VisualStudioCodeAppLink -OutFile "$VisualStudioCodeExePath"
      $Description.AppendText("`r`nDownload of Visual Studio Code x64 complete.")
      $Description.AppendText("`r`nInstalling Visual Studio Code x64...")
      Start-Process "$VisualStudioCodeExePath" -ArgumentList "/VERYSILENT /NORESTART /mergetasks=!runcode" -Wait
      $Description.AppendText("`r`nInstall of Visual Studio Code x64 complete.")
      $script:VisualStudioCodeAutoExtension = $false
    }
    "Git" {
      $Description.AppendText("`r`nDownloading Git x64 from $GitDownloadLink...")
      Invoke-RestMethod $GitAppLink -OutFile "$GitExePath"
      $Description.AppendText("`r`nDownload of Git x64 complete.")
      $Description.AppendText("`r`nInstalling Git x64...")
      Start-Process "$GitExePath" -ArgumentList "/VERYSILENT" -Wait
      $Description.AppendText("`r`nInstall of Git x64 complete.")
    }
    "Node.js" {
      $Description.AppendText("`r`nDownloading Node.js LTS from $NodejsDownloadLink...")
      Invoke-RestMethod $NodejsAppLink -OutFile "$NodejsMsiPath"
      $Description.AppendText("`r`nDownload of Node.js LTS complete.")
      $Description.AppendText("`r`nInstalling Node.js LTS...")
      Start-Process msiexec.exe -Wait -ArgumentList "/I $NodejsMsiPath /quiet"
      $Description.AppendText("`r`nInstall of Node.js LTS complete.")
    }
    "DotNet Core" {
      $Description.AppendText("`r`nDownloading .NET 6.0 SDK from $DotNetDownloadLink...")
      Invoke-RestMethod $DotNetAppLink -OutFile "$DotNetExePath"
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
      $Description.AppendText("`r`nInstalling Ubuntu 20.04 LTS...")
      wsl --install -d Ubuntu-20.04
      $Description.AppendText("`r`nInstall of Ubuntu 20.04 LTS complete.")
      $Description.AppendText("`r`nOpened Ubuntu 20.04 LTS. Create an account on Ubuntu")
    }
    "Docker" {
      $Description.AppendText("`r`nDownloading Docker Desktop from $DockerDownloadLink...")
      Invoke-RestMethod $DockerAppLink -OutFile "$DockerExePath"
      $Description.AppendText("`r`nDownload of Docker Desktop complete.")
      $Description.AppendText("`r`nInstalling Docker Desktop...")
      Start-Process "$DockerExePath" -ArgumentList "install --quiet" -WindowStyle hidden -RedirectStandardOutput $OutLogfile -RedirectStandardError $ErrorLogfile -Wait
      Get-Content $ErrorLogfile, $OutLogfile | Set-Content $DockerInstallLogfile
      $Description.AppendText("`r`nInstall of Docker Desktop complete.")
      $Description.AppendText("`r`nSetting default Linux Distribution to Ubuntu 20.04 LTS.")
      wsl --set-default Ubuntu-20.04
      $Description.AppendText("`r`nSet of default Linux Distribution to Ubuntu 20.04 LTS complete.")
      $Description.AppendText("`r`nLog out to complete the installation of Docker.")
    }
    "npm" {
      $NpmVersion = CheckNpmVersion
      if ($NpmVersion -lt 6.0.0 -or $NpmVersion -gt 7.0.0) {
        $Description.AppendText("`r`nCurrent version of npm is $NpmVersion.`r`nChanging the version of npm to 6.14.15...")
        Start-Process npm -ArgumentList "i -g npm@6" -WindowStyle hidden -RedirectStandardOutput $OutLogfile -RedirectStandardError $ErrorLogfile -Wait
        Get-Content $ErrorLogfile, $OutLogfile | Set-Content $NpmUpdateVersionLogfile
        $NewNpmVersion = npm --version
        $Description.AppendText("`r`nVersion of npm updated to $NewNpmVersion")
      }
    }
    "Machine" {
      $Description.Text = "You are installing the CAEP on a Virtual Machine.`r`nDid you enable the Nested Virtualization with the following command?`r`n"
      $Description.AppendText('Set-VMProcessor -VMName <VMName> -ExposeVirtualizationExtensions $true')
    }
    Default {
      $Description.AppendText("`r`nDefault")
    }
  }
  RemoveInstallers
  $script:IndexRequirement++
  $NextButton.Visible = $true
  $AcceptButton.Visible = $true
  $NextButton.Enabled = $true
  $AcceptButton.Enabled = $true
  if ($Requirement.Requirement -eq "Virtual Machine Platform") {
    ShowRestartButton
  } elseif ($Requirement.Requirement -eq "Docker") {
    ShowLogoutButton
  } elseif ($Requirement.Status -like "*WARNING*") {
    ShowYesNoButtons
  } else {
    ReloadEnvPath
    ShowNextButton
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
  Start-Process msiexec.exe -Wait -ArgumentList "/I $setupCaToolsMsiPath /quiet"
  
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
  #Start-Process powershell.exe -ArgumentList "npm-login.ps1 -user $($UsernameTextBox.Text) -token $($TokenTextBox.Text) -registry $NpmRegistry -scope $NpmScope" -WindowStyle hidden -RedirectStandardOutput $OutLogfile -RedirectStandardError $ErrorLogfile -Wait
  # Non setta correttamente .npmrc
  & npm-login.ps1 -user $UsernameTextBox.Text -token $TokenTextBox.Text -registry $NpmRegistry -scope $NpmScope *> $NpmLoginResultLogfile
  npm config set @ca-codegen:registry $NpmRegistry
  # Get-Content $ErrorLogfile, $OutLogfile | Set-Content $NpmLoginResultLogfile
  $NpmLoginMessage = Get-Content $NpmLoginResultLogfile
  $Description.Lines = $NpmLoginMessage
  ShowNextButton
  $script:StatusInstallation++
}

<# InstallCaPlatform
Installs the ca-platform, it will print errors if they are found
#>
function InstallCaPlatform {
  $Title.Text = "Install CA Enterprise Platform"
  $Description.Text = "Installing CA Enterprise Platform... (It will take a few minutes)"
  Start-Process $setupPlatformExePath -ArgumentList "-s" -WindowStyle hidden -RedirectStandardOutput $OutLogfile -RedirectStandardError $ErrorLogfile -Wait
  Get-Content $OutLogfile, $ErrorLogfile | Set-Content $FullLogfile
  $ArrayErrors = Get-Content $FullLogfile | Where-Object { $_ -like "*Error*" -or $_ -like "*ERR!*" }
  if ($ArrayErrors.Count -ne 0) {
    $CertPem = $ArrayErrors | Where-Object { $_ -like "*tunneling socket could not be established*" }
    if ($CertPem.Count -ne 0) {
      New-Item -Path "C:\cacert" -ItemType Directory -Force
      $Description.Text += "`r`n`r`nYou have a HTTPS Proxy active!`r`nTo continue the installation of CAEP add the certificate .pem in the folder C:\cacert.`r`nFor more information about the certificate .pem ask your System Administrator."
    } else {
      $Description.Text += "`r`nERRORS FOUND:"
      $ArrayErrors | ForEach-Object {  $Description.Text += "`r`n$_" }
      $Description.Text += "`r`nCheck the full logfile in the path $FullLogfile"
    }
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
  if (-not $VisualStudioCodeAutoExtension) {
    $Description.Text = "Visual Studio Code is already installed.`r`n"
  }
  $Description.AppendText("`r`nInstalling VSCode extensions`r`n")
  foreach ($item in $RecommendationsVSCode) {
    Start-Process code -ArgumentList "--install-extension $item --force" -WindowStyle hidden -RedirectStandardOutput $OutLogfile -RedirectStandardError $ErrorLogfile -Wait
    Get-Content $OutLogfile, $ErrorLogfile | Add-Content $VSCodeExtentionsLogfile
    $Description.Lines += Get-Content $OutLogfile, $ErrorLogfile
    $Description.Text += "`r`n"
    $Description.SelectionStart = $Description.TextLength;
	  $Description.ScrollToCaret()
  }
  $Description.AppendText("`r`nInstallation of VSCode extensions completed`r`n")
  $script:VisualStudioCodeAutoExtension = $true
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

  CreateScarfaceJSON -version $ScarVersion

  if ($ScarVersion -ne "") {
    npm i -g "@ca/generator-scarface@$ScarVersion"
  }
  
  Set-Location $testScarPath
  Start-Process $HOME\AppData\Roaming\npm\ca.cmd -ArgumentList "scar -c $ScarfaceConfigPath" -WindowStyle hidden -RedirectStandardOutput $OutLogfile -RedirectStandardError $ErrorLogfile -Wait
  Get-Content $OutLogfile, $ErrorLogfile | Set-Content $CaScarErrorLogfile
  $ScarfaceMessage = Get-Content $OutLogfile, $ErrorLogfile
  $Description.AppendText("`r`n$ScarfaceMessage")

  $script:StatusInstallation++
 
  $ArrayErrors = Get-Content $CaScarErrorLogfile | Where-Object { $_ -like "*Error*" -or $_ -like "*ERR!*" }
  if ($ArrayErrors.Count -ne 0) {
    $Description.Text += "`r`nERRORS FOUND:"
    $ArrayErrors | ForEach-Object {  $Description.Text += "`r`n$_" }
    $Description.Text += "`r`nCheck the full logfile in the path $CaScarErrorLogfile"
    ShowDoneButton
  } else {
    $Description.Text +="`r`nca scar executed correctly"
    $script:StatusInstallation++
  }
}

<# Print log confirm VM
#>
function OutFileAnswerNestedVirtualization($Answer) {
  if ($Answer) {
    "I have already run the command `"Set-VMProcessor -VMName <VMName> -ExposeVirtualizationExtensions $true`", and enabled the Nested Virtualization." | Out-File $AnswerNestedVirtualizationPath
    $Description.Text = "You have selected YES`r`nClick Next to continue the installation of CAEP."
    ShowNextButton
  } else {
    'I have not run the command Set-VMProcessor -VMName <VMName> -ExposeVirtualizationExtensions $true", and have the Nested Virtualization disabled yet.' | Out-File $AnswerNestedVirtualizationPath
    $Description.Text = "Please run the command`r`n`"Set-VMProcessor -VMName <VMName> -ExposeVirtualizationExtensions `$true`"`r`nRemember to Turn Off your Virtual Machine and to replace the <VMName> with the name of the YOUR Virtual machine.`r`nNB: This command must be run on PowerShell of your Host Machine with Administrator permission."
    ShowDoneButton
  }
}

<# NextScreen
Function used to go to the next step of the installation
#>
function NextScreen {
  switch ($StatusInstallation) {
    0 {
      if ($IndexRequirement -lt $RequirementsNotMet.Count) {
        ShowDownloadAndInstallRequirementScreen
      } elseif(-not $VisualStudioCodeAutoExtension) {
        InstallVSCodeExtensions
        CheckProxy
      } else {
        ShowMainScreen
      }
    }
    1 {
      InstallSetupCaTools
    }
    2 {
      ShowLoginNpm
    }
    3 {
      InstallCaPlatform
    }
    4 {
      ExecuteCaScar
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
$RestartButton.Add_Click({ Restart-Computer })
$LogoutButton.Add_Click({ logoff.exe })
$YesButton.Add_Click({ OutFileAnswerNestedVirtualization $true })
$NoButton.Add_Click({ OutFileAnswerNestedVirtualization $false })

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
  CreateLogfiles
}

# Shows the GUI
[void]$InstallForm.ShowDialog()

# SIG # Begin signature block
# MIIk2wYJKoZIhvcNAQcCoIIkzDCCJMgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUL1dVq9+xovBSHO/UusYQe/qV
# 6p2ggh62MIIFOTCCBCGgAwIBAgIQDue4N8WIaRr2ZZle0AzJjDANBgkqhkiG9w0B
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
# BBQPZwAJzcjd17hIiEnzL0oL+a0XaDAkBgorBgEEAYI3AgEMMRYwFKASgBAAQwBB
# ACAAVABvAG8AbABzMA0GCSqGSIb3DQEBAQUABIIBAFg3JOv5BeMUp3l4LZZwSk3a
# kDQnfd7fZ/yoAfckiAmhxtt2MQNe2wj1HUS1dS5pwhs+CRGJeqP0FlQATxiFyDCa
# TSSWmhzeugVx/Z4yLzmkOu8Jnu1pdtm8mADpVLtjqYS8IDX3ivNBC05pSzxOpWjP
# K/Aa4Jmck8WNJR8RzktySJhzwfbvGR2GD8q16IGTZdHHwx4q3FEgCRZmEtOXb/Fe
# AroqVpfvt1G6ZZ4ArzrEql6mQ+lAOVjNw2BI1eifxJ4dwnuYs+FGF860Z4p+kTNZ
# rzATSpKso1z5ypfC8JuI2vHxHfne8hZO/6ZRvftUXWkVapUrJuBwsZLJw2VTn/Ch
# ggNMMIIDSAYJKoZIhvcNAQkGMYIDOTCCAzUCAQEwgZIwfTELMAkGA1UEBhMCR0Ix
# GzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEY
# MBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMSUwIwYDVQQDExxTZWN0aWdvIFJTQSBU
# aW1lIFN0YW1waW5nIENBAhEAjHegAI/00bDGPZ86SIONazANBglghkgBZQMEAgIF
# AKB5MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
# MTIwNzEzNTI0MFowPwYJKoZIhvcNAQkEMTIEMOsOeEn84nglWCduofMlBcZtwpp0
# X9cln9Tk8aJ6RQqECxirXEWvIlxf/jA3R7w8gTANBgkqhkiG9w0BAQEFAASCAgBq
# 3chdsewpAzbi+a3TlpLWKgOU9fHYoaGymoJ+hasKnNUsBuo6CzcQ1IOE7OuoYMw1
# B+F8P71fYua8FaMZuhSJsCoddTombjYYRufCLE7MKwGh9xhSwP/ccnP/IIgjIhol
# gk53itzukPn/DFrUhe7DvhJtphKPqC5Iq9aIG6f6Sr+Uw3O1f38Odwf/Qs4JW5vI
# BdZF+KiOewEu9uUg94TK/3zEoy9N1RTXt+0BGxv87I0knJoa4nTbuh8nAr0YMGbM
# +ycIW4+jI5LLgaPVOjRFdnQ5DsFI/6hJYRHj8NL/bKmvhigSotHXvZ+cYhrd2omB
# HvfqRUU9PSNUf3bE4tHIfOYrtOQwpQBeGkZmIQSFKsTRXfvF/37We4wLUwwTCsxD
# 9m5cFDvEO6rY8rEw8jaw9I935ss2aKyKlBITSCe7G/24IioihBgMsEX6m54DMEkl
# EIPwK5lJdQsPfek+Q5LCSPYniXGjLejiCBDQjdxTE/+4GWYfHpfT1GI1xT0ooXOQ
# XKB2y0K+H574AaHe3HxAhXNM9vsd9ZQrYjQYikUQuFYpVvCo+Yy8qJh0t4a7QYzU
# 7gl34mjGn2/YpQuYjOwV5slHB4kuU8jsYCv4zqy/4oiqy5+oleljzRXMEgAyqjhb
# OjClT3GUk6lHu/HM1gg0idZr2SpUzkpN8o9J4eMcqA==
# SIG # End signature block
