param(
    [string]$downloadOutfile
)

Remove-Item ($downloadOutfile.replace('"',''))