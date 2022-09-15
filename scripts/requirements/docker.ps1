param(
    [string]$scarConfig
)

if (!$scarConfig.Contains('terranova')) {
    
    try {
        
        $dockerVersion = (docker --version).replace(',', '').replace('Docker version', '').replace('build', '').Trim().Split(' ')[0]
        
        if ( ($dockerVersion -ge "$($Requirement.MinVersion)") -and ($dockerVersion -le "$($Requirement.MaxVersion)") ) {

            return @($true, 'OK')

        }else {

            return @($true, 'VER')

        }
    }
    catch {

        return @($true, 'KO')

    }
}
else {

    return @($true, 'OK')

}