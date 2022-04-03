#Set-ExecutionPolicy RemoteSigned
#Install-Module MSOnline
$UserCredential = Get-Credential -Credential your.admin@yourdomain.onmicrosoft.com

Connect-MsolService -Credential $UserCredential
Get-MsolCompanyInformation
Write-Host " "
Write-Host "Don't forget to disconnect the session!: Get-PSSession | Remove-PSSession"