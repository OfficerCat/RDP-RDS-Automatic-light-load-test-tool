# Zufällig einen User aus der User.txt auswählen
$user = gc C:\Powershell_Auto\User.txt | sort{get-random} | select -First 1
$Password = "Katzenfutter"
$RDShost = "159.69.229.235"
Write-Host $user

cmdkey /generic:TERMSRV/$RDShost /user:$user /pass:$Password
mstsc /v:$RDShost

Invoke-Command -Computername $RDShost -Credential Administrator -ScriptBlock {."c:\Scripts\script.ps1"} #Assuming the script is on the C:\ Drive of the RemoteCompute