# list users and their properties in selected OU

$ErrorActionPreference = 'silentlycontinue'
$OU = "OU=USERACCOUNTS,DC=yourdomain,DC=co,DC=uk"
#$UserList = Get-ADUser -Server YOURDC -Filter * -SearchBase "$OU" -Properties DistinguishedName, office | Select DistinguishedName, office | Export-Csv out.csv
$UserList = Get-ADUser -Server YOURDC -Filter 'enabled -eq $true' -SearchBase "$OU" -Properties Name, mail, title, department, DistinguishedName | Select Name, mail, title, department, DistinguishedName | Export-Csv AD-UserList.csv


#foreach ($User in $UserList) {
#	Write-Host -NoNewline $User.DistinguishedName "..." $User.office
#	Write-Host
#}

#Get-ADGroupMember -Server YOURDC 'ADGROUP' | Get-ADUser -Properties ('State','mail') | Select-Object State,mail

# all enabled users in ADGROUP group (use: | measure to count)
#Get-ADGroupMember -Server YOURDC 'ADGROUP' | Get-ADUser -Properties ('GivenName','Surname','Name','mail','Enabled') | Select-Object GivenName,Surname,Name,mail,Enabled | Where Enabled -eq "True"| Export-Csv AD-Users.csv

#Get-ADGroupMember 'ADGROUP' | Get-ADUser -Properties ('office','DistinguishedName') | Select-Object office,DistinguishedName
 