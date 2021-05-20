$RDShost = Read-Host -Prompt 'RDS Host IP or FQDN'
$Password = Read-Host -Prompt 'Input Default Password for all Users'
$Adminuser = Read-Host -Prompt 'Input Admin User login name'
$AdminPassword = Read-Host -Prompt 'Input Admin password with Remote Execution capabilities'
############

############
$Users = (Get-Content .\user.txt).count
Write-Host How many session do you want to start ? Number between 0 - $Users 
$Sessioncount = Read-Host
$continue = $true
$temp = ""
do {    
    
    $Check = Get-WmiObject Win32_Process -Filter "Name='powershell.exe' AND CommandLine LIKE '%Sessionscript.ps1%'"
    $temp = $Check | Select-String  -Pattern "Win32"

    if ($temp.count -lt $Sessioncount) {
        do {    
            Write-Host "Starting new Instance"
            start -Filepath powershell.exe -WorkingDirectory C:\Users\Administrator\RDP-RDS-Automatic-light-load-test-tool\ -ArgumentList "C:\Users\Administrator\RDP-RDS-Automatic-light-load-test-tool\Sessionscript.ps1 -Adminuser $Adminuser -Adminpassword $Adminpassword -RDShost $RDShost -Password $Password"
            $Check = Get-WmiObject Win32_Process -Filter "Name='powershell.exe' AND CommandLine LIKE '%Sessionscript.ps1%'"
            $temp = $Check | Select-String  -Pattern "Win32"
            Start-Sleep 2
            
        } while ($temp.count -lt $Sessioncount) 
    }
    else {
        Write-Host "Max Sessions reached, waiting"
        Start-Sleep 2              
    }
    
} while ($continue -eq "true")

Write-Host "End"
pause 