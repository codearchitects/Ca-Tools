try {
    
    $nugetRegistryAvailable = (Invoke-WebRequest -Uri https://api.nuget.org/v3/index.json -UseBasicParsing -DisableKeepAlive).StatusCode
    
    if ($nugetRegistryAvailable -eq 200) {
        return @($true, 'OK')
    }
    else {
        return @($false, 'KO')
    }
}
catch {
    return @($false, 'KO') }