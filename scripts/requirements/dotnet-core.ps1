try {
    
    $dotNetVersion = (dotnet --version).split('.')[0]
    
    if ( $dotNetVersion -eq "$($Requirement.MajorVersion)" ) {
        
        return @($true, 'OK')
    
    }
    else {
        
        return @($true, 'VER')
    }
}
catch {
    return @($true, 'KO')
}