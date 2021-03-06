param(
[string]$ScarVersion = "",
[string]$ScarConfig = "https://castorybookbloblwebsite.blob.core.windows.net/scar-configs/scarface.config.json"
)

#---------------------------------------------------------[Initialisations]--------------------------------------------------------
# Init PowerShell Gui
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#---------------------------------------------------------[Form]--------------------------------------------------------

[System.Windows.Forms.Application]::EnableVisualStyles()

$InstallForm                    = New-Object System.Windows.Forms.Form
$InstallForm.ClientSize         = '800,500'
$InstallForm.Text               = "Install CAEP"
$InstallForm.BackColor          = "#ffffff"
$InstallForm.TopMost            = $false

$Title                          = New-Object System.Windows.Forms.Label
$Title.Text                     = "Install Code Architects Enterprise Platform"
$Title.AutoSize                 = $true
$Title.Width                    = 25
$Title.Height                   = 10
$Title.Location                 = New-Object System.Drawing.Point(20,20)
$Title.Font                     = 'Microsoft Sans Serif,13,style=Bold'

$Description                    = New-Object System.Windows.Forms.RichTextBox
$Description.Text               = ""
$Description.AutoSize           = $false
$Description.Multiline          = $true
$Description.ReadOnly           = $true
$Description.Scrollbars         = "Vertical"
$Description.Width              = 700
$Description.Height             = 300
$Description.Location           = New-Object System.Drawing.Point(20,50)
$Description.Font               = 'Consolas,10'

$UsernameLabel                  = New-Object System.Windows.Forms.Label
$UsernameLabel.Text             = "Username:"
$UsernameLabel.AutoSize         = $true
$UsernameLabel.Width            = 25
$UsernameLabel.Height           = 20
$UsernameLabel.Location         = New-Object System.Drawing.Point(70,143)
$UsernameLabel.Font             = 'Microsoft Sans Serif,10,style=Bold'
$UsernameLabel.Visible          = $false

$UsernameTextBox                = New-Object System.Windows.Forms.TextBox
$UsernameTextBox.Multiline      = $false
$UsernameTextBox.Width          = 200
$UsernameTextBox.Height         = 20
$UsernameTextBox.Location       = New-Object System.Drawing.Point(155,140)
$UsernameTextBox.Font           = 'Microsoft Sans Serif,10'
$UsernameTextBox.Visible        = $false

$TokenLabel                     = New-Object System.Windows.Forms.Label
$TokenLabel.Text                = "Token:"
$TokenLabel.AutoSize            = $true
$TokenLabel.Width               = 25
$TokenLabel.Height              = 20
$TokenLabel.Location            = New-Object System.Drawing.Point(70,173)
$TokenLabel.Font                = 'Microsoft Sans Serif,10,style=Bold'
$TokenLabel.Visible             = $false

$TokenTextBox                   = New-Object System.Windows.Forms.TextBox
$TokenTextBox.Multiline         = $false
$TokenTextBox.Width             = 200
$TokenTextBox.Height            = 20
$TokenTextBox.Location          = New-Object System.Drawing.Point(155,170)
$TokenTextBox.Font              = 'Microsoft Sans Serif,10'
$TokenTextBox.Visible           = $false

$EmailLabel                  = New-Object System.Windows.Forms.Label
$EmailLabel.Text             = "Email:"
$EmailLabel.AutoSize         = $true
$EmailLabel.Width            = 25
$EmailLabel.Height           = 20
$EmailLabel.Location         = New-Object System.Drawing.Point(370,143)
$EmailLabel.Font             = 'Microsoft Sans Serif,10,style=Bold'
$EmailLabel.Visible          = $false

$EmailTextBox                = New-Object System.Windows.Forms.TextBox
$EmailTextBox.Multiline      = $false
$EmailTextBox.Width          = 200
$EmailTextBox.Height         = 20
$EmailTextBox.Location       = New-Object System.Drawing.Point(445,140)
$EmailTextBox.Font           = 'Microsoft Sans Serif,10'
$EmailTextBox.Visible        = $false

$PasswordLabel                  = New-Object System.Windows.Forms.Label
$PasswordLabel.Text             = "Password:"
$PasswordLabel.AutoSize         = $true
$PasswordLabel.Width            = 25
$PasswordLabel.Height           = 20
$PasswordLabel.Location         = New-Object System.Drawing.Point(370,173)
$PasswordLabel.Font             = 'Microsoft Sans Serif,10,style=Bold'
$PasswordLabel.Visible          = $false

$PasswordTextBox                = New-Object System.Windows.Forms.TextBox
$PasswordTextBox.Multiline      = $false
$PasswordTextBox.Width          = 200
$PasswordTextBox.Height         = 20
$PasswordTextBox.Location       = New-Object System.Drawing.Point(445,170)
$PasswordTextBox.Font           = 'Microsoft Sans Serif,10'
$PasswordTextBox.Visible        = $false

$NextButton                     = New-Object System.Windows.Forms.Button
$NextButton.BackColor           = "#ff7b00"
$NextButton.Text                = "Next"
$NextButton.Width               = 90
$NextButton.Height              = 30
$NextButton.Location            = New-Object System.Drawing.Point(550,400)
$NextButton.Font                = 'Microsoft Sans Serif,10'
$NextButton.ForeColor           = "#ffffff"

$LoginButton                     = New-Object System.Windows.Forms.Button
$LoginButton.BackColor           = "#ff7b00"
$LoginButton.Text                = "Login"
$LoginButton.Width               = 90
$LoginButton.Height              = 30
$LoginButton.Location            = New-Object System.Drawing.Point(550,400)
$LoginButton.Font                = 'Microsoft Sans Serif,10'
$LoginButton.ForeColor           = "#ffffff"
$LoginButton.Visible             = $false

$DoneButton                     = New-Object System.Windows.Forms.Button
$DoneButton.BackColor           = "#ff7b00"
$DoneButton.Text                = "Done"
$DoneButton.Width               = 90
$DoneButton.Height              = 30
$DoneButton.Location            = New-Object System.Drawing.Point(550,400)
$DoneButton.Font                = 'Microsoft Sans Serif,10'
$DoneButton.ForeColor           = "#ffffff"
$DoneButton.Visible             = $false

$EndButton                     = New-Object System.Windows.Forms.Button
$EndButton.BackColor           = "#ff7b00"
$EndButton.Text                = "End"
$EndButton.Width               = 90
$EndButton.Height              = 30
$EndButton.Location            = New-Object System.Drawing.Point(550,400)
$EndButton.Font                = 'Microsoft Sans Serif,10'
$EndButton.ForeColor           = "#ffffff"
$EndButton.Visible             = $false

$AcceptButton                     = New-Object System.Windows.Forms.Button
$AcceptButton.BackColor           = "#ff7b00"
$AcceptButton.Text                = "Accept"
$AcceptButton.Width               = 90
$AcceptButton.Height              = 30
$AcceptButton.Location            = New-Object System.Drawing.Point(550,400)
$AcceptButton.Font                = 'Microsoft Sans Serif,10'
$AcceptButton.ForeColor           = "#ffffff"
$AcceptButton.Visible             = $false

$RestartButton                     = New-Object System.Windows.Forms.Button
$RestartButton.BackColor           = "#ff7b00"
$RestartButton.Text                = "Restart"
$RestartButton.Width               = 90
$RestartButton.Height              = 30
$RestartButton.Location            = New-Object System.Drawing.Point(550,400)
$RestartButton.Font                = 'Microsoft Sans Serif,10'
$RestartButton.ForeColor           = "#ffffff"
$RestartButton.Visible             = $false

$LogoutButton                     = New-Object System.Windows.Forms.Button
$LogoutButton.BackColor           = "#ff7b00"
$LogoutButton.Text                = "Logout"
$LogoutButton.Width               = 90
$LogoutButton.Height              = 30
$LogoutButton.Location            = New-Object System.Drawing.Point(550,400)
$LogoutButton.Font                = 'Microsoft Sans Serif,10'
$LogoutButton.ForeColor           = "#ffffff"
$LogoutButton.Visible             = $false

$DeclineButton                   = New-Object System.Windows.Forms.Button
$DeclineButton.BackColor         = "#ffffff"
$DeclineButton.Text              = "Decline"
$DeclineButton.Width             = 90
$DeclineButton.Height            = 30
$DeclineButton.Location          = New-Object System.Drawing.Point(450,400)
$DeclineButton.Font              = 'Microsoft Sans Serif,10'
$DeclineButton.ForeColor         = "#000"
$DeclineButton.Visible           = $false

$YesButton                     = New-Object System.Windows.Forms.Button
$YesButton.BackColor           = "#ff7b00"
$YesButton.Text                = "Yes"
$YesButton.Width               = 90
$YesButton.Height              = 30
$YesButton.Location            = New-Object System.Drawing.Point(550,400)
$YesButton.Font                = 'Microsoft Sans Serif,10'
$YesButton.ForeColor           = "#ffffff"
$YesButton.Visible             = $false

$NoButton                   = New-Object System.Windows.Forms.Button
$NoButton.BackColor         = "#ffffff"
$NoButton.Text              = "No"
$NoButton.Width             = 90
$NoButton.Height            = 30
$NoButton.Location          = New-Object System.Drawing.Point(450,400)
$NoButton.Font              = 'Microsoft Sans Serif,10'
$NoButton.ForeColor         = "#000"
$NoButton.Visible           = $false

$CancelButton                   = New-Object System.Windows.Forms.Button
$CancelButton.BackColor         = "#ffffff"
$CancelButton.Text              = "Cancel"
$CancelButton.Width             = 90
$CancelButton.Height            = 30
$CancelButton.Location          = New-Object System.Drawing.Point(450,400)
$CancelButton.Font              = 'Microsoft Sans Serif,10'
$CancelButton.ForeColor         = "#000"
$CancelButton.DialogResult      = [System.Windows.Forms.DialogResult]::Cancel
$InstallForm.CancelButton       = $CancelButton
$InstallForm.Controls.Add($CancelButton)

$InstallForm.controls.AddRange(@($Title,
$Description,
$UsernameLabel,
$TokenLabel,
$UsernameTextBox,
$TokenTextBox,
# TODO
# $EmailLabel,
# $PasswordLabel,
# $EmailTextBox,
# $PasswordTextBox,
$LoginButton,
$NextButton,
$CancelButton,
$DoneButton,
$EndButton,
$AcceptButton,
$DeclineButton,
$RestartButton,
$LogoutButton,
$YesButton,
$NoButton))

#---------------------------------------------------------[Functions]--------------------------------------------------------


function Show-Buttons ([string[]]$ButtonsName) {  
  <#
  .SYNOPSIS
  Show the Buttons requested on the GUI

  .DESCRIPTION
  Turns Invisible every Button present on the GUI and then turns Visible only the requested Buttons
  #>
  $CancelButton.Visible = $false
  $NextButton.Visible = $false
  $DeclineButton.Visible = $false
  $AcceptButton.Visible = $false
  $DoneButton.Visible = $false
  $EndButton.Visible = $false
  $LoginButton.Visible = $false
  $LogoutButton.Visible = $false
  $RestartButton.Visible = $false
  $YesButton.Visible = $false
  $NoButton.Visible = $false
  
  foreach ($ButtonName in $ButtonsName) {
    Invoke-Expression "$ButtonName.Visible = `$true"
  }
}

function Show-LoginNpmScreen {
  <#
  .SYNOPSIS
  Show the Npm Login Screen

  .DESCRIPTION
  Shows the Npm Login Screen
  #>
  $Description.Height = 70
  $UsernameLabel.Visible = $true
  $UsernameTextBox.Visible = $true
  $TokenLabel.Visible = $true
  $TokenTextBox.Visible = $true
  $EmailLabel.Visible = $true
  $EmailTextBox.Visible = $true
  $PasswordLabel.Visible = $true
  $PasswordTextBox.Visible = $true
  $LoginButton.Visible = $true
  $NextButton.Visible = $false
  $CancelButton.Visible = $false
}

function Hide-LoginNpmScreen {
  <#
  .SYNOPSIS
  Hide the Npm Login Screen

  .DESCRIPTION
  hides the Npm Login Screen
  #>
  $Description.Text = ""
  $Description.Height = 150
  $UsernameLabel.Visible = $false
  $UsernameTextBox.Visible = $false
  $TokenLabel.Visible = $false
  $TokenTextBox.Visible = $false
  $EmailLabel.Visible = $false
  $EmailTextBox.Visible = $false
  $PasswordLabel.Visible = $false
  $PasswordTextBox.Visible = $false
  $LoginButton.Visible = $false
  $NextButton.Visible = $false
  $CancelButton.Visible = $false
}

function Show-ButtonsPostAction ($RequirementPostAction) {
  <#
  .SYNOPSIS
  Show a specific Button based on the Post Action of the Requirement

  .DESCRIPTION
  Shows a specific Button based on the Post Action of the Requirement
  #>
  switch ($RequirementPostAction) {
    "End" {
      Show-Buttons @('$EndButton')
    }
    "Login" {
      Show-Buttons @('$LoginButton')
    }
    "Logout" {
      Show-Buttons @('$LogoutButton')
    }
    "Restart" {
      Show-Buttons @('$RestartButton')
    }
    Default {  }
  }
}

# ScriptPath will contain the Script's path, once done that it will take only the path's parent and set the current Location to that path
$ScriptPath = $MyInvocation.MyCommand.Path
$ScriptPathParent = Split-Path -Parent $ScriptPath
Set-Location $ScriptPathParent

# Unlocks all the scripts needed for the installation
Unblock-File -Path .\caep-main.ps1
Unblock-File -Path .\clean-jfrog.ps1
Unblock-File -Path .\requirement-actions.ps1
Unblock-File -Path .\requirements.json
Unblock-File -Path .\send-logs.ps1

. .\caep-main.ps1 -ScarVersion $ScarVersion -ScarConfig $ScarConfig

$NextButton.Add_Click({ Step-NextAction })
$AcceptButton.Add_Click({ Invoke-AcceptRequirement })
$LoginButton.Add_Click({ Invoke-LoginNpm })
$DoneButton.Add_Click({ $InstallForm.Close() })
$EndButton.Add_Click({ Close-Installer })
$DeclineButton.Add_Click({ Invoke-DeclineRequirement })
$RestartButton.Add_Click({ Restart-Computer })
$LogoutButton.Add_Click({ logoff.exe })
$YesButton.Add_Click({ OutFileAnswerNestedVirtualization $true })
$NoButton.Add_Click({ OutFileAnswerNestedVirtualization $false })
# Shows the GUI
[void]$InstallForm.ShowDialog()

# SIG # Begin signature block
# MIIk2wYJKoZIhvcNAQcCoIIkzDCCJMgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUyPTIoiP0jC8JVKLTEBia9FHY
# 9m2ggh62MIIFOTCCBCGgAwIBAgIQDue4N8WIaRr2ZZle0AzJjDANBgkqhkiG9w0B
# AQsFADB8MQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
# MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxJDAi
# BgNVBAMTG1NlY3RpZ28gUlNBIENvZGUgU2lnbmluZyBDQTAeFw0yMTAxMjUwMDAw
# MDBaFw0yNDAxMjUyMzU5NTlaMIGgMQswCQYDVQQGEwJJVDEOMAwGA1UEEQwFNzAw
# MjkxDTALBgNVBAgMBEJhcmkxGzAZBgNVBAcMElNhbnRlcmFtbyBpbiBDb2xsZTEZ
# MBcGA1UECQwQVmlhIENhbXBhbmlhLDEvMzEcMBoGA1UECgwTQ29kZSBBcmNoaXRl
# Y3RzIFNybDEcMBoGA1UEAwwTQ29kZSBBcmNoaXRlY3RzIFNybDCCASIwDQYJKoZI
# hvcNAQEBBQADggEPADCCAQoCggEBALaj4vlKflM4B+dR8Cz8Z7RA4CUe2iR2WGp9
# /qTN2Eg+7RG74V7gBsOqyllqNdmUecwqwbiRbPB4+s83rYxwRZf1s/cEmtcKWUpu
# g4Kde2XKIMz8IigS5P+4qFStWeY5VkybU1CDWyHpj4iUiYyy3D6BbLxIhwTyjVDz
# 6h/VIlAqDt6tNSIkACdp0CRPDe1/I3HLVLVRqSbek473Enbijb4H3oSrsnCqF7Xx
# +UBa7zUNo5fZNBRJb4IfRq17uKQ8oNz+2KcIB74hsXm1X2v8Igm6upua/Td8kZ0b
# CuuogqPoUbEKXTNMd5D32JUAi7KpgKWE4CCbG7zk7ivGpAii6OUCAwEAAaOCAZAw
# ggGMMB8GA1UdIwQYMBaAFA7hOqhTOjHVir7Bu61nGgOFrTQOMB0GA1UdDgQWBBTz
# X2/Q/EHWaGVPiGGw0uJSmluXeDAOBgNVHQ8BAf8EBAMCB4AwDAYDVR0TAQH/BAIw
# ADATBgNVHSUEDDAKBggrBgEFBQcDAzARBglghkgBhvhCAQEEBAMCBBAwSgYDVR0g
# BEMwQTA1BgwrBgEEAbIxAQIBAwIwJTAjBggrBgEFBQcCARYXaHR0cHM6Ly9zZWN0
# aWdvLmNvbS9DUFMwCAYGZ4EMAQQBMEMGA1UdHwQ8MDowOKA2oDSGMmh0dHA6Ly9j
# cmwuc2VjdGlnby5jb20vU2VjdGlnb1JTQUNvZGVTaWduaW5nQ0EuY3JsMHMGCCsG
# AQUFBwEBBGcwZTA+BggrBgEFBQcwAoYyaHR0cDovL2NydC5zZWN0aWdvLmNvbS9T
# ZWN0aWdvUlNBQ29kZVNpZ25pbmdDQS5jcnQwIwYIKwYBBQUHMAGGF2h0dHA6Ly9v
# Y3NwLnNlY3RpZ28uY29tMA0GCSqGSIb3DQEBCwUAA4IBAQBlnIYjhWZ4sTIbd/yg
# CjBcY2IKtXvL5Nts38z5c/7NtoJrP5C7MyjdVfgP5hTcXGVsKbZu1FwI+qlmcKcl
# YO9fiNP8qOIxDKrlETyduXknx70mjok/ZrrbrPYiCIRf3imGWb0dU6U1iDsphhng
# My2352B8K4RICeHd/pLY8PGyM276RIVRL9qv/welyakOoqs9n8JPz4SkQKZ1LELb
# rHtxU9gSC6M/Sz3T0wLCF+qZw388HgpT0iv1PCWr3LFuzY1FxD9hOaGrVQKu1GeM
# VBqF3Ac+jRy308kqZlzwvR5s6mYFyEvxS9CoUNBERBEFgULSkGH5O7SVjUcbiK8w
# BlToMIIFgTCCBGmgAwIBAgIQOXJEOvkit1HX02wQ3TE1lTANBgkqhkiG9w0BAQwF
# ADB7MQswCQYDVQQGEwJHQjEbMBkGA1UECAwSR3JlYXRlciBNYW5jaGVzdGVyMRAw
# DgYDVQQHDAdTYWxmb3JkMRowGAYDVQQKDBFDb21vZG8gQ0EgTGltaXRlZDEhMB8G
# A1UEAwwYQUFBIENlcnRpZmljYXRlIFNlcnZpY2VzMB4XDTE5MDMxMjAwMDAwMFoX
# DTI4MTIzMTIzNTk1OVowgYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpOZXcgSmVy
# c2V5MRQwEgYDVQQHEwtKZXJzZXkgQ2l0eTEeMBwGA1UEChMVVGhlIFVTRVJUUlVT
# VCBOZXR3b3JrMS4wLAYDVQQDEyVVU0VSVHJ1c3QgUlNBIENlcnRpZmljYXRpb24g
# QXV0aG9yaXR5MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAgBJlFzYO
# w9sIs9CsVw127c0n00ytUINh4qogTQktZAnczomfzD2p7PbPwdzx07HWezcoEStH
# 2jnGvDoZtF+mvX2do2NCtnbyqTsrkfjib9DsFiCQCT7i6HTJGLSR1GJk23+jBvGI
# GGqQIjy8/hPwhxR79uQfjtTkUcYRZ0YIUcuGFFQ/vDP+fmyc/xadGL1RjjWmp2bI
# cmfbIWax1Jt4A8BQOujM8Ny8nkz+rwWWNR9XWrf/zvk9tyy29lTdyOcSOk2uTIq3
# XJq0tyA9yn8iNK5+O2hmAUTnAU5GU5szYPeUvlM3kHND8zLDU+/bqv50TmnHa4xg
# k97Exwzf4TKuzJM7UXiVZ4vuPVb+DNBpDxsP8yUmazNt925H+nND5X4OpWaxKXwy
# hGNVicQNwZNUMBkTrNN9N6frXTpsNVzbQdcS2qlJC9/YgIoJk2KOtWbPJYjNhLix
# P6Q5D9kCnusSTJV882sFqV4Wg8y4Z+LoE53MW4LTTLPtW//e5XOsIzstAL81VXQJ
# SdhJWBp/kjbmUZIO8yZ9HE0XvMnsQybQv0FfQKlERPSZ51eHnlAfV1SoPv10Yy+x
# UGUJ5lhCLkMaTLTwJUdZ+gQek9QmRkpQgbLevni3/GcV4clXhB4PY9bpYrrWX1Uu
# 6lzGKAgEJTm4Diup8kyXHAc/DVL17e8vgg8CAwEAAaOB8jCB7zAfBgNVHSMEGDAW
# gBSgEQojPpbxB+zirynvgqV/0DCktDAdBgNVHQ4EFgQUU3m/WqorSs9UgOHYm8Cd
# 8rIDZsswDgYDVR0PAQH/BAQDAgGGMA8GA1UdEwEB/wQFMAMBAf8wEQYDVR0gBAow
# CDAGBgRVHSAAMEMGA1UdHwQ8MDowOKA2oDSGMmh0dHA6Ly9jcmwuY29tb2RvY2Eu
# Y29tL0FBQUNlcnRpZmljYXRlU2VydmljZXMuY3JsMDQGCCsGAQUFBwEBBCgwJjAk
# BggrBgEFBQcwAYYYaHR0cDovL29jc3AuY29tb2RvY2EuY29tMA0GCSqGSIb3DQEB
# DAUAA4IBAQAYh1HcdCE9nIrgJ7cz0C7M7PDmy14R3iJvm3WOnnL+5Nb+qh+cli3v
# A0p+rvSNb3I8QzvAP+u431yqqcau8vzY7qN7Q/aGNnwU4M309z/+3ri0ivCRlv79
# Q2R+/czSAaF9ffgZGclCKxO/WIu6pKJmBHaIkU4MiRTOok3JMrO66BQavHHxW/BB
# C5gACiIDEOUMsfnNkjcZ7Tvx5Dq2+UUTJnWvu6rvP3t3O9LEApE9GQDTF1w52z97
# GA1FzZOFli9d31kWTz9RvdVFGD/tSo7oBmF0Ixa1DVBzJ0RHfxBdiSprhTEUxOip
# akyAvGp4z7h/jnZymQyd/teRCBaho1+VMIIF9TCCA92gAwIBAgIQHaJIMG+bJhjQ
# guCWfTPTajANBgkqhkiG9w0BAQwFADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgT
# Ck5ldyBKZXJzZXkxFDASBgNVBAcTC0plcnNleSBDaXR5MR4wHAYDVQQKExVUaGUg
# VVNFUlRSVVNUIE5ldHdvcmsxLjAsBgNVBAMTJVVTRVJUcnVzdCBSU0EgQ2VydGlm
# aWNhdGlvbiBBdXRob3JpdHkwHhcNMTgxMTAyMDAwMDAwWhcNMzAxMjMxMjM1OTU5
# WjB8MQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAw
# DgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxJDAiBgNV
# BAMTG1NlY3RpZ28gUlNBIENvZGUgU2lnbmluZyBDQTCCASIwDQYJKoZIhvcNAQEB
# BQADggEPADCCAQoCggEBAIYijTKFehifSfCWL2MIHi3cfJ8Uz+MmtiVmKUCGVEZ0
# MWLFEO2yhyemmcuVMMBW9aR1xqkOUGKlUZEQauBLYq798PgYrKf/7i4zIPoMGYmo
# bHutAMNhodxpZW0fbieW15dRhqb0J+V8aouVHltg1X7XFpKcAC9o95ftanK+ODtj
# 3o+/bkxBXRIgCFnoOc2P0tbPBrRXBbZOoT5Xax+YvMRi1hsLjcdmG0qfnYHEckC1
# 4l/vC0X/o84Xpi1VsLewvFRqnbyNVlPG8Lp5UEks9wO5/i9lNfIi6iwHr0bZ+UYc
# 3Ix8cSjz/qfGFN1VkW6KEQ3fBiSVfQ+noXw62oY1YdMCAwEAAaOCAWQwggFgMB8G
# A1UdIwQYMBaAFFN5v1qqK0rPVIDh2JvAnfKyA2bLMB0GA1UdDgQWBBQO4TqoUzox
# 1Yq+wbutZxoDha00DjAOBgNVHQ8BAf8EBAMCAYYwEgYDVR0TAQH/BAgwBgEB/wIB
# ADAdBgNVHSUEFjAUBggrBgEFBQcDAwYIKwYBBQUHAwgwEQYDVR0gBAowCDAGBgRV
# HSAAMFAGA1UdHwRJMEcwRaBDoEGGP2h0dHA6Ly9jcmwudXNlcnRydXN0LmNvbS9V
# U0VSVHJ1c3RSU0FDZXJ0aWZpY2F0aW9uQXV0aG9yaXR5LmNybDB2BggrBgEFBQcB
# AQRqMGgwPwYIKwYBBQUHMAKGM2h0dHA6Ly9jcnQudXNlcnRydXN0LmNvbS9VU0VS
# VHJ1c3RSU0FBZGRUcnVzdENBLmNydDAlBggrBgEFBQcwAYYZaHR0cDovL29jc3Au
# dXNlcnRydXN0LmNvbTANBgkqhkiG9w0BAQwFAAOCAgEATWNQ7Uc0SmGk295qKoyb
# 8QAAHh1iezrXMsL2s+Bjs/thAIiaG20QBwRPvrjqiXgi6w9G7PNGXkBGiRL0C3da
# nCpBOvzW9Ovn9xWVM8Ohgyi33i/klPeFM4MtSkBIv5rCT0qxjyT0s4E307dksKYj
# alloUkJf/wTr4XRleQj1qZPea3FAmZa6ePG5yOLDCBaxq2NayBWAbXReSnV+pbjD
# bLXP30p5h1zHQE1jNfYw08+1Cg4LBH+gS667o6XQhACTPlNdNKUANWlsvp8gJRAN
# GftQkGG+OY96jk32nw4e/gdREmaDJhlIlc5KycF/8zoFm/lv34h/wCOe0h5DekUx
# wZxNqfBZslkZ6GqNKQQCd3xLS81wvjqyVVp4Pry7bwMQJXcVNIr5NsxDkuS6T/Fi
# kyglVyn7URnHoSVAaoRXxrKdsbwcCtp8Z359LukoTBh+xHsxQXGaSynsCz1XUNLK
# 3f2eBVHlRHjdAd6xdZgNVCT98E7j4viDvXK6yz067vBeF5Jobchh+abxKgoLpbn0
# nu6YMgWFnuv5gynTxix9vTp3Los3QqBqgu07SqqUEKThDfgXxbZaeTMYkuO1dfih
# 6Y4KJR7kHvGfWocj/5+kUZ77OYARzdu1xKeogG/lU9Tg46LC0lsa+jImLWpXcBw8
# pFguo/NbSwfcMlnzh6cabVgwggbsMIIE1KADAgECAhAwD2+s3WaYdHypRjaneC25
# MA0GCSqGSIb3DQEBDAUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMKTmV3IEpl
# cnNleTEUMBIGA1UEBxMLSmVyc2V5IENpdHkxHjAcBgNVBAoTFVRoZSBVU0VSVFJV
# U1QgTmV0d29yazEuMCwGA1UEAxMlVVNFUlRydXN0IFJTQSBDZXJ0aWZpY2F0aW9u
# IEF1dGhvcml0eTAeFw0xOTA1MDIwMDAwMDBaFw0zODAxMTgyMzU5NTlaMH0xCzAJ
# BgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcT
# B1NhbGZvcmQxGDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDElMCMGA1UEAxMcU2Vj
# dGlnbyBSU0EgVGltZSBTdGFtcGluZyBDQTCCAiIwDQYJKoZIhvcNAQEBBQADggIP
# ADCCAgoCggIBAMgbAa/ZLH6ImX0BmD8gkL2cgCFUk7nPoD5T77NawHbWGgSlzkeD
# tevEzEk0y/NFZbn5p2QWJgn71TJSeS7JY8ITm7aGPwEFkmZvIavVcRB5h/RGKs3E
# Wsnb111JTXJWD9zJ41OYOioe/M5YSdO/8zm7uaQjQqzQFcN/nqJc1zjxFrJw06PE
# 37PFcqwuCnf8DZRSt/wflXMkPQEovA8NT7ORAY5unSd1VdEXOzQhe5cBlK9/gM/R
# EQpXhMl/VuC9RpyCvpSdv7QgsGB+uE31DT/b0OqFjIpWcdEtlEzIjDzTFKKcvSb/
# 01Mgx2Bpm1gKVPQF5/0xrPnIhRfHuCkZpCkvRuPd25Ffnz82Pg4wZytGtzWvlr7a
# TGDMqLufDRTUGMQwmHSCIc9iVrUhcxIe/arKCFiHd6QV6xlV/9A5VC0m7kUaOm/N
# 14Tw1/AoxU9kgwLU++Le8bwCKPRt2ieKBtKWh97oaw7wW33pdmmTIBxKlyx3GSuT
# lZicl57rjsF4VsZEJd8GEpoGLZ8DXv2DolNnyrH6jaFkyYiSWcuoRsDJ8qb/fVfb
# Enb6ikEk1Bv8cqUUotStQxykSYtBORQDHin6G6UirqXDTYLQjdprt9v3GEBXc/Bx
# o/tKfUU2wfeNgvq5yQ1TgH36tjlYMu9vGFCJ10+dM70atZ2h3pVBeqeDAgMBAAGj
# ggFaMIIBVjAfBgNVHSMEGDAWgBRTeb9aqitKz1SA4dibwJ3ysgNmyzAdBgNVHQ4E
# FgQUGqH4YRkgD8NBd0UojtE1XwYSBFUwDgYDVR0PAQH/BAQDAgGGMBIGA1UdEwEB
# /wQIMAYBAf8CAQAwEwYDVR0lBAwwCgYIKwYBBQUHAwgwEQYDVR0gBAowCDAGBgRV
# HSAAMFAGA1UdHwRJMEcwRaBDoEGGP2h0dHA6Ly9jcmwudXNlcnRydXN0LmNvbS9V
# U0VSVHJ1c3RSU0FDZXJ0aWZpY2F0aW9uQXV0aG9yaXR5LmNybDB2BggrBgEFBQcB
# AQRqMGgwPwYIKwYBBQUHMAKGM2h0dHA6Ly9jcnQudXNlcnRydXN0LmNvbS9VU0VS
# VHJ1c3RSU0FBZGRUcnVzdENBLmNydDAlBggrBgEFBQcwAYYZaHR0cDovL29jc3Au
# dXNlcnRydXN0LmNvbTANBgkqhkiG9w0BAQwFAAOCAgEAbVSBpTNdFuG1U4GRdd8D
# ejILLSWEEbKw2yp9KgX1vDsn9FqguUlZkClsYcu1UNviffmfAO9Aw63T4uRW+VhB
# z/FC5RB9/7B0H4/GXAn5M17qoBwmWFzztBEP1dXD4rzVWHi/SHbhRGdtj7BDEA+N
# 5Pk4Yr8TAcWFo0zFzLJTMJWk1vSWVgi4zVx/AZa+clJqO0I3fBZ4OZOTlJux3LJt
# QW1nzclvkD1/RXLBGyPWwlWEZuSzxWYG9vPWS16toytCiiGS/qhvWiVwYoFzY16g
# u9jc10rTPa+DBjgSHSSHLeT8AtY+dwS8BDa153fLnC6NIxi5o8JHHfBd1qFzVwVo
# mqfJN2Udvuq82EKDQwWli6YJ/9GhlKZOqj0J9QVst9JkWtgqIsJLnfE5XkzeSD2b
# NJaaCV+O/fexUpHOP4n2HKG1qXUfcb9bQ11lPVCBbqvw0NP8srMftpmWJvQ8eYtc
# ZMzN7iea5aDADHKHwW5NWtMe6vBE5jJvHOsXTpTDeGUgOw9Bqh/poUGd/rG4oGUq
# NODeqPk85sEwu8CgYyz8XBYAqNDEf+oRnR4GxqZtMl20OAkrSQeq/eww2vGnL8+3
# /frQo4TZJ577AWZ3uVYQ4SBuxq6x+ba6yDVdM3aO8XwgDCp3rrWiAoa6Ke60WgCx
# jKvj+QrJVF3UuWp0nr1IrpgwggcHMIIE76ADAgECAhEAjHegAI/00bDGPZ86SION
# azANBgkqhkiG9w0BAQwFADB9MQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRl
# ciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdv
# IExpbWl0ZWQxJTAjBgNVBAMTHFNlY3RpZ28gUlNBIFRpbWUgU3RhbXBpbmcgQ0Ew
# HhcNMjAxMDIzMDAwMDAwWhcNMzIwMTIyMjM1OTU5WjCBhDELMAkGA1UEBhMCR0Ix
# GzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEY
# MBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMSwwKgYDVQQDDCNTZWN0aWdvIFJTQSBU
# aW1lIFN0YW1waW5nIFNpZ25lciAjMjCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCC
# AgoCggIBAJGHSyyLwfEeoJ7TB8YBylKwvnl5XQlmBi0vNX27wPsn2kJqWRslTOrv
# QNaafjLIaoF9tFw+VhCBNToiNoz7+CAph6x00BtivD9khwJf78WA7wYc3F5Ok4e4
# mt5MB06FzHDFDXvsw9njl+nLGdtWRWzuSyBsyT5s/fCb8Sj4kZmq/FrBmoIgOrfv
# 59a4JUnCORuHgTnLw7c6zZ9QBB8amaSAAk0dBahV021SgIPmbkilX8GJWGCK7/Gs
# zYdjGI50y4SHQWljgbz2H6p818FBzq2rdosggNQtlQeNx/ULFx6a5daZaVHHTqad
# KW/neZMNMmNTrszGKYogwWDG8gIsxPnIIt/5J4Khg1HCvMmCGiGEspe81K9EHJaC
# IpUqhVSu8f0+SXR0/I6uP6Vy9MNaAapQpYt2lRtm6+/a35Qu2RrrTCd9TAX3+CNd
# xFfIJgV6/IEjX1QJOCpi1arK3+3PU6sf9kSc1ZlZxVZkW/eOUg9m/Jg/RAYTZG7p
# 4RVgUKWx7M+46MkLvsWE990Kndq8KWw9Vu2/eGe2W8heFBy5r4Qtd6L3OZU3b05/
# HMY8BNYxxX7vPehRfnGtJHQbLNz5fKrvwnZJaGLVi/UD3759jg82dUZbk3bEg+6C
# viyuNxLxvFbD5K1Dw7dmll6UMvqg9quJUPrOoPMIgRrRRKfM97gxAgMBAAGjggF4
# MIIBdDAfBgNVHSMEGDAWgBQaofhhGSAPw0F3RSiO0TVfBhIEVTAdBgNVHQ4EFgQU
# aXU3e7udNUJOv1fTmtufAdGu3tAwDgYDVR0PAQH/BAQDAgbAMAwGA1UdEwEB/wQC
# MAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwQAYDVR0gBDkwNzA1BgwrBgEEAbIx
# AQIBAwgwJTAjBggrBgEFBQcCARYXaHR0cHM6Ly9zZWN0aWdvLmNvbS9DUFMwRAYD
# VR0fBD0wOzA5oDegNYYzaHR0cDovL2NybC5zZWN0aWdvLmNvbS9TZWN0aWdvUlNB
# VGltZVN0YW1waW5nQ0EuY3JsMHQGCCsGAQUFBwEBBGgwZjA/BggrBgEFBQcwAoYz
# aHR0cDovL2NydC5zZWN0aWdvLmNvbS9TZWN0aWdvUlNBVGltZVN0YW1waW5nQ0Eu
# Y3J0MCMGCCsGAQUFBzABhhdodHRwOi8vb2NzcC5zZWN0aWdvLmNvbTANBgkqhkiG
# 9w0BAQwFAAOCAgEASgN4kEIz7Hsagwk2M5hVu51ABjBrRWrxlA4ZUP9bJV474TnE
# W7rplZA3N73f+2Ts5YK3lcxXVXBLTvSoh90ihaZXu7ghJ9SgKjGUigchnoq9pxr1
# AhXLRFCZjOw+ugN3poICkMIuk6m+ITR1Y7ngLQ/PATfLjaL6uFqarqF6nhOTGVWP
# CZAu3+qIFxbradbhJb1FCJeA11QgKE/Ke7OzpdIAsGA0ZcTjxcOl5LqFqnpp23Wk
# PnlomjaLQ6421GFyPA6FYg2gXnDbZC8Bx8GhxySUo7I8brJeotD6qNG4JRwW5sDV
# f2gaxGUpNSotiLzqrnTWgufAiLjhT3jwXMrAQFzCn9UyHCzaPKw29wZSmqNAMBew
# KRaZyaq3iEn36AslM7U/ba+fXwpW3xKxw+7OkXfoIBPpXCTH6kQLSuYThBxN6w21
# uIagMKeLoZ+0LMzAFiPJkeVCA0uAzuRN5ioBPsBehaAkoRdA1dvb55gQpPHqGRuA
# VPpHieiYgal1wA7f0GiUeaGgno62t0Jmy9nZay9N2N4+Mh4g5OycTUKNncczmYI3
# RNQmKSZAjngvue76L/Hxj/5QuHjdFJbeHA5wsCqFarFsaOkq5BArbiH903ydN+Qq
# BtbD8ddo408HeYEIE/6yZF7psTzm0Hgjsgks4iZivzupl1HMx0QygbKvz98xggWP
# MIIFiwIBATCBkDB8MQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5j
# aGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0
# ZWQxJDAiBgNVBAMTG1NlY3RpZ28gUlNBIENvZGUgU2lnbmluZyBDQQIQDue4N8WI
# aRr2ZZle0AzJjDAJBgUrDgMCGgUAoIGEMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3
# AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEW
# BBR788QJRpW6x/plZrJewZsmzzCMxTAkBgorBgEEAYI3AgEMMRYwFKASgBAAQwBB
# ACAAVABvAG8AbABzMA0GCSqGSIb3DQEBAQUABIIBAEb9nYrs1P9Vpz/p6W8ZyvF+
# mIXtuBMDCOeMA4MDolY330yKhxi7SeCxLdRgS2u47CoIBjR1ZhmnbsXXlowyQA+F
# pex0iHEUIn+mfYpAI1svdnSXRuq/w+OprXMJQOl4MMfB59OzprGMwVpi+40tur2a
# rXq3FYme2UTzUjW4eMGRWJgtR/fPCtGNeLQRB0LoEbmrj49p8Nj/HAGDFs3qiTKd
# h8ToLpmrVXj0crVdv0bQF0CoCib6fMVy1SuKEyQhgq+H5Mavxy0bRd0qCCdHci7m
# +sY4ZV/mpAG6BWyd05jz2N46IJ7RWsMOX4wtv6zdrON0GUhXyBy/Et728vZt/MCh
# ggNMMIIDSAYJKoZIhvcNAQkGMYIDOTCCAzUCAQEwgZIwfTELMAkGA1UEBhMCR0Ix
# GzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEY
# MBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMSUwIwYDVQQDExxTZWN0aWdvIFJTQSBU
# aW1lIFN0YW1waW5nIENBAhEAjHegAI/00bDGPZ86SIONazANBglghkgBZQMEAgIF
# AKB5MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIy
# MDUwNjE0MzI1NlowPwYJKoZIhvcNAQkEMTIEMEyG1BVHnc2hroHZcbWEO3jHPO1w
# QOer/EFw7g9k2ncOD3jMaPXg3QkSE0v+VY4YOjANBgkqhkiG9w0BAQEFAASCAgCM
# gQgv6OSxKGh8di6Gev8gatfeEnZZs3IKeXOMkUDXw0x0DEV3F24AoAjSeGtLZfI5
# ar/kqKgsboaulfpfu6UVmFZ/zt79uGlDTIM4sDFeOiKHUZY5bwhkPWguXyu0mMsd
# ON7kNuSL/4jWQMo7d6GcFiwLK4kspFBxAigqiGPCEEhcT2PErmPRhQSjz5L7gg67
# Jo+t6LyAXewyfJTAUNj5xUWx3ACeUSydkC0EI69Kk8dIsd9FxIiuEKJC6joUcmYx
# l0GmmMFqDczdkAzBjjNMFJlINWWGlc9OXD186vArw8TL6OoaAuDbmPMPxklLbkcH
# ygVh2j3oioJTM+ufpWl9NuogAfwuB55vPj35eAhkKZlyAGZ+R4mwq6/vPMMPIWfP
# O19+KSmZhY3coesnF2tERHMy/6vGJ6DnwaUVhGTVb0anvb64izM6qBigDbbroIOx
# aNGmpgz8LFSx1/ZohDgy8w2xCRgv82EADXRTzbWq3RyYEJXzzwIMTsq20XsSPno2
# O0Ftn8SlozGbe2ekXoorLes/ATsCI2I4uBCev/T4WJoaAJ4xXQ750Qu0fg7sSKFb
# Cl8DaOr7MLCpA6kS2m2saghKflJ8I1uq7rYH9R3I6RPyhwbcj64acxTMHHtqiAvn
# BYJTAQ6aBmPkH+39T+jvyonmSZZUUbdaIJVbvIY4aw==
# SIG # End signature block
