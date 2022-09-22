param(
    [string]$randomCode,
    [string]$currentDate,
    [string]$reqMaxVersion,
    [string]$name
) #presenti nel main, da passare come param in "InstallCommand" (ricorda la MAIUSC iniziale!)

$argumentList = @(
    'i',
    '-g',
    "npm@$reqMaxVersion"
)

$nameNoSpaces = ($name.replace(' ', ''))
$Logfile = "~\.ca\$randomCode-nameNoSpaces-$currentDate.log"
$OutLogfile = "~\.ca\$randomCode-$nameNoSpaces-$currentDate.out"
$ErrLogfile = "~\.ca\$randomCode-$nameNoSpaces-$currentDate.err"
Start-Process npm -ArgumentList $argumentList -WindowStyle hidden -RedirectStandardOutput $OutLogfile -RedirectStandardError $ErrLogfile -Wait

