param(
    [string]$resultPermission
)

$whoAmI = "$(whoami)"
$whoAmILower = $whoAmI.ToLower()
$resultPermission = $false
$listAdministrators = (net localgroup Administrators)
$temp = @()

foreach ($item in $listAdministrators) {
    if ( ($item -match '\S') -and ($item -ne 'Administrator') -and ($item -ne 'user1') -and ($item -ne 'user2') ) {
        $temp += $item
    }
}

$listAdministrators = $temp | Select-Object -Skip 4 | Select-Object -SkipLast 1

$itemLower = $listAdministrators.ToLower()

foreach ($item in $itemLower) {
    if ($itemLower -like "*$whoAmILower") {
        $resultPermission = $true
    }
}

if ($resultPermission) {
    return @($true, 'OK')
}
else {
    return @($true, 'KO')
}