param(
    [string]$majorVersion # $($Requirement.MajorVersion)
) 

try {

    $npmVersion = (npm --version).split('.')[0]

    if ( $npmVersion -eq $majorVersion) {

        return @($true, 'OK')
    }
    else {

        return @($true, 'VER')

    }
}
catch {

    return @($true, 'KO')
    
}