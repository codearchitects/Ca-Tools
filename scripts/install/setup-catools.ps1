param(
    [string]$randomCode,
    [string]$currentDate,
    [string]$downloadOutfile,
    [string]$name
) #presenti nel main, da passare come param in "InstallCommand" (ricorda la MAIUSC iniziale!)

$argumentList = @(
    '/I',
    $downloadOutfile,
    '/passive'
)

. .\scripts\common.ps1 #richiama la funzione Remove-StartupCmd
Remove-StartupCmd

$nameNoSpaces = ($name.replace(' ', ''))
$Logfile = "~\.ca\$randomCode-$nameNoSpaces-$currentDate.log"
$OutLogfile = "~\.ca\$randomCode-$nameNoSpaces-$currentDate.out"
$ErrLogfile = "~\.ca\$randomCode-$nameNoSpaces-$currentDate.err"
Start-Process msiexec.exe -ArgumentList $argumentList -RedirectStandardOutput $OutLogfile -RedirectStandardError $ErrLogfile -Wait

