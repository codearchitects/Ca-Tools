param(
    [string]$minVersion #$($Requirement.MinVersion)
)

try {

    $vsCodeVersion = (code --version)[0]
    
    if ( $vsCodeVersion -ge $minVersion ) {
        return @($true, 'OK')
    }
    else {
        return @($true, 'VER')
    }
}
catch {
    return @($true, 'KO')
}