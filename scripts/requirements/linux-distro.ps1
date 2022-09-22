param(
    [string]$scarConfig,
    [string]$maxVersion, # $($Requirement.MaxVersion)
    [string]$minVersion  # $($Requirement.MinVersion)
)
if ( !$scarConfig.Contains('terranova') ) {
    
    $wslLV = (wsl -l -v)
    $wslLVSplit = ([System.Text.Encoding]::Unicode.GetString([System.Text.Encoding]::Default.GetBytes($wslLV))).split(' ')
    $result = $false
    
    for ($i = 0; $i -lt $wslLVSplit.Count; $i++) {
        
        if ( ($wslLVSplit[$i] -like "*Ubuntu-$maxVersion*") -or ($wslLVSplit[$i] -like "*Ubuntu-$minVersion*") ) {
            
            $result = $true
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