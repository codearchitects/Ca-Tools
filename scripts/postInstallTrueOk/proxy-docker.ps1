param(
    [string]$currentDate
)

$DockerConfigPath = "~\.docker\config.json"

if (Test-Path $DockerConfigPath) {
    $DockerConfigJson = Get-Content $DockerConfigPath
    $DockerConfigJson | Out-File "$DockerConfigPath.old.$currentDate"
    $DockerConfigObj = $DockerConfigJson | ConvertFrom-Json
    $DockerConfigObj.PSObject.Properties.Remove('proxies')
    Set-Content -Path $DockerConfigPath -Value ($DockerConfigObj | ConvertTo-Json -Depth 5)
}