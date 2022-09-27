param(
    $attributes #$($Requirement.Attributes)
)   

$NotInstalled = $false

try {
    $InstalledVSCodeExtensions = (code --list-extensions)

    foreach ( $Extension in "$attributes".Split(' ') ) {

        if ( ($InstalledVSCodeExtensions -like ("*$Extension*").ToLower()).Count -eq 0 ) {
            $NotInstalled = $true
        }
    }
}
catch {
    return @($true, 'KO')
}

if ($NotInstalled) {
    return @($true, 'KO')
}
else {
    return @($true, 'OK')
}