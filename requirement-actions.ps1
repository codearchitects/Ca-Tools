param(
  [string]$RandomCode = "",
  [string]$CurrentDate = "",
  [string]$ScarVersion = "",
  [string]$ScarConfig = ""
)

$Logfile
$OutLogfile
$ErrLogfile
# Contiene l'estensione da installare in VS Code. Da utilizzare nel metodo New-CommandString. Deve essere globale altrimenti sarà utilizzabile soltanto nella funzione 
# Invoke-PostInstallAction e non nella funzione New-CommandString
$item

function Invoke-ActivityAction {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0, Mandatory = $true)]
    $Requirement
  )

  $ResultActivity = Invoke-Expression (New-CommandString $Requirement.CheckRequirement)
  if ($ResultActivity[0]) {
    switch ($ResultActivity[1]) {
      'OK' {
        Invoke-Expression (New-CommandString $Requirement.ActivityOKCommand)
      }
      'KO' {
        Invoke-Expression (New-CommandString $Requirement.ActivityKOCommand)
      }
    }
    Show-Buttons @('$NextButton', '$CancelButton')
  } else {
    Show-Buttons @('$DoneButton')
  }
}

function Invoke-ConnectionAction {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0, Mandatory = $true)]
    $Requirement
  )

  $ResultConnection = Invoke-Expression (New-CommandString $Requirement.CheckRequirement)
  $MessageConnection = ""
  if ($ResultConnection[0]) {
    switch ($ResultConnection[1]) {
      "OK" {
        $MessageConnection = (New-CommandString $Requirement.OkMessage)
        $Description.SelectionStart = $Description.TextLength
        $Description.SelectionLength = 0
        $Description.SelectionColor = "Green"
        $Description.AppendText($MessageConnection)
        $Description.AppendText([Environment]::NewLine)
      }
    }
    Show-Buttons @('$NextButton', '$CancelButton')
  } else {
    switch ($ResultConnection[1]) {
      "KO" {
        $MessageConnection = (New-CommandString $Requirement.KoMessage)
        $Description.SelectionStart = $Description.TextLength
        $Description.SelectionLength = 0
        $Description.SelectionColor = "Red"
        $Description.AppendText($MessageConnection)
        $Description.AppendText([Environment]::NewLine)
      }
      "TCP" {
        $MessageConnection = (New-CommandString $Requirement.TcpMessage)
        $Description.SelectionStart = $Description.TextLength
        $Description.SelectionLength = 0
        $Description.SelectionColor = "Red"
        $Description.AppendText($MessageConnection)
        $Description.AppendText([Environment]::NewLine)
      }
    }
    Show-Buttons @('$DoneButton')
  }
}

function Invoke-DownloadInstallRequirementAction {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0, Mandatory = $true)]
    $Requirement
  )

  $CheckingMessage = "Checking if $($Requirement.Name) $($Requirement.ExtraMessage) version: $($Requirement.MaxVersion) is already installed..."
  $AlreadyInstalledMessage = "$($Requirement.Name) $($Requirement.ExtraMessage) version: $($Requirement.MaxVersion) is already installed"
  $DownloadingMessage = "Downloading $($Requirement.Name) $($Requirement.ExtraMessage) version: $($Requirement.MaxVersion)..."
  $DownloadCompleteMessage = "Download of $($Requirement.Name) $($Requirement.ExtraMessage) version: $($Requirement.MaxVersion) complete."
  $InstallingMessage = "Installing $($Requirement.Name) $($Requirement.ExtraMessage) version: $($Requirement.MaxVersion)..."
  $InstallCompleteMessage = "Install of $($Requirement.Name) $($Requirement.ExtraMessage) version: $($Requirement.MaxVersion) complete."
  $DeletingMessage = "Deleting the file $(New-CommandString $Requirement.DownloadOutfile)..."
  $DeleteCompleteMessage = "Delete of the file $(New-CommandString $Requirement.DownloadOutfile) complete."

  if ($Requirement.CheckRequirement) {
    $Description.AppendText("`r`n$CheckingMessage")
    $IsInstalled = Invoke-Expression (New-CommandString $Requirement.CheckRequirement)
  }

  if (($IsInstalled[1] -ne 'OK') -or ($Requirement.PostAction -eq "Reinstall")) {

    #TODO if VER then Disinstall wrong version

    if ($Requirement.DownloadCommand) {
      $Description.AppendText("`r`n$DownloadingMessage")
      Invoke-Expression (New-CommandString $Requirement.DownloadCommand)
      $Description.AppendText("`r`n$DownloadCompleteMessage")
    }
    if ($Requirement.InstallCommand) {
      $Description.AppendText("`r`n$InstallingMessage")
      Invoke-Expression (New-CommandString $Requirement.InstallCommand)
      $Description.AppendText("`r`n$InstallCompleteMessage")
    }
    if ($Requirement.DeleteCommand) {
      $Description.AppendText("`r`n$DeletingMessage")
      Invoke-Expression (New-CommandString $Requirement.DeleteCommand)
      $Description.AppendText("`r`n$DeleteCompleteMessage")
    }
    Get-Content $OutLogfile, $ErrLogfile | Add-Content $Logfile
  } else {
    $Description.AppendText("`r`n$AlreadyInstalledMessage")
  }
  Show-Buttons @('$NextButton', '$CancelButton')
}

function Invoke-EnableFeatureAction {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0, Mandatory = $true)]
    $Requirement
  )

  $EnablingMessage = "Enabling feature $($Requirement.Name)..."
  # $EnableCancelMessage = "Enable the feature $($Requirement.Name) manually to proceed with the installation from `"Turn Windows features on or off`"."
  $EnableCompleteMessage = "The feature $($Requirement.Name) was enabled successfully."
  $AlreadyEnabledMessage = "The feature $($Requirement.Name) was already enabled."

  if ($Requirement.CheckRequirement) {
    $EnabledResult = Invoke-Expression (New-CommandString $Requirement.CheckRequirement)
    if ($EnabledResult[1] -eq 'KO') {
      $Description.AppendText("`r`n$EnablingMessage")
      Invoke-Expression (New-CommandString $Requirement.EnableCommand)
      $Description.AppendText("`r`n$EnableCompleteMessage")
    } else {
      $Description.AppendText("`r`n$AlreadyEnabledMessage")
    }
  }
  Show-Buttons @('$NextButton', '$CancelButton')
}

function Invoke-EnvironmentVariableAction {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0, Mandatory = $true)]
    $Requirement
  )

  foreach ($item in $Requirement.Values) {
    $EnvVarResult = Invoke-Expression (New-CommandString $Requirement.CheckRequirement)
    if ($EnvVarResult[1] -eq 'KO') {
      $Description.AppendText("Setting Environement Variable: $item")
      Invoke-Expression (New-CommandString $Requirement.AddCommand)
    }
  }
  Show-Buttons @('$NextButton', '$CancelButton')
}

function Invoke-PermissionAction {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0, Mandatory = $true)]
    $Requirement
  )
  $MessagePermission = ""
  $ResultPermission = Invoke-Expression (New-CommandString $Requirement.CheckRequirement)
  if ($ResultPermission[0] -eq $true) {
    if ($ResultPermission[1] -eq 'OK') {
      $MessagePermission = (New-CommandString $Requirement.OkMessage)
      $Description.SelectionStart = $Description.TextLength
      $Description.SelectionLength = 0
      $Description.SelectionColor = "Green"
      $Description.AppendText($MessagePermission)
      $Description.AppendText([Environment]::NewLine)
    } else {
      $Description.AppendText("Administrator Permission Unknown...")
      $Description.AppendText([Environment]::NewLine)
    }
    Show-Buttons @('$NextButton', '$CancelButton')
  } else {
    $MessagePermission = (New-CommandString $Requirement.KoMessage)
    $Description.SelectionStart = $Description.TextLength
    $Description.SelectionLength = 0
    $Description.SelectionColor = "Red"
    $Description.AppendText($MessagePermission)
    $Description.AppendText([Environment]::NewLine)
    Show-Buttons @('$DoneButton')
  }
}

function Invoke-PostInstallAction {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0, Mandatory = $true)]
    $Requirement
  )

  if ($Requirement.Attributes) {
    $RecommendedExtensions = (New-CommandString $Requirement.Attributes).Split(" ")
    foreach ($script:item in $RecommendedExtensions) {
      if ($Requirement.CheckRequirement) {
        # TODO checkRequirement vscode extensions 
        $Description.AppendText("Installing $item...")
        $Description.AppendText([Environment]::NewLine)
        $ResultCommand = Invoke-Expression (New-CommandString $Requirement.PostInstallCommand)
        if (-not $ResultCommand) {
          Get-Content $OutLogfile, $ErrLogfile | Add-Content $Logfile
          $ContentErrLogfile = Get-Content $OutLogfile, $ErrLogfile
          if ($ContentErrLogfile -like "*Failed Installing Extensions*") {
            $Description.SelectionStart = $Description.TextLength
            $Description.SelectionLength = 0
            $Description.SelectionColor = "Red"
            $Description.AppendText("Failed installing extension $item!")
            $Description.AppendText([Environment]::NewLine)
          } elseif ($ContentErrLogfile -like "*was successfully installed.*") {
            $Description.SelectionStart = $Description.TextLength
            $Description.SelectionLength = 0
            $Description.SelectionColor = "Green"
            $Description.AppendText("$item was successfully installed.")
            $Description.AppendText([Environment]::NewLine)
          } else {
            $Description.SelectionStart = $Description.TextLength
            $Description.SelectionLength = 0
            $Description.SelectionColor = "Green"
            $Description.AppendText("$item was already installed.")
            $Description.AppendText([Environment]::NewLine)
          }
        }
      }
    }
    Show-Buttons @('$NextButton', '$CancelButton')
  } else {
    if ($Requirement.CheckRequirement) {
      $PostInstallResultCheck = Invoke-Expression (New-CommandString $Requirement.CheckRequirement)
      if ($PostInstallResultCheck[0] -eq $true) {
        if ($PostInstallResultCheck[1] -eq 'OK') {
          $MessagePostInstall = Invoke-Expression (New-CommandString $Requirement.PostInstallTrueOkMessage)
          $Description.SelectionStart = $Description.TextLength
          $Description.SelectionLength = 0
          $Description.SelectionColor = "Green"
          $Description.AppendText($MessagePostInstall)
          $Description.AppendText([Environment]::NewLine)
          if ($Requirement.PostInstallTrueOkCommand) {
            Invoke-Expression (New-CommandString $Requirement.PostInstallTrueOkCommand)
          }
        } else {
          $MessagePostInstall = Invoke-Expression (New-CommandString $Requirement.PostInstallMessage)
          $Description.AppendText($MessagePostInstall)
          $Description.AppendText([Environment]::NewLine)
          
          Invoke-Expression (New-CommandString $Requirement.PostInstallCommand)
          Get-Content $OutLogfile, $ErrLogfile | Add-Content $Logfile
          $MessagePostInstall = Invoke-Expression (New-CommandString $Requirement.PostInstallCompleteMessage)

          $Description.AppendText($MessagePostInstall)
          $Description.AppendText([Environment]::NewLine)
        }
        Show-Buttons @('$NextButton', '$CancelButton')
      } else {
        $Description.SelectionStart = $Description.TextLength
        $Description.SelectionLength = 0
        $Description.SelectionColor = "Red"
        $Description.AppendText("TCP connect to Proxy Address failed")
        $Description.AppendText([Environment]::NewLine)
        
        Show-Buttons @('$DoneButton')
      }
    }
  }
}

function Invoke-PreInstallAction {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0, Mandatory = $true)]
    $Requirement
  )

  $ResultPreInstall = Invoke-Expression (New-CommandString $Requirement.CheckRequirement)

  if ($ResultPreInstall[0] -eq $true) {
    if ($ResultPreInstall[1] -eq 'OK') {
      $MessagePreInstall = Invoke-Expression (New-CommandString $Requirement.OkMessage)
    } else {
      $MessagePreInstall = Invoke-Expression (New-CommandString $Requirement.WarningMessage)
    }
    Show-Buttons @('$NextButton', '$CancelButton')
  } else {
    $MessagePreInstall = Invoke-Expression (New-CommandString $Requirement.WarningMessage2)
    Show-Buttons @('$DoneButton')
  }
  $Description.AppendText($MessagePreInstall)
  $Description.AppendText([Environment]::NewLine)
}

function New-CommandString($String) {
  $StringWithValue = $String
  do {
    Invoke-Expression("Set-Variable -name StringWithValue -Value `"$StringWithValue`"")
  } while ($StringWithValue -like '*$(*)*')
  return $StringWithValue
}

# SIG # Begin signature block
# MIIk2wYJKoZIhvcNAQcCoIIkzDCCJMgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUgbxCm17veDVL8gLUKetfZrU/
# AKuggh62MIIFOTCCBCGgAwIBAgIQDue4N8WIaRr2ZZle0AzJjDANBgkqhkiG9w0B
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
# BBThFXojX8wwGi4Erx4ESHBuavzGvzAkBgorBgEEAYI3AgEMMRYwFKASgBAAQwBB
# ACAAVABvAG8AbABzMA0GCSqGSIb3DQEBAQUABIIBAGpZbl4XY+BbUCcK9vKZnmb5
# 0dP9DZcqcb74/48fyC8W4+aqTlnBdrwQPt0BoEAmlRIX8PHKbUiznf2G73KmdCEp
# LjZOJankDMbeCX5ep2Ah9ik7jL41f56NoMxU6XLhTdLlQm16azjPeslQ6fbf7P4P
# DoRQ7VwiTporwMWZpFMZpXZQddWGnPcK/HDTBV6OUNNiGA6AURYTCnuMs4wJCPeG
# WQ2I99xN9rNGqenyONgiW2ZJU/3jiSgMS2uC8fhChR7YTrKgiUKZ2A3PKy+bt08+
# ir5D7d4TDZk6b5Z8yu+9ce/ZFugx6EW61YQgdwAQ5Te4AepWh9u2LCloXlgOF2eh
# ggNMMIIDSAYJKoZIhvcNAQkGMYIDOTCCAzUCAQEwgZIwfTELMAkGA1UEBhMCR0Ix
# GzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEY
# MBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMSUwIwYDVQQDExxTZWN0aWdvIFJTQSBU
# aW1lIFN0YW1waW5nIENBAhEAjHegAI/00bDGPZ86SIONazANBglghkgBZQMEAgIF
# AKB5MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIy
# MDMxODEzMzk0MVowPwYJKoZIhvcNAQkEMTIEMKofGoZm10yvVyD2SXZFzADgTVYJ
# OACJc7HKfbnAR/kTMplnGb4hGuhyyAjDaTzPUjANBgkqhkiG9w0BAQEFAASCAgCK
# dsoV3u2fsAJ4dRhBWbhn+6quNyBrfW55BEhk9wgU5dtdiGlyLfgfReGHAPaNPfQI
# /uy3yO8eBES3XeNznFaEqnhqwCg1OfpnlKDWP+6q/+EgIEjArBHfpczXCTumyBm5
# 9/bNIZ/a9Xa5AejBbcFHdtG/qyGREZcbyr++xwnkgeaQ/zvnnHJwdpEVu9YbbS6J
# xhgU1E0TdAl5xSDV0/AZmPWg4vpnM6lf9D2GHMYzxb/HadP2wR++Mw+nOyLutk8c
# MSNym+aisgcs8XKBPsgiK9X7NHdCqSYxPOfUpaUnj19A+20WS9XZs546UcP3HCak
# xqniL4E3pkS2aMr7eoANFLgPWNFb8vfq0rbngH7DGj2SVWd3ooU0CfoY7rQLAb+o
# FUfujCyfA0Ksy0RxDRiq8JYuXKC/8z/mrGR1YAwohV2q5Ys8eM5G7bHm6CvbwQFT
# 5D+Prrb65USnCLnZwB6pvnt76CHvsaYGa7kSneTq+rdeSKZ+RoMhjJVCEyhhDfP4
# jawaenmd6egKqeoWYkdotidVEns3AtuoklALcGLKrQ1iaVzE2JvXdXBsdF+TUIpY
# O5KRoF1mfOvvpj5CkWnQ2ANqGdjMzRs0pWbGAeH1udpGGEY68VRcksxQQ1hZbWWp
# f5WQhSlePCxla/o28oRgrg9kcjMgoJJTCAQH5VDD9Q==
# SIG # End signature block
