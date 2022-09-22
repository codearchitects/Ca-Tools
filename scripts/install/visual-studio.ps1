param(
    [string]$randomCode,
    [string]$currentDate,
    [string]$name,
    [string]$downloadOutFile
) #presenti nel main, da passare come param in "InstallCommand" (ricorda la MAIUSC iniziale!)

$argumentList = @(
    '--add Microsoft.VisualStudio.Workload.NetWeb',
    '--add Microsoft.VisualStudio.Workload.CoreEditor',
    '--add Microsoft.VisualStudio.Workload.ManagedDesktop',
    '--add Microsoft.VisualStudio.Workload.Universal',
    '--add Microsoft.NetCore.Component.Runtime.5.0',
    '--add Microsoft.NetCore.Component.Runtime.3.1',
    '--passive',
    '--norestart'
)

$nameNoSpaces = ($name.replace(' ', ''))
$Logfile = "~\.ca\$randomCode-$nameNoSpaces-$currentDate.log"
$OutLogfile = "~\.ca\$randomCode-$nameNoSpaces-$currentDate.out"
$ErrLogfile = "~\.ca\$randomCode-$nameNoSpaces-$currentDate.err"
Start-Process $downloadOutFile -ArgumentList $argumentList -RedirectStandardOutput $OutLogfile -RedirectStandardError $ErrLogfile -Wait