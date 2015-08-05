#  Script to prep a Windows Server 
$filename = "new-serverprep.ps1"
$version = "v2.15 updated on 08/5/2015"
#  Jason Himmelstein
#  http://www.sharepointlonghorn.com

#Display the file name & version
Write-host "$filename $version" -BackgroundColor Black -ForegroundColor Yellow
""

#region UAC RDP & IE ESC
# Turn off the pesky UAC prompts that cause issues with SharePoint if left on
Write-Host "INFO: Setting the User Account Control settings to Never Notify" -foregroundcolor Yellow -backgroundcolor black
set-itemproperty -path registry::HKEY_LOCAL_Machine\Software\Microsoft\Windows\CurrentVersion\policies\system -Name EnableLUA -Value 0

#Enable Remote Desktop
Write-Host "INFO: Changing setting to allow Remote Desktop connections to this server" -foregroundcolor Yellow -backgroundcolor black
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name  fDenyTSConnections -Value 0

# Disable the IE Enhanced Security Configuration for Administrators
Write-Host "INFO: Disabling the IE Enhanced Security Configuration for Administrators" -foregroundcolor Yellow -backgroundcolor black
set-itemproperty -path "registry::HKEY_LOCAL_Machine\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" -Name IsInstalled -Value 0
#endregion

#region time
# set the time zone
#Find the syntax to use here: http://technet.microsoft.com/en-us/library/cc749073(v=ws.10).aspx
Write-Host "INFO: Setting the Time Zone & Time Server" -foregroundcolor Yellow -backgroundcolor black
tzutil /s "Central Standard Time"
Set-Location HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers
Set-ItemProperty . 1 "time.nist.gov"
Set-ItemProperty . 2 "time.windows.com"
c:
#endregion

#region powershell modules
# add PowerShell_ISE for Windows Server 2008 R2
Import-Module ServerManager
Add-WindowsFeature PowerShell-ISE
#endregion

#region DNS
# Set the DNS entry to connect this server to an Active Directory Domain
$dc = Read-Host "what is the IPAddress of the domain controller for the domain that you are trying to join?"
$nic = Get-DnsClientServerAddress | out-gridview -outputmode Single -title "which interface do you want to assign the DNS to"
write-host "INFO: The old DNS server entry for "$nic.InterfaceAlias" is:" -foregroundcolor Yellow -backgroundcolor black
$list1 = Get-DnsClientServerAddress | Where-Object {$_.InterfaceAlias-eq $nic.InterfaceAlias}
$list1 | Select-Object InterfaceAlias,ServerAddresses
""
write-host "INFO: Setting the DNS server entries" -foregroundcolor Yellow -backgroundcolor black
""
Set-DnsClientServerAddress -InterfaceAlias $nic.InterfaceAlias -ServerAddresses ("$dc")
write-host "INFO: The new DNS server entry for "$nic.InterfaceAlias" is now:" -foregroundcolor Yellow -backgroundcolor black
$list2 = Get-DnsClientServerAddress | Where-Object {$_.InterfaceAlias-eq $nic.InterfaceAlias}
$list2
#endregion 

#region server name change
Write-Host "INFO: Change the server name" -foregroundcolor Yellow -backgroundcolor black
$ServerName = Read-Host -Prompt "Enter the new Server Name for this machine. The current machine name is $env:ComputerName. Simply enter if you do not wish to change this Server's name"
If ($ServerName -ne "") {Rename-Computer $ServerName}
#endregion

#region reboot
# Reboot the server
Write-Host "A Reboot is required to complete these changes" -foregroundcolor green -backgroundcolor black
Start-Sleep -s 5
Restart-Computer -confirm
#endregion