param(
    [string]$currentDate
)

$InternetSettings = (Get-ItemProperty -Path "Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings")
$ProxyServer = ($InternetSettings.ProxyServer)
$DockerConfigPath = "~\.docker\config.json"
if (Test-Path $DockerConfigPath) {

    $DockerConfigJson = Get-Content $DockerConfigPath

    if (-not [String]::IsNullOrWhiteSpace($DockerConfigJson)) {
        $DockerConfigJson | Out-File "$DockerConfigPath.old.$currentDate"

    }
    else {
        New-Item -Path "$DockerConfigPath.old.$currentDate"
    }
    
    $DockerConfigObj = $DockerConfigJson | ConvertFrom-Json
    $DockerConfigObj.PSObject.Properties.Remove('proxies')
    $Proxies = @{
        'default' = @{
            'httpProxy'  = $InternetSettings.ProxyServer
            'httpsProxy' = $InternetSettings.ProxyServer
        }
    }

    $DockerConfigObj | Add-Member -NotePropertyName proxies -NotePropertyValue $Proxies -Force
    Set-Content -Path $DockerConfigPath -Value ($DockerConfigObj | ConvertTo-Json -Depth 5)

}