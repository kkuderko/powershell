# list all exchange 365 admins and their roles
#Get-RoleGroup | foreach {Get-RoleGroupMember -Identity $_.Name | Format-Table -Auto $_.Name, Name}
$role = Get-RoleGroup | select Name
foreach ($Group in $role){
$Name = $group.name
$Admin = Get-RoleGroupMember -Identity $name | select PrimarySmtpAddress | Out-String
Write-Output $Name
Write-Output $Admin
}