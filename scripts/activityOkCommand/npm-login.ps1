$Description.Text = 'I have found an Azure DevOps account, do you want to login with it?'
$TokenPath = "~/.token.json"
$TokenParsed = Get-Content $TokenPath | ConvertFrom-Json
$Index = $TokenParsed.Count - 1
$UsernameTextBox.Text = $TokenParsed[$Index].user
$TokenTextBox.Text = $TokenParsed[$Index].token
Show-LoginNpmScreen