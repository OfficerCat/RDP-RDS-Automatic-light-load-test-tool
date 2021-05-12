#Daten Abfragen
#$Remotedestination = Read-Host -Prompt "Full Path of the Bench.ps1 skriptfile on the Remotehost example: C:\Bench.ps1"
$RDShost = Read-Host -Prompt 'RDS Host IP or FQDN'
$Password = Read-Host -Prompt 'Input Default Password for all Users'
# Zufällig einen User aus der User.txt auswählen
$user = gc user.txt | sort{get-random} | select -First 1
do {
    $userexists = Select-String -Path inuse.txt -Pattern $user -SimpleMatch
    If ($userexists.length -gt 0) 
    {
        $user = gc user.txt | sort{get-random} | select -First 1
        Write-Host 'Error'        
    }
}
while ($userexists.length -gt 0)
Add-Content -Path inuse.txt -Value $user
Write-Host $user

cmdkey /generic:TERMSRV/$RDShost /user:$user /pass:$Password
#mstsc /v:$RDShost

Invoke-Command -Computername $RDShost -Credential $user -ScriptBlock {."C:\Bench.ps1"} #Assuming the script is on the C:\ Drive of the RemoteComputer

(Get-Content inuse.txt).replace($user, '') | Set-Content inuse.txt

#set-item wsman:localhost\client\trustedhosts -value *