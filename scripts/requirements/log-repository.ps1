$logRepoAvailable = (Test-NetConnection casftp.blob.core.windows.net -port 22).TcpTestSucceeded

if ($logRepoAvailable -eq $True) {
    return @($true, 'OK')
}
else {
    return @($false, 'KO')
}