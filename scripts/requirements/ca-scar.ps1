
$backOfficeClientPath = "C:\dev\scarface\back-office\client"
$backOfficeDistPath = Join-Path $backOfficeClientPath "dist"
$backOfficeNodeModulesPath = Join-Path $backOfficeClientPath "node_modules"
$backOfficeBundlePath = Join-Path $backOfficeDistPath "back-office"

Write-Host 'Checking if back-office sample project is generated...'

if (Test-Path $backOfficeNodeModulesPath) {
    if ( !( (Get-ChildItem $backOfficeNodeModulesPath -Recurse -Filter *.js).Count ) ) {
        Write-Host "node modules in $backOfficeNodeModulesPath not found!"
        return @($true, 'KO')
    }
    else {
        Write-Host "*js files in $backOfficeBundlePath found!"
        return @($true, 'OK')
    }

    if ( !( Test-Path -Path $backOfficeBundlePath*.js ) ) {
        Write-Host "*js files in $backOfficeBundlePath not found!"
        return @($true, 'KO')
    }
    else {
        Write-Host "*js files in $backOfficeBundlePath found!"
        return @($true, 'OK')
    }
} else {
    Write-Host 'node_modules not found!'
    return @($true, 'KO')
}