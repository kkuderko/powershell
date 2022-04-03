# export list of disabled users
$OU = "OU=USERACCOUNTS,DC=yourdomain,DC=co,DC=uk"
Get-ADUser -Server YOURDC -Filter 'Enabled -eq $false' -SearchBase "$OU" -Properties * | Select-Object DistinguishedName, Modified, PasswordExpired, PasswordLastSet, LastLogonDate, AccountExpirationDate | Export-Csv disabled-users.csv
