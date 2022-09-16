
$StartupPath = "~\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\caep-startup.cmd"
function  Remove-StartupCmd {
    <#
    .SYNOPSIS
    Remove the caep-startup.cmd
    .DESCRIPTION
    Removes the caep-startup.cmd once the user finished the installation
    #>
    Remove-Item -Path $StartupPath -Force -ErrorAction Ignore
  }