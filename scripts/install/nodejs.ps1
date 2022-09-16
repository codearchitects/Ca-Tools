param(
    [string]$randomCode,
    [string]$nameNoSpaces,
    [string]$currentDate,
    [string]$name,
    [string]$downloadOutfile
) #presenti nel main, da passare come param in "InstallCommand" (ricorda la MAIUSC iniziale!)

$argumentList = @(
    '/I',
    $downloadOutfile, # $($Requirement.DownloadOutfile)
    '/passive'
)

$nameNoSpaces = ($name.replace(' ', ''))
$Logfile = "~\.ca\$randomCode-$nameNoSpaces-$currentDate.log"
$OutLogfile = "~\.ca\$randomCode-$nameNoSpaces-$currentDate.out"
$ErrLogfile = "~\.ca\$randomCode-NameNoSpaces-$currentDate.err"
Start-Process msiexec.exe -ArgumentList $argumentList -RedirectStandardOutput $OutLogfile -RedirectStandardError $ErrLogfile -Wait