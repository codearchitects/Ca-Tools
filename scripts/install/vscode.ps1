param(
    [string]$randomCode,
    [string]$nameNoSpaces,
    [string]$currentDate,
    [string]$name,
    [string]$downloadOutFile
)

$argumentList = @(
    '/VERYSILENT',
    '/NORESTART',
    '/mergetasks=!runcode'
)

$nameNoSpaces = ($name.replace(' ', ''))
$Logfile = "~\.ca\$randomCode-$nameNoSpaces-$currentDate.log"
$OutLogfile = "~\.ca\$randomCode-$nameNoSpaces-$currentDate.out"
$ErrLogfile = "~\.ca\$randomCode-$nameNoSpaces-$currentDate.err"

Start-Process $downloadOutFile -ArgumentList $argumentList -RedirectStandardOutput $OutLogfile -RedirectStandardError $ErrLogfile -Wait

$env:Path = [System.Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path','User')
code
$CodeProcesses = (Get-Process Code -ErrorAction SilentlyContinue)

if ($CodeProcesses) {
    foreach ($CodeProcess in $CodeProcesses) {
        $CodeProcess.CloseMainWindow()
    }
}