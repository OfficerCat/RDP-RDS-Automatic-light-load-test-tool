$RDShost = Read-Host -Prompt 'RDS Host IP or FQDN'
$Password = Read-Host -Prompt 'Input Default Password for all Users'
$Adminuser = Read-Host -Prompt 'Input Admin User login name'
$AdminPassword = Read-Host -Prompt 'Input Admin password with Remote Execution capabilities'
############
$securePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -force
$credential = New-Object System.Management.Automation.PsCredential($Adminuser, $securePassword)
############
$Users = (Get-Content .\user.txt).count
Write-Host How many session do you want to start ? Number between 1 - $Users 
$Sessioncount = Read-Host
$continue = $true
$temp = ""
do {    
    
    $Check = Get-WmiObject Win32_Process -Filter "Name='powershell.exe' AND CommandLine LIKE '%Sessionscript.ps1%'"
    $temp = $Check | Select-String  -Pattern "Win32"

    if ($temp.count -lt $Sessioncount) {
        do {    
            $CPUUsageRDS = Invoke-command $RDShost -credential $credential -scriptblock {Get-WmiObject Win32_Processor | Select-Object LoadPercentage | Format-List | Out-String }
            $CPUUsageClient = Get-WmiObject Win32_Processor | Select-Object LoadPercentage | Format-List | Out-String
            clear
            Write-Host "RDS Host CPU Usage: $CPUUsageRDS"
            Write-Host "Client CPU Usage $CPUUsageClient"
            Write-Host "Starting new Instance"
            ####################
            #Change working dir#
            ####################
            Start-Process -windowstyle hidden -Filepath powershell.exe -WorkingDirectory C:\Users\Administrator\Desktop\RDSScript -ArgumentList "C:\Users\Administrator\Desktop\RDSScript\Sessionscript.ps1 -Adminuser $Adminuser -Adminpassword $Adminpassword -RDShost $RDShost -Password $Password"
            $Check = Get-WmiObject Win32_Process -Filter "Name='powershell.exe' AND CommandLine LIKE '%Sessionscript.ps1%'"
            $temp = $Check | Select-String  -Pattern "Win32"
            Start-Sleep 1
            $CPUUsageRDS = Invoke-command $RDShost -credential $credential -scriptblock {Get-WmiObject Win32_Processor | Select-Object LoadPercentage | Format-List | Out-String }           
            clear
            Write-Host "RDS Host CPU Usage: $CPUUsageRDS"
            Write-Host "Client CPU Usage $CPUUsageClient"
            Write-Host "Cooldown 2 seconds"
            Start-Sleep 1
            
        } while ($temp.count -lt $Sessioncount) 
    }
    else {
        $CPUUsageRDS = Invoke-command $RDShost -credential $credential -scriptblock {Get-WmiObject Win32_Processor | Select-Object LoadPercentage | Format-List | Out-String  }
        $CPUUsageClient = Get-WmiObject Win32_Processor | Select-Object LoadPercentage | Format-List | Out-String
        clear
        Write-Host "RDS Host CPU Usage: $CPUUsageRDS"
        Write-Host "Client CPU Usage $CPUUsageClient"
        Write-Host "Max Sessions reached, waiting"
        Start-Sleep 1       
    }
    
} while ($continue -eq "true")

Write-Host "End"
pause 