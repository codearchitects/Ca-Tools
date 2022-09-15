$ProxyData = Get-ItemProperty -Path 'Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings' | Select-Object 'Proxy*';

if ( $ProxyData.ProxyEnable -eq 1 ) {
  $ProxyDataSplit = $ProxyData.ProxyServer -split ':'
  if ($ProxyDataSplit.Count -eq 2) {
    $ProxyAddress = $ProxyDataSplit[0]
    $ProxyPort = $ProxyDataSplit[1]
  }
  else {
    $ProxyAddress = $ProxyDataSplit[1].replace('/', '')
    $ProxyPort = $ProxyDataSplit[2]
  }
  if ( (Test-NetConnection -ComputerName $ProxyAddress -Port $ProxyPort).TcpTestSucceeded) {
    return @($true, 'KO')
  }
  else {
    return @($false, 'KO')
  }
}
else {
  return @($true, 'OK')
}