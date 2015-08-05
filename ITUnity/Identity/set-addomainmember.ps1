#  Script to join a Windows Server to an Active Directory Domain
$filename = "set-addomainmember.ps1"
$version = "v1.7 updated on 08/5/2015"
#  Jason Himmelstein
#  http://www.sharepointlonghorn.com

#Display the file name & version
Write-host "$filename $version" -BackgroundColor Black -ForegroundColor Yellow
""
$dDomainNetBIOS = "bobsburgers"

Write-host "This script will check for & add this computer to an Active Directory Domain" -ForegroundColor Yellow -BackgroundColor DarkGray
$dCheck = Read-Host -Prompt "Type anything to proceed or Press Enter to cancel this operation"
If ($dCheck -eq ""){write-host "Installation cancelled. Ending script." -ForegroundColor Red -BackgroundColor Black; break}

$DomainNetBIOS = Read-Host -Prompt "Enter the NetBIOS name for the domain you want to join. Press Enter for $dDomainNetBIOS"
If ($DomainNetBIOS -eq "") {$DomainNetBIOS = $dDomainNetBIOS}

Add-Computer -DomainName $DomainNetBIOS 

# Reboot the server
Write-Host "A Reboot is required at this time. Please save your work and confirm." -foregroundcolor green -backgroundcolor black
Start-Sleep -s 5
Restart-Computer -confirm