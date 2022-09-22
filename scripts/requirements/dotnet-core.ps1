param(
    [string]$maxVersion # $($Requirement.MajorVersion)
)  

try {
    
    $dotNetVersion = (dotnet --version).split('.')[0]
    
    if ( $dotNetVersion -eq $maxVersion ) {
        
        return @($true, 'OK')
    
    }
    else {
        
        return @($true, 'VER')
    }
}
catch {
    return @($true, 'KO')
}