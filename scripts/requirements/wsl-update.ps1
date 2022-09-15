param(
    [string]$scarConfig
)

if ( !$scarConfig.Contains('terranova') ) {

    $wslStatus = (wsl --status)
    $wslStatusSplit = ([System.Text.Encoding]::Unicode.GetString([System.Text.Encoding]::Default.GetBytes($wslStatus))).split(' '); $Result = $false
    
    for ($i = 0; $i -lt $wslStatusSplit.Count; $i++) {
        
        if ($wslStatusSplit[$i] -like 'Kernel') {
            $j = $i + 1
            
            if ($wslStatusSplit[$j] -like '*version*') {
                $Result = $true
            }
        }
        elseif ($wslStatusSplit[$i] -like 'Versione') {
            $j = $i + 1; $k = $j + 1
            
            if (($wslStatusSplit[$j] -like 'del') -and ($wslStatusSplit[$k] -like '*kernel*') ) {
                $Result = $true
            }
        }
    }
    
    if ($Result) {
        return @($true, 'OK')
    }
    else {
        return @($true, 'KO')

    }
}
else {
    return @($true, 'OK')

}