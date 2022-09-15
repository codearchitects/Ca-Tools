try {

    $npmVersion = (npm --version).split('.')[0]

    if ( $npmVersion -eq "$($Requirement.MajorVersion)" ) {

        return @($true, 'OK')
    }
    else {

        return @($true, 'VER')

    }
}
catch {

    return @($true, 'KO')
    
}