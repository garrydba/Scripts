<#
PURPOSE: 
    To delete all databases from collection of instances
PREREQUISITES: 
    1. This script uses dbatools module. It can be downloaded from https://dbatools.io/
    2. All instances are using same SQL login (that is my case )
HOW TO USE:
    1. Provide SQL Login
    2. Provide list of instances (it can be done instance as well)
#>

 
Clear-Host
Import-Module -Name "C:\Program Files\WindowsPowerShell\Modules\dbatools"

$username = "sa"
$password = ConvertTo-SecureString -String "MyPa$$W0rd" -AsPlainText -Force
$dbcred = New-Object System.Management.Automation.PSCredential $Username,$Password

# List of instance names for which ALL databases need to be removed
$instanceName=@("DEVUS3042452-01", "DEVUS3042452-02", "TEST34508-23","AZLKJE234082")

Get-DbaDatabase -SqlInstance $instanceName -SqlCredential $dbcred -ExcludeSystem | Remove-DbaDatabase
