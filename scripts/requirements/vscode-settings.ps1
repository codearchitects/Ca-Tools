$VSCodeSettingsPath = "~\AppData\Roaming\Code\User"
$VSCodeSettingsJsonPath = "~\AppData\Roaming\Code\User\settings.json\"

if (Test-Path $VSCodeSettingsPath) {
    if (-not (Test-Path $VSCodeSettingsJsonPath)) {
        New-Item -Path $VSCodeSettingsJsonPath -Value '{ }' -Force | Out-Null
        return @($true, 'KO')
    }
    else {
        $SettingsContent = Get-Content -Path $VSCodeSettingsJsonPath | ConvertFrom-Json
        if (($null -ne $SettingsContent.'terminal.integrated.defaultProfile.windows') -or ($null -ne $SettingsContent.'terminal.integrated.shellArgs.windows') -or ($null -ne $SettingsContent.'terminal.integrated.profiles.windows')) {
            return @($true, 'KO')
        }
        elseif (($SettingsContent.'terminal.integrated.shell.windows' -eq 'C:\WINDOWS\System32\cmd.exe') -and ($SettingsContent.'update.mode' -eq 'manual')) {
            return @($true, 'OK')
        }
        else {
            return @($true, 'KO')
        }
    }
}
else {
    return @($true, 'KO')
}