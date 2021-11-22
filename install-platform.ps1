param(
  [switch]$Silent,
  [string]$ScarVersion = ""
)
. ./check-requirements.ps1

if ($FoundError) { 
  Write-Host "Stop install-platform.ps1! Meet all requirements or contact Technical Operators" -ForegroundColor Red
  return
}

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  Write-Warning "PLEASE OPEN POWERSHELL AS ADMINISTRATOR!!!"
  return
}

$setupCaToolsMsi = "Setup_CaTools.msi"
$setupPlatformExe = "setup-ca-platform.exe"
$CaToolsPath = "C:\Program Files\Ca-Tools"
$testScarPath = "C:\dev\scarface"
$setupPlatformExePath = Join-Path $CaToolsPath $setupPlatformExe
$setupCaToolsMsiPath = Join-Path ${PWD} $setupCaToolsMsi
$errorLogsPath = "$HOME\.ca\errors_log.txt"
$Recommendations = @(
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

if(-not (Test-Path $setupCaToolsMsiPath)) {
  Write-Host "Download $setupCaToolsMsi"
  $latestRelease = Invoke-RestMethod https://api.github.com/repos/codearchitects/Ca-Tools/releases/latest
  $releaseDownloadUrl = $latestRelease.assets[0].browser_download_url
  Invoke-RestMethod $releaseDownloadUrl -OutFile $setupCaToolsMsiPath
} else {
  Write-Host "$setupCaToolsMsi already exists"
}

Write-Host "Installing Ca-Tools"
if ($Silent.IsPresent) {
  Write-Host "Silent install"
  Start-Process msiexec.exe -Wait -ArgumentList "/I $setupCaToolsMsiPath /quiet"
} else {
  Start-Process -Wait -FilePath $setupCaToolsMsiPath
}
Write-Host "Ca-Tools Installed"

Write-Host "Installing Ca-Platform"
& $setupPlatformExePath -s > $HOME\Desktop\errors_log.txt 2>&1
$NumberOfErrors = (Get-Content $errorLogsPath | Select-String "Error").Count
if ($NumberOfErrors -ne 0) {
  Write-Host "There're some error, check the log file in the path $errorLogsPath" -ForegroundColor Red -BackgroundColor Black
  return
} else {
  Write-Host "There aren't errors" -ForegroundColor Green
  return
}

Write-Host "Reload Env var Path"
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

if (-not (Test-Path $testScarPath)) {
  New-Item -ItemType Directory -Path $testScarPath -Force
}

if ($ScarVersion -ne "") {
  npm i -g npm install "@ca/generator-scarface@$ScarVersion"
}

Set-Location $testScarPath

foreach ($item in $Recommendations) {
  code --install-extension $item --force
}
ca scar