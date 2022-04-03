#Find out shared mailboxes that are licensed
Get-Mailbox -ResultSize Unlimited -RecipientTypeDetails SharedMailbox | Get-MsolUser | Where-Object { $_.isLicensed -eq "TRUE" }
