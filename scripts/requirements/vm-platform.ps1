param(
    [string]$scarConfig
)

if ( !$scarConfig.Contains('terranova') ) {
    
    $result = $true
    $vmpFeature = dism /online /get-featureinfo /featurename:VirtualMachinePlatform
    
    foreach ( $item in $vmpFeature ) {
        if ( ($item -like '*Disabled*') -or ($item -like '*Disattivata*') ) {
            $result = $false
        }
    }
    if ( $result ) {
        return @($true, 'OK')
    }
    else {
        return @($true, 'KO')
    }
}
else {
    return @($true, 'OK')
}