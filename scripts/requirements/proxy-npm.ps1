$InternetSettings = (Get-ItemProperty -Path 'Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings')

$ProxyDataSplit = $InternetSettings.ProxyServer -split ':'

if ($ProxyDataSplit.Count -eq 2) {
    $ProxyAddress = $ProxyDataSplit[0]; $ProxyPort = $ProxyDataSplit[1]
}
elseif ($ProxyDataSplit.Count -eq 3) {
    $ProxyAddress = $ProxyDataSplit[1].replace('/','')
    $ProxyPort = $ProxyDataSplit[2]
}

if ($InternetSettings.ProxyEnable -eq 0) {
    return @(`$true, 'OK')
}
elseif ((Test-NetConnection -ComputerName $ProxyAddress -Port $ProxyPort).TcpTestSucceeded) {
    return @($true, 'KO')
}
else {
    return @($false, 'KO')
}