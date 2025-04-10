Clear-Host

<# 
    PURPOSE: Migrate all databases from one instance to new instance using DBATOOLS (https://dbatools.io/)
    DETAILS: This script does following,
        1. Get old instance name and new instance name as parameter. 
        2. Get list of databases based on different switches (I am excludng system and specific user database)
        3. Detach db from old instance ((this is what Copy-Dbadatabase does)
        4. Copy it to new location (this is what Copy-Dbadatabase does. Default database location used by new instance)
        5. Attach newly copied files to new instance (that is what -DetachAttach switch does)
        6. Reattach detached DB of step 2 (that is what -Reattach switch does)
        7. Removes database from old instance without showing confirmation prompt (that is what Remove-DbaDatabase does) 
        8. Adding sleep timer because of trust issues with Windows OS ;)
#>

$oldInstanceName = "sqlserver\my2016instance"
$newInstanceName = "sqlserver\my2022instance"

$oldDataBases = Get-DbaDatabase -SqlInstance $oldInstanceName -ExcludeSystem -ExcludeDatabase DB_That_Needs_Skipping | Sort-Object Name

foreach ($db in $oldDataBases)
{
    write-host $db.Name
    Copy-DbaDatabase -Source $oldInstanceName -Destination $newInstanceName -Database $db.Name -DetachAttach -Reattach   
    Start-Sleep -Seconds 2
    Remove-DbaDatabase -SqlInstance $oldInstanceName -Database $db.Name -Confirm:$false
    write-host $db.Name " migrated"
    Start-Sleep -Seconds 10
} 
