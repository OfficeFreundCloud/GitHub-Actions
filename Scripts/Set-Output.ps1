param (
    [Parameter(Mandatory = $true, Position = 0)]
    [string]
    $Key,

    [Parameter(Mandatory = $true, Position = 1)]
    [string]
    $Value
)

Write-Warning "The 'Set-Output' script will soon be removed/renamed, use 'Set-GitHubOutput' instead!"

"$Key=$Value" >> $Env:GITHUB_OUTPUT