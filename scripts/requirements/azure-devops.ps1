$azureDevOpsAvailable = (Test-NetConnection devops.codearchitects.com -port 444).TcpTestSucceeded

if ($azureDevOpsAvailable) {
    
    try {
        Invoke-WebRequest -Uri https://devops.codearchitects.com:444/ -UseBasicParsing -DisableKeepAlive
    }
    catch {
        $status = $_.Exception.Response.StatusCode.value__
    }
    if ($status -eq 401) {
        return @($true, 'OK')
    }
    else {
        return @($false, 'KO')
    }
}
else {
    return @($false, 'TCP')
}