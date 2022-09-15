param(
    [string]$scarConfig
)

if ( !$scarConfig.Contains('terranova') ) {
    
    $result = $true
    $wslFeature = dism /online /get-featureinfo /featurename:Microsoft-Windows-Subsystem-Linux
    
    foreach ($item in $WslFeature) {
        
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