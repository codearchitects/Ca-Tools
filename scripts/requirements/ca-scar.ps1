Write-Host 'Checking if back-office sample project is generated...'

if (Test-Path C:\dev\scarface\back-office\client\node_modules\) {
    if ( !( (Get-ChildItem C:\dev\scarface\back-office\client\node_modules\ -Recurse -Filter *.js).Count ) ) {
        Write-Host 'node modules in C:\dev\scarface\back-office\client\node_modules\ not found!'
        return @($true, 'KO')
    }
    else {
        Write-Host '*js files in C:\dev\scarface\back-office\client\dist\back-office\ found!'
        return @($true, 'OK')
    }

    if ( !( Test-Path -Path C:\dev\scarface\back-office\client\dist\back-office\*.js ) ) {
        Write-Host '*js files in C:\dev\scarface\back-office\client\dist\back-office\ not found!'
        return @($true, 'KO')
    }
    else {
        Write-Host '*js files in C:\dev\scarface\back-office\client\dist\back-office\ found!'
        return @($true, 'OK')
    }
} else {
    Write-Host 'node_modules not found!'
    return @($true, 'KO')
}