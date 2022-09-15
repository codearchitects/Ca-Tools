try {

    $vsCodeVersion = (code --version)[0]
    
    if ( $vsCodeVersion -ge "$($Requirement.MinVersion)" ) {
        return @($true, 'OK')
    }
    else {
        return @($true, 'VER')
    }
}
catch {
    return @($true, 'KO')
}