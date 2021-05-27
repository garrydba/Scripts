<#
PURPOSE: 
    To backup databases from collection of backups
PREREQUISITES: 
    This script uses dbatools module. It can be downloaded from https://dbatools.io/
HOW TO USE:
    1. Provide SQL Login
    2. Provide name of instance
#>
Clear-Host
Import-Module -Name "C:\Program Files\WindowsPowerShell\Modules\dbatools"

$username = "sa"
$password = ConvertTo-SecureString -String "MyPa$$W0rd" -AsPlainText -Force
$dbcred = New-Object System.Management.Automation.PSCredential $Username,$Password
$instanceName="myServer\devInstance"

Get-DbaDatabase -SqlInstance $instanceName -SqlCredential $dbcred -ExcludeSystem | Backup-DbaDatabase -path "C:\Backups\" -Type Full
