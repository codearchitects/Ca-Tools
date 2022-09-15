param(
  [string]$scarConfig
)

if (!$scarConfig.Contains('terranova')) {
    $wslLV = (wsl -l -v)
    $wslLVSplit = ([System.Text.Encoding]::Unicode.GetString([System.Text.Encoding]::Default.GetBytes($WslLV))).split(' ')
    $defaultDistroIndex = $wslLVSplit.IndexOf('*') + 1
    if ($defaultDistroIndex) {
        if ($wslLVSplit[$defaultDistroIndex] -like '*Ubuntu*') {
            return @($true, 'OK')
        }
        else {
            return @($true, 'KO')
        }
    }
    else {
        return @($true, 'KO')
    }
}
else {
    return @($true, 'OK')
}