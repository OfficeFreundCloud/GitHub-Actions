$sqlServerVersion = '2022'

if ($Env:RUNNER_OS -eq 'Windows')
{
    choco install sql-server-$sqlServerVersion --no-progress
}
else
{
    $sqlServerName = "uitt-sqlserver"
    $sqlServerLink = "mcr.microsoft.com/mssql/server:${sqlServerVersion}-latest"
    
    $dockerRunSwitches = @(
        '--name', $sqlServerName
        '--env', 'ACCEPT_EULA=Y'
        '--env', 'SA_PASSWORD=Password1!'
        '--publish', '1433:1433'
        '--detach', $sqlServerLink
    )

    docker pull $sqlServerLink &&
    docker run @dockerRunSwitches &&
    docker exec --user 0 $sqlServerName bash -c 'mkdir /data; chmod 777 /data --recursive; chown mssql:root /data'
}
