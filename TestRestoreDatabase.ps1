function Test-SQLBackups {
    <#
        .SYNOPSIS
            It tests restores of databases to a particular environment
        .DESCRIPTION
            It tests restores of databases to a particular environment
        .PARAMETER AutomationServer
            SQL Server Instance where DBA Automation Database is located
            .PARAMETER RepositoryDB
            Name of the Repository Database where the databases, servers and applications are stored
        .PARAMETER AutomationDB
            Name of the DBA Automation Database where the results are stored
        .PARAMETER TargetRestoreServer
            SQL Server Instance where database should be restored to
        .PARAMETER TargetResultsTable
            Database where the restore output information will be stored.
        .NOTES
            Tags: Backup, Databases, Restore
            Author: Marcos Freccia
            Website: https://github.com/marcosfreccia
            License: GNU GPL v3 https://opensource.org/licenses/GPL-3.0

        .EXAMPLE
            $AutomationServer = "srvsql2017"
            $RepositoryDB = "DBARepository"
            $AutomationDB = "DBAUtils"
            $TargetRestoreServer2016 = "SRVSQL2017\DEV"
            $TargetRestoreServer2017 = "SRVSQL2017\DEV"
            $TargetResultsTable = "[dbo].[restore_database_staging]"
            Test-SQLBackups -AutomationServer $AutomationServer -RepositoryDB $RepositoryDB -AutomationDB $AutomationDB -TargetRestoreServer2016 $TargetRestoreServer2016 -TargetRestoreServer2017 $TargetRestoreServer2017 -TargetResultsTable $TargetResultsTable
    #>
    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory)][string]$AutomationServer,
        [Parameter(Mandatory)][string]$RepositoryDB,
        [Parameter(Mandatory)][string]$AutomationDB,
        [Parameter(Mandatory)][string]$TargetRestoreServer2016,
        [Parameter(Mandatory)][string]$TargetRestoreServer2017,
        [Parameter(Mandatory)][string]$TargetResultsTable,
        [Parameter()][switch]$PurgeResultsTable
    )
    try {
        if ($PurgeResultsTable) {
            Invoke-Sqlcmd2 -ServerInstance $AutomationServer -Database $AutomationDB -Query "TRUNCATE TABLE $TargetResultsTable"

        }


        $Restores = Invoke-Sqlcmd2 -ServerInstance $AutomationServer -Database $RepositoryDB -Query "SELECT srv.ServerName,app.[database],srvo.[Version] AS sql_version FROM dbo.Applications AS app
        JOIN servers AS srv
        ON srv.id = app.idServer
		JOIN dbo.ServerOverview AS srvo
		ON srv.ServerName = srvo.ServerName
        WHERE srv.SrvRole = 'PRODUCTION'
        ORDER BY app.AppName"

        foreach ($Restore in $Restores) {
            $source_server_name = $Restore.ServerName
            $source_database_name = $Restore.database
            $sql_version = $Restore.sql_version

            
            if ($sql_version -like "*2016*") {
                Test-DbaLastBackup -SqlInstance $source_server_name -Destination $TargetRestoreServer2016 -Database $source_database_name | Out-DbaDataTable | Write-DbaDataTable -SqlInstance $AutomationServer -Table "$AutomationDB.$TargetResultsTable"
                Write-Output "$sql_version - $source_server_name - $source_database_name"
            }
            else {
                Write-Output "$sql_version - $source_server_name - $source_database_name"
                Test-DbaLastBackup -SqlInstance $source_server_name -Destination $TargetRestoreServer2017 -Database $source_database_name | Out-DbaDataTable | Write-DbaDataTable -SqlInstance $AutomationServer -Table "$AutomationDB.$TargetResultsTable"

            }

        }

    }

    catch {
        Write-Error $Error[0].Exception
    }



}
$AutomationServer = "srvsql2017"
$RepositoryDB = "dbarepository"
$AutomationDB = "DBAUtils"
$TargetRestoreServer2016 = "SRVSQL2017\DEV"
$TargetRestoreServer2017 = "SRVSQL2017\DEV"
$TargetResultsTable = "[dbo].[restore_database_staging]"

Test-SQLBackups -AutomationServer $AutomationServer -RepositoryDB $RepositoryDB -AutomationDB $AutomationDB -TargetRestoreServer2016 $TargetRestoreServer2016 -TargetRestoreServer2017 $TargetRestoreServer2017 -TargetResultsTable $TargetResultsTable
