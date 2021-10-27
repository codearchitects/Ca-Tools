$ScarfaceData = @{
	Name        = ''
	Prefix      = ''
	Domain      = ''
    Scenario    = ''
	React       = ''
	DevExtreme  = ''
    Npm         = ''
    Nuget       = ''
    Author      = ''
    User        = ''
    Token       = ''
}

$Token = @{
    token =  ''
    organization =  ''
    date =  ''
    registry =  ''
    user = ''
}


function Get-ScarfaceJSON {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$Name = 'ProjectName',

        [Parameter(Position = 1)]
        [string]$Prefix = 'Prefix',

        [Parameter(Position = 2)]
        [string]$Domain = 'CA',

        [Parameter(Position = 3)]
        [string]$Scenario = "Hello World",

        [Parameter(Position = 4)]
        [ValidateSet('Yes', 'No')]
        [string]$React = 'No',

        [Parameter(Position = 5)]
        [ValidateSet('Yes', 'No')]
        [string]$DevExtreme = 'No',

        [Parameter(Position = 6)]
        [string]$Npm = 'https://devops.codearchitects.com:444/Code%20Architects/_packaging/ca-npm/npm/registry/',

        [Parameter(Position = 7)]
        [string]$Nuget = 'https://devops.codearchitects.com:444/Code%20Architects/_packaging/ca-nuget/nuget/registry/',

        [Parameter(Position = 8)]
        [string]$Author = 'Author Name',

        [Parameter(Position = 9)]
        [string]$TokenPath = '~/.token.json'
    )

    $MaxDate = 0
    
    Get-Content $TokenPath | ConvertFrom-Json -AsHashtable | ForEach-Object {
        $CurrentDate = $_.date.Replace("-", "")
        if ($MaxDate -lt $CurrentDate) {
            $MaxDate = $CurrentDate
            $TokenObj = $_
        }
    }
    
    $Token = $TokenObj.token
    $User = $TokenObj.user

    $ScarfaceData.Name = $Name
    $ScarfaceData.Prefix = $Prefix
    $ScarfaceData.Domain = $Domain
    $ScarfaceData.Scenario = $Scenario
    $ScarfaceData.React = $React
    $ScarfaceData.DevExtreme = $DevExtreme
    $ScarfaceData.Npm = $Npm
    $ScarfaceData.Nuget = $Nuget
    $ScarfaceData.Author = $Author
    $ScarfaceData.User = $User
    $ScarfaceData.Token = $Token

    $ScarfaceData | ConvertTo-Json | Out-File "$($HOME)\Documents\CodeArchitects\myJSON.json"
} 