param(
    [string]$nameNoSpaces,
    [string]$name,
    [string]$randomCode,
    [string]$currentDate
)
    
$NameNoSpaces = ($name.replace(' ', ''))       #$NameNoSpaces = ("$($Requirement.Name)".replace(' ', ''))
$Logfile = "~\.ca\$RandomCode-$NameNoSpaces-$CurrentDate.log"
$OutLogfile = "~\.ca\$RandomCode-$NameNoSpaces-$CurrentDate.out"
$ErrLogfile = "~\.ca\$RandomCode-$NameNoSpaces-$CurrentDate.err"

try {
    Start-Process code -ArgumentList "--install-extension $item --force" -WindowStyle hidden -RedirectStandardOutput $OutLogfile -RedirectStandardError $ErrLogfile -Wait
}
catch {
    return @($false, 'KO')
}