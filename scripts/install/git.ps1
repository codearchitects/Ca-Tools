param(
    [string]$randomCode,
    [string]$currentDate,
    [string]$name,
    [string]$downloadOutFile
) #presenti nel main, da passare come param in "InstallCommand" (ricorda la MAIUSC iniziale!)

$argumentList = @(
    '/VERYSILENT'
)

$NameNoSpaces = ($name.replace(' ', ''))
$Logfile = "~\.ca\$randomCode-$nameNoSpaces-$currentDate.log"
$OutLogfile = "~\.ca\$randomCode-$nameNoSpaces-$currentDate.out"
$ErrLogfile = "~\.ca\$randomCode-$nameNoSpaces-$currentDate.err"
Start-Process $downloadOutFile -ArgumentList $argumentList -RedirectStandardOutput $OutLogfile -RedirectStandardError $ErrLogfile -Wait