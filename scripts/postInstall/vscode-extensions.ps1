param(
    [string]$name,
    [string]$randomCode,
    [string]$currentDate
)
    
$nameNoSpaces = ($name.replace(' ', ''))       #$NameNoSpaces = ("$($Requirement.Name)".replace(' ', ''))
$Logfile = "~\.ca\$randomCode-$nameNoSpaces-$currentDate.log"
$OutLogfile = "~\.ca\$randomCode-$nameNoSpaces-$currentDate.out"
$ErrLogfile = "~\.ca\$randomCode-$nameNoSpaces-$currentDate.err"

try {
    Start-Process code -ArgumentList "--install-extension $item --force" -WindowStyle hidden -RedirectStandardOutput $OutLogfile -RedirectStandardError $ErrLogfile -Wait
}
catch {
    return @($false, 'KO')
}