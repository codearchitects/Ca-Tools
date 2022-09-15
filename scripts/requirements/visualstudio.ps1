try {

    [version[]]$vsVersions = &'C:\\Program Files (x86)\\Microsoft Visual Studio\\Installer\\vswhere.exe' -property catalog_productDisplayVersion
    $vsVersion = ($vsVersions | Sort-Object -Descending)[0]
    
    if ( ($vsVersion.Major -ge "$($Requirement.MinVersion)") -and ($vsVersion.Major -le "$($Requirement.MaxVersion)") ) {
        return @($true, 'OK')
    }
    else {
        return @($true, 'VER')
    }

}
catch {
    return @($true, 'KO')
}