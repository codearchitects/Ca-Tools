$InternetSettings = (Get-ItemProperty -Path 'Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings')
$ProxyServer = ($InternetSettings.ProxyServer)

Start-Process powershell.exe -ArgumentList "npm config set proxy $ProxyServer" -WindowStyle hidden -Wait
Start-Process powershell.exe -ArgumentList "npm config set https-proxy $ProxyServer" -WindowStyle hidden -Wait