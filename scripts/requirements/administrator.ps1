param(
    [string]$isAdmin # -isAdmin `$ResultPermission
)

$isAdmin = $null -ne (whoami /groups /fo csv | ConvertFrom-Csv | Where-Object { $_.SID -eq "S-1-5-32-544" })

if ($isAdmin -eq $true) {
    return @($true, 'OK')
}
else {
    return @($true, 'KO')
}