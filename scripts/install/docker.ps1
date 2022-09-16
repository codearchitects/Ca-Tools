param(
    [string]$randomCode,
    [string]$nameNoSpaces,
    [string]$currentDate,
    [string]$name,
    [string]$downloadOutfile
) #presenti nel main, da passare come param in "InstallCommand" (ricorda la MAIUSC iniziale!)

$argumentList = @(
    'install',
    '--quiet'
)

$nameNoSpaces = ($name.replace(' ', ''))
$Logfile = "~\.ca\$randomCode-$nameNoSpaces-$currentDate.log"
$OutLogfile = "~\.ca\$randomCode-$nameNoSpaces-$currentDate.out"
$ErrLogfile = "~\.ca\$randomCode-$nameNoSpaces-$currentDate.err"
Start-Process $downloadOutFile -ArgumentList $argumentList -RedirectStandardOutput $OutLogfile -RedirectStandardError $ErrLogfile -Wait