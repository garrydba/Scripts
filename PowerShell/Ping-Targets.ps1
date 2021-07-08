Clear-Host

<#
    Purpose: Continuously check availability of IP (or collection of IP)
    How it works: This script takes list of IP(s) specified in file called "IP_List.txt". 
                  Then goes through each IP address. And use Test-Connection cmdlet to check availability of IP. In theory this cmdlet works same as PING.
                  If device fails to respond, script logs IP and timestamp in a file called PING.log.
                  If new IP need to be added, script need to be restarted.
#>

$scriptPath = $MyInvocation.MyCommand.Path
$setDir = Split-Path $scriptPath -Parent
Set-Location $setDir
$ipList = Get-Content IP_List.txt
do {
    foreach ($ip in $ipList) {
        if (! (Test-Connection -ComputerName $ip -Count 1 -Quiet)) {
            $dt = Get-Date    
            $OutPut = "$ip down : " + $dt
            $OutPut  | out-file "Ping.log" -append
        }
    }

    start-sleep -s 1
}
while ("THIS" -ne "THAT")