if (Test-Path "$env:PROGRAMFILES\Ca-Tools") {
    return @($true, 'OK')
} else {
    return @($true, 'KO')
}