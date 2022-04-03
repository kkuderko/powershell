# TOTAL SIZE OF MAILBOXES
((get-exomailbox -ResultSize Unlimited | get-exomailboxstatistics).TotalItemSize.Value.ToMB() | measure-object -sum).sum

# LIST OUTLOOK RULES
Get-InboxRule -Mailbox user1@yourdomain.com | Select Name, Description | FL

# MAILBOX FOLDER SIZES
Get-MailboxFolderStatistics user1@yourdomain.com | Select Name,FolderSize,ItemsinFolder

# WHO'S GOT FULL ACCESS PERMISSIONS
Get-MailboxPermission -Identity user1@yourdomain.com | where {($_.IsInherited -eq $false)} | Format-Table -AutoSize
Get-MailboxPermission -Identity puser1@yourdomain.com | where {($_.AccessRights -eq "FullAccess")  -and ($_.IsInherited -eq $false)} | Select User

# WHO'S GOT SEND AS PERMISSIONS
Get-Mailbox -identity Mailbox1 | Get-ADPermission | where {($_.ExtendedRights -like "*Send-As*") -and ($_.IsInherited -eq $false) -and -not ($_.User -like "NT AUTHORITY\SELF")} | Select User

# WHO'S GOT SEND ON BEHALF
Get-Mailbox Mailbox1 -resultsize unlimited | Where {$_.GrantSendOnBehalfTo -ne $null} | format-list Alias, GrantSendOnBehalfTo > SendOnBehalf.txt

# WHICH MAILBOXES THE USER1 HAS FULL RIGHTS TO
ForEach ($mbx in (Get-Mailbox -Resultsize Unlimited | Select Identity)) {Get-MailboxPermission $mbx.Identity -User user1@yourdomain.com | ? {$_.AccessRights -match "FullAccess" -and $_.IsInherited -eq $False} | Select Identity} 

# ADD FULL RIGHTS WITHOUT AUTO MAPPING
Add-MailboxPermission -Identity someones_mailbox -User 'User Name' -AccessRights FullAccess -InheritanceType All -Automapping $false
Add-MailboxPermission shared1@yourdomain.com  -AccessRights FullAccess -User user1@yourdomain.com -AutoMapping $False

# REMOVE Test2's FULL ACCESS RIGHTS TO Test1's MAILBOX
Remove-MailboxPermission -Identity Test1 -User Test2 -AccessRights FullAccess -InheritanceType All
Remove-MailboxPermission -Identity shared1@yourdomain.com -User user1@yourdomain.com -AccessRights FullAccess -InheritanceType All


# EXAMPLES
Get-MailboxPermission -Identity shared1@yourdomain.com  | where {($_.IsInherited -eq $false)} | Format-Table -AutoSize
Remove-MailboxPermission -Identity hared1@yourdomain.com -User S-1-5-21-1055359317-2347530276-3947479235-1234567 -AccessRights FullAccess -Confirm:$false
