param(
    [string]$randomCode,
    [string]$currentDate,
    [string]$name, # $($Requirement.Name)
    [string]$pathFile, # $($Requirement.PathFile)
    [string]$arguments # $($Requirement.ArgumentList)
)

$npmLoginNoSpace = $name.replace(' ', '')
$npmLogfile = "~\.ca\$randomCode-$npmLoginNoSpace-$currentDate.log"
$npmOutLogfile = "~\.ca\$randomCode-$npmLoginNoSpace-$currentDate.out"
$npmErrLogfile = "~\.ca\$randomCode-$npmLoginNoSpace-$currentDate.err"

Start-Process $pathFile -ArgumentList $arguments -WindowStyle hidden -RedirectStandardOutput $npmOutLogfile -RedirectStandardError $npmErrLogfile -Wait

Get-Content $npmOutLogfile, $npmErrLogfile | Set-Content $npmLogfile

Start-Process $pathFile -ArgumentList 'npm view @ca-codegen/core' -WindowStyle hidden -RedirectStandardOutput $npmOutLogfile -RedirectStandardError $npmErrLogfile -Wait

Get-Content $npmOutLogfile, $npmErrLogfile | Add-Content $npmLogfile

$npmLoginLogfile = Get-Content $npmLogfile
$errorsNpm = 0

foreach ($item in $npmLoginLogfile) {
    if ( ($item -like '*ERR!*') -or ($item -like '*error*') ) {
        $errorsNpm++
    }
}
if ( ($errorsNpm -eq 0) ) {
    return @($true, 'OK')

} else {
    return @($true, 'KO')
}