# list servers with disabled Windows update service
$ErrorActionPreference = 'silentlycontinue'
$OU = "OU=SERVERACCOUNTS,DC=yourdomain,DC=co,DC=uk"
$ComputerList = Get-ADComputer -Filter * -SearchBase "$OU" | Select Name
foreach ($Computer in $ComputerList) {
	Write-Host -NoNewline $Computer.Name "... "
	Get-WMIObject win32_service -filter "name='wuauserv'" -computer $Computer.Name | select -expand startMode
	Write-Host
}
