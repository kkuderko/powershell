# list servers uptime
$ErrorActionPreference = 'silentlycontinue'

#$OU = "OU=SERVERACCOUNTS,DC=yourdomain,DC=co,DC=uk"
$OU = "OU=XenApp7,OU=SERVERACCOUNTS,DC=yourdomain,DC=co,DC=uk"
$ComputerList = Get-ADComputer -Filter * -SearchBase "$OU" | Select Name
#foreach ($Computer in $ComputerList) {(Get-Date) - (Get-CimInstance Win32_OperatingSystem -ComputerName $($Computer).Name).LastBootupTime  | Select-Object -Property @{Name = 'Computer'; Expression = {($Computer).Name}},Days,Hours,Minutes | Format-Table -AutoSize}

Write-Host "ComputerName","`t`t","Days","`t","Hours","`t","Minutes"
foreach ($Computer in $ComputerList) {
	$LastBoot = (Get-CimInstance Win32_OperatingSystem -ComputerName $($Computer).Name).LastBootupTime
	if ($LastBoot){
		$UptimeD = ((Get-Date) - $LastBoot).Days
		$UptimeH = ((Get-Date) - $LastBoot).Hours
		$UptimeM = ((Get-Date) - $LastBoot).Minutes
		#$Uptime | Select-Object -Property @{Name = 'Computer'; Expression = {($Computer).Name}},Days,Hours,Minutes | Format-Table -AutoSize
	} else {
		$UptimeD = " "
		$UptimeH = " "
		$UptimeM = " "
	}
	Write-Host ($Computer).Name,"`t`t",$UptimeD,"`t",$UptimeH,"`t",$UptimeM
}
