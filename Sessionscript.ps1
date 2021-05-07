# Zufällig einen User aus der User.txt auswählen
$RDShost = Read-Host -Prompt 'RDS Host IP or FQDN'
$Password = Read-Host -Prompt 'Input Default Password for all Users'
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

#Invoke-Command -Computername $RDShost -Credential Administrator -ScriptBlock {."c:\Scripts\script.ps1"} #Assuming the script is on the C:\ Drive of the RemoteComputer

(Get-Content inuse.txt).replace($user, '') | Set-Content inuse.txt
