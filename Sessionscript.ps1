#$Remotedestination = Read-Host -Prompt "Full Path of the Bench.ps1 skriptfile on the Remotehost example: C:\Bench.ps1"
$RDShost = Read-Host -Prompt 'RDS Host IP or FQDN'
$Password = Read-Host -Prompt 'Input Default Password for all Users'
# ZufÃ¤llig einen User aus der User.txt auswÃ¤hlen
$user = Get-Content user.txt | Sort-Object{get-random} | Select-Object -First 1
$securePassword = ConvertTo-SecureString $Password -AsPlainText -force
$credential = New-Object System.Management.Automation.PsCredential($user,$securePassword)

do {
    $userexists = Select-String -Path inuse.txt -Pattern $user -SimpleMatch
    If ($userexists.length -gt 0) 
    {
        $user = Get-Content user.txt | Sort-Object{get-random} | Select-Object -First 1
        Write-Host 'Error'        
    }
}

while ($userexists.length -gt 0)
Add-Content -Path inuse.txt -Value $user
#
Write-Host $user
#Starte RDP Session
cmdkey /generic:TERMSRV/$RDShost /user:$user /pass:$Password
mstsc /v:$RDShost
Start-Sleep -Seconds 2
#RDP Session ID
$users = Invoke-command $RDShost -credential $credential -scriptblock {c:\PSTest\SessionID.ps1}
$IDs = @() ;

for ($i=1; $i -lt $users.Count;$i++) 
{
  #using regex to find the IDs
  $temp = [string]($users[$i] | Select-String -pattern .*$user.*\d+\s).Matches;
  $tempID = [string]($temp | Select-String -pattern  "\s\d+\s" ).Matches;
  $tempID = $tempID.Trim() ;
  $IDs += $tempID ;
}
$IDs
Psexec.exe \\$RDShost -i $IDs -u $user -p $Password powershell "C:\PSTest\Bench.ps1"
Start-Sleep -Seconds 10
#Remove from use list
(Get-Content inuse.txt).replace($user, '') | Set-Content inuse.txt

#set-item wsman:localhost\client\trustedhosts -value *

Start-Sleep -Seconds 10