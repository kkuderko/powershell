# produce MFA disabled users status report and send via email

$credObject = Get-AutomationPSCredential -Name 'reporting.admin@yourdomain.onmicrosoft.com'
Connect-MsolService -Credential $credObject

$Result=""
$Results=@()
$UserCount=0
$PrintedUser=0

#Output file declaration
$ExportDisabledCSV=".\M365DisabledMFAReport_$((Get-Date -format 'yyyy-MM-ddTHH-mm-ss').ToString()).csv"

#Loop through each user
Get-MsolUser -All | foreach{
 $UserCount++
 $UserType=$_.UserType
 $DisplayName=$_.DisplayName
 $Upn=$_.UserPrincipalName
 $MFAStatus=$_.StrongAuthenticationRequirements.State
 $MethodTypes=$_.StrongAuthenticationMethods
 $RolesAssigned=""
# Write-Progress -Activity "`n     Processed user count: $UserCount "`n"  Currently Processing: $DisplayName"
 if($_.BlockCredential -eq "True")
 {
  $SignInStatus="False"
  $SignInStat="Denied"
 }
 else
 {
  $SignInStatus="True"
  $SignInStat="Allowed"
 }

 if($_.IsLicensed -eq $true)
 {
  $LicenseStat="Licensed"
 }
 else
 {
  $LicenseStat="Unlicensed"
 }

 #Check for user's Admin role
 $Roles=(Get-MsolUserRole -UserPrincipalName $upn).Name
 if($Roles.count -eq 0)
 {
  $RolesAssigned="No roles"
  $IsAdmin="False"
 }
 else
 {
  $IsAdmin="True"
  foreach($Role in $Roles)
  {
   $RolesAssigned=$RolesAssigned+$Role
   if($Roles.indexof($role) -lt (($Roles.count)-1))
   {
    $RolesAssigned=$RolesAssigned+","
   }
  }
 }

 #Check for MFA disabled user
 if(($MFAStatus -eq $Null) -and ($_.StrongAuthenticationMethods.MethodType -eq $Null) -and ($UserType -ne "Guest"))
 {
  $MFAStatus="Disabled"
  $Department=$_.Department
  if($Department -eq $Null)
  { $Department="-"}
  $PrintedUser++
  $Result=@{'DisplayName'=$DisplayName;'UserPrincipalName'=$upn;'Department'=$Department;'MFAStatus'=$MFAStatus;'LicenseStatus'=$LicenseStat;'IsAdmin'=$IsAdmin;'AdminRoles'=$RolesAssigned; 'SignInStatus'=$SigninStat}
  $Results= New-Object PSObject -Property $Result
  $Results | Select-Object DisplayName,UserPrincipalName,Department,MFAStatus,LicenseStatus,IsAdmin,AdminRoles,SignInStatus | Export-Csv -Path $ExportDisabledCSV -Notype -Append
 }
}
#Send email
$emailFromAddress = "reporting.admin@yourdomain.onmicrosoft.com"
$emailToAddress = "reports@yourdomain.org.uk"
$emailSMTPServer = "yourdomain.mail.protection.outlook.com"
$emailSubject = "Microsoft 365 MFA Report"
$emailBody = "Please find MFA report attached<br><br><small>This is automated report. Please contact IT Servicedesk for support</small><br>"

Send-MailMessage -Credential $credObject -Attachments $ExportDisabledCSV -From $emailFromAddress -To $emailToAddress -Subject $emailSubject -Body $emailBody -BodyAsHtml -SmtpServer $emailSMTPServer -UseSSL

#Clean up session
Remove-Item $ExportDisabledCSV
#Get-PSSession | Remove-PSSession