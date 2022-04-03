# find servers with specific app installed
$ErrorActionPreference = 'silentlycontinue'
$OU = "OU=XenApp7,OU=SERVERACCOUNTS,DC=yourdomain,DC=co,DC=uk"
$ComputerList = Get-ADComputer -Server YOURDC -Filter * -SearchBase "$OU" | Select Name
foreach ($Computer in $ComputerList) {
	Write-Host -NoNewline $Computer.Name "... "
#	Get-WMIObject win32_service -filter "name='wuauserv'" -computer $Computer.Name | select -expand startMode
	Get-CimInstance -ComputerName $Computer.Name -ClassName win32_product -ErrorAction SilentlyContinue | Select-Object PSComputerName, PackageName | Where-Object {$_.PackageName -like "Mimecast*"}
	Write-Host
}
