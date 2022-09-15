try {

    $npmRegistryAvailable = (Invoke-WebRequest -Uri https://registry.npmjs.org -UseBasicParsing -DisableKeepAlive).StatusCode
    
    if ($npmRegistryAvailable -eq 200) {
        
        return @($true, 'OK')
    }
    else {
        return @($false, 'KO')
    }
}
catch { return @($false, 'KO')
}