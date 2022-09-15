$ComputerModel = (Get-CimInstance win32_computersystem).model

if (($ComputerModel -ne 'VMware Virtual Platform') -and ($ComputerModel -ne 'Virtual Machine') -and ($ComputerModel -ne 'Macchina Virtuale')) {
    return @($true, 'OK')
}
else {
    return @($true, 'KO')
}