# list all Azure AD non guest users
$users = Get-MsolUser -All
foreach ($user in $users){
if ($user.UserType -ne "Guest")
{
Write-Host $user.UserPrincipalName
}
}