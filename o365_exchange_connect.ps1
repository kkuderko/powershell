#Set-ExecutionPolicy RemoteSigned
#Install-Module -Name ExchangeOnlineManagement
#$UserCredential = Get-Credential -Credential your.admin@yourdomain.onmicrosoft.com
#$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
#Import-PSSession $Session -DisableNameChecking

#Connect-EXOPSSession -UserPrincipalName your.admin@yourdomain.onmicrosoft.com

Connect-ExchangeOnline -UserPrincipalName your.admin@yourdomain.onmicrosoft.com -ShowProgress $true
Get-MessageTrace -SenderAddress your.admin@yourdomain.com -StartDate (Get-Date).AddHours(-8) -EndDate (Get-Date) | Format-Table
Write-Host " "
Write-Host "Don't forget to disconnect the session!: Get-PSSession | Remove-PSSession"