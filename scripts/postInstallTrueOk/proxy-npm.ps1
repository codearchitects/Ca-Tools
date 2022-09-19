param(
    [string]$currentDate
)

$NpmrcFilePath = "~\.npmrc"

if (Test-Path $NpmrcFilePath) {
    Get-Content $NpmrcFilePath | Out-File "$NpmrcFilePath.old.$currentDate"
    Start-Process powershell.exe -ArgumentList "npm config delete proxy" -WindowStyle hidden -Wait
    Start-Process powershell.exe -ArgumentList "npm config delete https-proxy" -WindowStyle hidden -Wait
    Start-Process powershell.exe -ArgumentList "npm config delete cafile" -WindowStyle hidden -Wait
}