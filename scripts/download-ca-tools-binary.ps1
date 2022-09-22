param(
    [string]$link,   # $($Requirement.DownloadLink)
    [string]$outPath # $($Requirement.DownloadOutfile)
)

Invoke-RestMethod (((Invoke-RestMethod $link).assets[0]).browser_download_url) -OutFile $outPath