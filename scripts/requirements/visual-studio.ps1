param(
    [string]$minVersion, # $($Requirement.MinVersion)
    [string]$maxVersion  # $($Requirement.MaxVersion)
)

try {

    [version[]]$vsVersions = &'C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe' -property catalog_productDisplayVersion
    $vsVersion = ($vsVersions | Sort-Object -Descending)[0]
    
    if ( ($vsVersion.Major -ge $minVersion) -and ($vsVersion.Major -le $maxVersion) ) {
        return @($true, 'OK')
    }
    else {
        return @($true, 'VER')
    }

}
catch {
    return @($true, 'KO')
}