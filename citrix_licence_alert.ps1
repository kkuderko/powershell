# this will send alert email when citrix users use up all citrix licences
$LicenceServer = "CITRIX-LICENCE-SERVER"
$LicenceLimit = 169
$LicenceCount = (Get-WmiObject -class "Citrix_GT_License_Pool" -Namespace "root\CitrixLicensing" -ComputerName $LicenceServer | Measure-Object -Property InUseCount -sum).Sum

if ($LicenceCount -gt $LicenceLimit) {
Send-MailMessage -To "admin@yourdomain.org.uk"`
-Subject "Citrix License Usage Alert" `
-Body "Current Citrix licence usage on $LicenceServer is $LicenceCount out of $LicenceLimit`n" `
-SmtpServer "SMTPSERVER" `
-From "CITRIX-LICENCE-SERVER@yourdomain.co.uk"
}
