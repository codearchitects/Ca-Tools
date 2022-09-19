#WSL Distribution "CheckRequirement" .json property

param(
    [string]$message
)

$WslLV = (wsl -l -v)
$WslLVSplit = ([System.Text.Encoding]::Unicode.GetString([System.Text.Encoding]::Default.GetBytes($WslLV))).split(' ')

foreach($item in $WslLVSplit) {
    if($item -like '*Ubuntu*') {
        $UbuntuDistro = $item
    }
}
return $message + " $UbuntuDistro..."