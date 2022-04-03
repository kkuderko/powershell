# list firewall status on AD servers
#$servers = Get-ADComputer -Filter '(operatingsystem -like "*server*") -and (enabled -eq "true")' -Properties Name | Select-Object -Property Name
#$ErrorActionPreference = 'silentlycontinue'
$OU = "OU=Backup Servers,OU=SERVERACCOUNTS,DC=yourdomain,DC=co,DC=uk"
$ComputerList = Get-ADComputer -Server YOURDC -Filter * -SearchBase "$OU" | Select Name
foreach ($Computer in $ComputerList) {
	Write-Host -NoNewline $Computer.Name "... "
	Get-WMIObject win32_service -filter "name='MpsSvc'" -computer $Computer.Name | select -expand startMode
	Write-Host
}