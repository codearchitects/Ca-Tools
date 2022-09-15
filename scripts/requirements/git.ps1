try {
    
    $gitVersion = (git --version).replace('git version ', '').replace('.windows.1', '').split('.')[0]

    if ($gitVersion -eq "$($Requirement.MajorVersion)") {
        return @($true, 'OK')
    }
    else {
        return @($true, 'VER')
    }
}
catch {
    return @($true, 'KO')
}