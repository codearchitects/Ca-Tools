$VSCodeSettingsJsonPath = "~\AppData\Roaming\Code\User\settings.json"

if (-not (Get-Content $VSCodeSettingsJsonPath)) {
    Set-Content -Path $VSCodeSettingsJsonPath -Value '{ }'
}

$VSCodeSettingObj = Get-Content $VSCodeSettingsJsonPath | ConvertFrom-Json
$VSCodeSettingObj = $VSCodeSettingObj | Select-Object * -ExcludeProperty 'terminal.integrated.shell.windows', 'terminal.integrated.defaultProfile.windows', 'terminal.integrated.shellArgs.windows', 'terminal.integrated.profiles.windows'
$VSCodeSettingObj | Add-Member -NotePropertyName 'terminal.integrated.shell.windows' -NotePropertyValue 'C:\WINDOWS\System32\cmd.exe' -Force
$VSCodeSettingObj | Add-Member -NotePropertyName 'update.mode' -NotePropertyValue 'manual' -Force
$VSCodeSettingObj.PsObject.Properties.Remove('*')
Set-Content -Path $VSCodeSettingsJsonPath -Value ($VSCodeSettingObj | ConvertTo-Json -Depth 5)