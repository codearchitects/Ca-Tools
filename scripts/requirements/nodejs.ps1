param(
    [string]$majorVersion
)
    
try {

    $nodeJsVersion = (node --version).replace('v','').split('.')[0]
    
    if ($nodeJsVersion -eq $majorVersion) {
        return @($true, 'OK')
    }
    else {
        return @($true, 'VER')
    }

}
catch {
    return @($true, 'KO')
}