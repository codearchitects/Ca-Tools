param(
  [switch]$Silent,
  [string]$ScarVersion = ""
)
./check-requirements.ps1

$setupCaToolsMsi = "Setup_CaTools.msi"
$setupPlatformExe = "setup-ca-platform.exe"
$CaToolsPath = "C:\Program Files\Ca-Tools"
$testScarPath = "C:\dev\scarface"
$setupPlatformExePath = Join-Path $CaToolsPath $setupPlatformExe
$setupCaToolsMsiPath = Join-Path ${PWD} $setupCaToolsMsi

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
& $setupPlatformExePath -s

Write-Host "Reload Env var Path"
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

if (-not (Test-Path $testScarPath)) {
  New-Item -ItemType Directory -Path $testScarPath -Force
}

if ($ScarVersion -ne "") {
  npm i -g npm install "@ca/generator-scarface@$ScarVersion"
}

Set-Location $testScarPath
ca scar