<#
 connect to Azure

 Connect-AzAccount
 $context = Get-AzSubscription -SubscriptionId 12345678-1234-1234-1234-123456789012
 Set-AzContext $context

run the script
 .\AzureAVDHostPoolStatus.ps1 -HostPool AVD-HostPool -ResourceGroup AVD-RG
 
 this will display current status and usage of AVD host pool
#>
param ($HostPool,$ResourceGroup)
$AvailableHosts = 0

$AVDHostList = Get-AzWvdSessionHost -ResourceGroupName $ResourceGroup -HostPoolName $HostPool
$TotalAVDHosts = ($AVDHostList).count
$TotalAVDSessions = ($AVDHostList | Select-Object Session | Measure-Object -Property Session -Sum).Sum
$HostPoolSessionLimit = (Get-AzWvdHostPool -ResourceGroupName $ResourceGroup -Name $HostPool).MaxSessionLimit

foreach ($AVDHost in $AVDHostList){
	if ($AVDHost.Status -eq "Available") {
		$AvailableHosts ++
	}
}

if ($AvailableHosts -eq 0){
	$HColour = "DarkRed"
} else {
	$HColour = "DarkGreen"
}
$CurrentSessionLimit = $HostPoolSessionLimit * $AvailableHosts
$SessionCapacityP = [math]::ceiling(($TotalAVDSessions*100)/($CurrentSessionLimit))

$Users = Get-AzWvdUserSession -ResourceGroupName $ResourceGroup -HostPoolName $HostPool | Select-Object UserPrincipalName, Name

Clear-Host
Write-Host "AVD Host Pool Name:" $HostPool -ForegroundColor Blue
Write-Host ($Users | Format-Table -AutoSize | Out-String) -NoNewLine -ForegroundColor DarkGray
Write-Host "AVD Sessions Usage: $($TotalAVDSessions) out of $($CurrentSessionLimit) ($($SessionCapacityP)%)" -ForegroundColor Yellow

Write-Host ($AVDHostList | Select-Object Name,Session,Status | Format-Table -AutoSize | Out-String) -NoNewLine -ForegroundColor DarkGray
Write-Host "AVD Hosts:" $AvailableHosts "available out of" $TotalAVDHosts -ForegroundColor $HColour
Write-Host