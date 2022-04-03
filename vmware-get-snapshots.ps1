# list VMware snapshots and sizes
#Install-Module -Name VMware.PowerCLI
#Set-PowerCLIConfiguration -Scope User -InvalidCertificateAction warn
#$VIServer = "vcenterserver.yourdomain.co.uk"
#Connect-VIServer $VIServer -Credential (Get-Credential) | Out-Null

$Snaphots = Get-VM | Get-Snapshot
$Snaphots | Sort-Object -Descending -Property SizeGB | Select VM,Name,@{Label="Size";Expression={"{0:N2} GB" -f ($_.SizeGB)}},Created,PowerState,Description | Format-Table -Autosize
$TotalSize = [math]::Round(($Snaphots | Measure-Object -Property SizeGB -sum).sum,2)
Write-Host "Total Snaphots:" ($Snaphots).count"|" "Total Size:" $TotalSize "GB" -ForegroundColor Yellow
