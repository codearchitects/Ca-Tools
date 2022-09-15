param(
  [string]$scarConfig
)

if ( !$scarConfig.Contains('terranova') ) {
    $wslStatus = (wsl --status)
    $wslStatusSplit = ([System.Text.Encoding]::Unicode.GetString([System.Text.Encoding]::Default.GetBytes($wslStatus))).split(' ')
    $wslVersionResult = $false
    
foreach ( $item in $wslStatusSplit ) {
    if ( $item -eq '2' ) {
        $wslVersionResult = $true
    }
}
if ( $wslVersionResult ) {
    return @($true, 'OK')
} else {
    return @($true, 'KO')
}
}
else {
    return @($true, 'OK')
}