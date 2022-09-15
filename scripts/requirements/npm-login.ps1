param(
    [string]$randomCode,
    [string]$currentDate 
)

$npmLoginNoSpace = "$($Requirement.Name)".replace(' ', '')
$npmLogfile = "~\.ca\$randomCode-$npmLoginNoSpace-$currentDate.log"; $npmOutLogfile = "~\.ca\$randomCode-$npmLoginNoSpace-$currentDate.out"
$npmErrLogfile = "~\.ca\$randomCode-$npmLoginNoSpace-$currentDate.err"

Start-Process $($Requirement.PathFile) -ArgumentList "$($Requirement.ArgumentList)" -WindowStyle hidden -RedirectStandardOutput $npmOutLogfile -RedirectStandardError $npmErrLogfile -Wait

Get-Content $npmOutLogfile, $npmErrLogfile | Set-Content $npmLogfile

Start-Process $($Requirement.PathFile) -ArgumentList 'npm view @ca-codegen/core' -WindowStyle hidden -RedirectStandardOutput $npmOutLogfile -RedirectStandardError $npmErrLogfile -Wait

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