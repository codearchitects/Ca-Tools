param(
    [string]$randomCode,
    [string]$currentDate,
    [string]$name,
    [string]$downloadOutFile
)

$argumentList = @(
    '/q',
    '/norestart'
)

$nameNoSpaces = ($name.replace(' ', ''))
$Logfile = "~\.ca\$randomCode-$nameNoSpaces-$currentDate.log"
$OutLogfile = "~\.ca\$randomCode-$nameNoSpaces-$currentDate.out"
$ErrLogfile = "~\.ca\$randomCode-$nameNoSpaces-$currentDate.err"
Start-Process $downloadOutFile -ArgumentList $argumentList -RedirectStandardOutput $OutLogfile -RedirectStandardError $ErrLogfile -Wait