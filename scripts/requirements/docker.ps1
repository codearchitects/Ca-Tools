param(
    [string]$scarConfig,
    [string]$maxVersion,
    [string]$minVersion
)

if (!$scarConfig.Contains('terranova')) {
    
    try {
        
        $dockerVersion = (docker --version).replace(',', '').replace('Docker version', '').replace('build', '').Trim().Split(' ')[0]
        
        if ( ($dockerVersion -ge $minVersion) -and ($dockerVersion -le $maxVersion) ) {

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