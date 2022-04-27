<#
PURPOSE: 
    Collect various database matrix like,
    1. Total free disk space in GB
    2. Total database size in MB
    3. Size of specific table(s) in MB from list

HOW TO USE:
    1. Provide name of instance
    2. Provide name of database
    3. Set this script to run on some interval

#>

Clear-Host
# Name of SQL Server instance (generally it being local instance, no need to change it unless required)
$Server = "FOO"           

# Name of database to be monitored, this can very per installation
$dbName = "BAR"

$authMode="SQL" # Other option is SQL
$sqlUser="sa" # user to be used in SQL Authentication mode
$sqlUserPass="MySuperPassword" # password to be used in SQL Authentication mode

# Location where performance matrix will be captured
$outputFolderName = "C:\Database\History"
$outputFileName="DBMatrix.csv"

# List of tables that need to be tracked, it can be customized based on need (if changed, it will invalidate current CSV file)
$tableToWatch = "BarTable1", "BarTable4", "BarTable11", "BarTable15"
# Sort above list alphabatically
$tableToWatch = $tableToWatch | Sort-Object

$out1 = @()
# Monitoring C drive only
$disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'" | Select-Object Size, FreeSpace
$diskFreeSpace = $disk.FreeSpace / 1GB

$date = Get-Date -Format "yyyyMMdd_hhmmss"
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | out-null
$SMOserver = New-Object ('Microsoft.SqlServer.Management.Smo.Server') -argumentlist $Server
if ($authMode -eq "SQL")
{
$SMOserver.ConnectionContext.LoginSecure=$false
$SMOserver.ConnectionContext.set_login($sqlUser)
$SMOserver.ConnectionContext.set_Password($sqlUserPass)
}

$outlist = New-Object System.Object

foreach ($db in $SMOserver.Databases | Where-Object {$_.Name -eq $dbName}) {
    
    $dbDataSpaceUsageInGB = (($db.DataSpaceUsage * 1024) / 1MB)             
    $outlist | Add-Member -MemberType NoteProperty -Name "DBName" -Value $db.Name -PassThru   
    $outlist | Add-Member -MemberType NoteProperty -Name "DBSize(MB)" -Value $db.Size -PassThru       
    $outlist | Add-Member -MemberType NoteProperty -Name "ActualDataFileSize(MB)" -Value $dbDataSpaceUsageInGB -PassThru   
    
    foreach ($table in $db.Tables) {
        if ($table.Name -in $tableToWatch) {                   
            $tableSize = [Math]::Truncate(($table.DataSpaceUsed * 1024) / 1MB)   
            $tableName = $table.Name + "(MB)"                       
            $outlist | Add-Member -MemberType NoteProperty -Name $tableName -Value $tableSize -PassThru       
        }
    }
}

$outlist | Add-Member -MemberType NoteProperty -Name "DiskFreeSpace(GB)" -Value $diskFreeSpace -PassThru
$outlist | Add-Member -MemberType NoteProperty -Name "Date" -Value $date -PassThru
$out1 += $outlist

If (!(Test-Path $outputFolderName\$outputFileName)){
    New-Item -ItemType Directory -Force -Path $outputFolderName 
}
else {
    # If file is larger than 1MB, back it up and create new file
    If((Get-Item $outputFolderName\$outputFileName).Length -gt 1MB)
    {        
        $newFileName = ([System.IO.Path]::GetFileNameWithoutExtension($outputFileName)) + "_"+ $date + ".bak"
        Rename-Item -path $outputFolderName\$outputFileName -NewName $outputFolderName\$newFileName
    }
}

$out1 | Export-Csv $outputFolderName\DBMatrix.csv -NoTypeInformation -Append