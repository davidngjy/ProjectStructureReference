if (Get-Module -ListAvailable -Name sqlps) {
    Import-Module -Name sqlps
} 
elseif (Get-Module -ListAvailable -Name sqlserver) {
    Import-Module -Name sqlserver
}
else {
    Install-Module -Name SqlServer
    Import-Module -Name SqlServer
}

$username = New-Guid # get a pseudo-random username
$password = New-Guid # get a pseudo-random password
$server = "localhost"

# create the login
Invoke-Sqlcmd -ServerInstance $server -Database master -AbortOnError -OutputSqlErrors $true -Query @"
CREATE LOGIN [$username] WITH PASSWORD=N'$password', CHECK_POLICY = OFF;
"@

foreach ($database in "Management", "Authorization") {

    # create the user and grant read/write/execute access
    Invoke-Sqlcmd -ServerInstance $server -Database $database -AbortOnError -OutputSqlErrors $true -Query @"
SET XACT_ABORT ON

BEGIN TRAN

    CREATE USER [$username] FOR LOGIN [$username] WITH DEFAULT_SCHEMA=[dbo];

    IF DATABASE_PRINCIPAL_ID('db_executor') IS NULL
    BEGIN
        CREATE ROLE [db_executor];
        GRANT EXECUTE TO [db_executor];
    END

    EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'$username';
    EXECUTE sp_addrolemember @rolename = N'db_datawriter', @membername = N'$username';
    EXECUTE sp_addrolemember @rolename = N'db_executor', @membername = N'$username';

COMMIT TRAN
"@

    # create a connection string as an environment variable (to be used by docker compose)
    [Environment]::SetEnvironmentVariable("HostConnectionStrings_$database", "Server=host.docker.internal;Database=$database;User Id=$username;Password=$password;", [EnvironmentVariableTarget]::Machine)
    Write-Host("Successfully set EnvironmentVariable Key: HostConnectionStrings_$database Value: Server=host.docker.internal;Database=$database;User Id=$username;Password=$password;")
}

kubectl create secret generic db-connection-string --from-literal=authorization-db=Server="host.docker.internal;Database=Authorization;User Id=$username;Password=$password;" --from-literal=management-db=Server="host.docker.internal;Database=Management;User Id=$username;Password=$password;"
