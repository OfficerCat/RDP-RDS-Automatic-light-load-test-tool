param(
  [string]$RDShost,
  [string]$Password,
  [string]$Adminuser,
  [string]$AdminPassword

)
Write-Host $Adminuser
Write-Host $AdminPassword
# Choose random user from "user.txt"
$user = Get-Content user.txt | Sort-Object { get-random } | Select-Object -First 1
$securePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -force
$credential = New-Object System.Management.Automation.PsCredential($Adminuser, $securePassword)

do {
  $userexists = Get-ChildItem -Path TMP -Name "$user" 
  If ($userexists.length -gt 0) {
    $user = Get-Content user.txt | Sort-Object { get-random } | Select-Object -First 1
    Write-Host 'Error'        
  }
}
while ($userexists.length -gt 0)
New-Item -Path TMP -Name $user
Write-Host $user
#Starting RDP Session
#DOMÄNE!!!
cmdkey /generic:TERMSRV/$RDShost /user:RDS\$user /pass:$Password
mstsc /w:800 /h:600 /v:$RDShost
Start-Sleep -Seconds 10
#RDP Session ID
$users = Invoke-command $RDShost -credential $credential -scriptblock { c:\PSTest\SessionID.ps1 $user }
$IDs = @() ;
for ($i = 1; $i -lt $users.Count; $i++) {
  #using regex to find the ID
  $temp = [string]($users[$i] | Select-String -pattern .*$user.*\d+\s).Matches;
  $tempID = [string]($temp | Select-String -pattern  \s\d+\s ).Matches;
  $tempID = $tempID.Trim() ;
  $IDs += $tempID ;
}
$IDs
Psexec.exe \\$RDShost -i $IDs -u $user -p $Password powershell "C:\PSTest\Bench.ps1"
#Remove from inuse.txt list
Psexec.exe \\$RDShost -i $IDs -u $user -p $Password powershell "shutdown /l /f"
Remove-Item TMP/$user -Force -Confirm:$false
