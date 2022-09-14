param(
    [string]$link,
    [string]$outPath
)

#Scarica dipendenze necessarie puntando alle Properties "DownloadLink" e "DownloadOutFile" del file requirements.json
Invoke-RestMethod $link -OutFile $outPath