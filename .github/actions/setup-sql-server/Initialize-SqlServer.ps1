param (
    [string]$WindowsSqlServerExpressVersion = '2022.16.0.1000',
    [string]$LinuxSqlServerVersion = '2022'
)

if ($Env:RUNNER_OS -eq 'Windows')
{
    choco install sql-server-express --version=$WindowsSqlServerExpressVersion --no-progress
}
else
{
    $containerName = 'uitt-sqlserver'
    $sqlServerLink = "mcr.microsoft.com/mssql/server:$LinuxSqlServerVersion-latest"

    $dockerRunSwitches = @(
        '--name', $containerName
        '--env', 'ACCEPT_EULA=Y'
        '--env', 'SA_PASSWORD=Password1!'
        '--publish', '1433:1433'
        '--detach', $sqlServerLink
    )

    docker pull $sqlServerLink &&
    docker run @dockerRunSwitches &&
    docker exec --user 0 $containerName bash -c 'mkdir /data; chmod 777 /data --recursive; chown mssql:root /data'
}
