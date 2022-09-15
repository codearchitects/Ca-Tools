$envValues = ("$($Requirement.Values)").Split(';')
$notFound = $false; $envPath = "$env:PATH"

foreach ($value in $envValues) {
    if ( (($envPath.ToLower()).Split(';') -notcontains ("$Value").ToLower()) -and (($envPath.ToLower()).Split(';') -notcontains ("$value\\").ToLower()) ) {
        $notFound = $true
    }
}
if ($notFound) {
    return @($true, 'KO')
}
else {
    return @($true, 'OK')
}