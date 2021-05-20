param(
  [string]$RDShost,
  [string]$Password,
  [string]$Adminuser,
  [string]$AdminPassword

)
Write-Host $Adminuser
Write-Host $AdminPassword
Start-Sleep -Seconds 2
# Choose random user from "user.txt"
$user = Get-Content user.txt | Sort-Object { get-random } | Select-Object -First 1
$securePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -force
$credential = New-Object System.Management.Automation.PsCredential($Adminuser, $securePassword)

do {
  $userexists = Select-String -Path inuse.txt -Pattern $user -SimpleMatch
  If ($userexists.length -gt 0) {
    $user = Get-Content user.txt | Sort-Object { get-random } | Select-Object -First 1
    Write-Host 'Error'        
  }
}
while ($userexists.length -gt 0)
Add-Content -Path inuse.txt -Value $user
Write-Host $user
#Starte RDP Session
cmdkey /generic:TERMSRV/$RDShost /user:$user /pass:$Password
mstsc /v:$RDShost
Start-Sleep -Seconds 2
#RDP Session ID
$users = Invoke-command $RDShost -credential $credential -scriptblock { c:\PSTest\SessionID.ps1 $user }
$IDs = @() ;
for ($i = 1; $i -lt $users.Count; $i++) {
  #using regex to find the IDs
  $temp = [string]($users[$i] | Select-String -pattern .*$user.*\d+\s).Matches;
  $tempID = [string]($temp | Select-String -pattern  \s\d+\s ).Matches;
  $tempID = $tempID.Trim() ;
  $IDs += $tempID ;
}
$IDs
Psexec.exe \\$RDShost -i $IDs -u $Adminuser -p $AdminPassword powershell "C:\PSTest\Bench.ps1"
#Remove from inuse.txt list
Start-Sleep 15
(Get-Content inuse.txt).replace($user, '') | Set-Content inuse.txt

