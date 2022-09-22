param(
    [string]$maxVersion # $($Requirement.MajorVersion)
)

try {
    
    $gitVersion = (git --version).replace('git version ', '').replace('.windows.1', '').split('.')[0]

    if ($gitVersion -eq $maxVersion) {
        return @($true, 'OK')
    }
    else {
        return @($true, 'VER')
    }
}
catch {
    return @($true, 'KO')
}