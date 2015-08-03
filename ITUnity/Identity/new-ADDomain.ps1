# Script to create Active Directory Domain
# v2.4  8/21/2013
# Created by Jason Himmelstein
# http://www.sharepointlonghorn.com

Write-host "This script will check for & add the Active Directory Domain Services to this computer if it is not found" -ForegroundColor Yellow -BackgroundColor DarkGray
$dCheck = Read-Host -Prompt "Type anything to proceed or Press Enter to cancel this operation"
If ($dCheck -eq ""){write-host "Installation cancelled. Ending script." -ForegroundColor Red -BackgroundColor Black; break}

Add-WindowsFeature AD-Domain-Services -IncludeManagementTools

# Add the Active Directory Deployment bits and not complain if they're already there
Import-Module ADDSDeployment -EA 0

Write-host "This script will create an Active Directory Domain in Win2012 mode and store the log files, database, & Sysvol at the default locations. This will install ADDNS and not set delegation of DNS. If you want these additional options please modify the PowerShell script or run the Install Wizard." -ForegroundColor Yellow -BackgroundColor DarkGray

Write-host ""

Write-host "Please set the following variables" -ForegroundColor Yellow -BackgroundColor DarkGray

$dDomainName = 'jhtkfun.com'
$dDomainNetBIOS = 'jhtkfun' 

$DomainName = Read-Host -Prompt "
Enter the FQDN for the domain you want to create. Press Enter for $dDomainName"
If ($DomainName -eq "") {$DomainName = $dDomainName}

$DomainNetBIOS = Read-Host -Prompt "
Enter the NetBIOS name for the domain you want to create. Press Enter for $dDomainNetBIOS"
If ($DomainNetBIOS -eq "") {$DomainNetBIOS = $dDomainNetBIOS}

Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "Win2012" `
-DomainName $DomainName `
-DomainNetbiosName $DomainNetBIOS `
-ForestMode "Win2012" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$true `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true

# Reboot the server
Write-Host "A Reboot is required at this time. Please save your work and confirm." -foregroundcolor green -backgroundcolor black
Start-Sleep -s 5
Restart-Computer -confirm