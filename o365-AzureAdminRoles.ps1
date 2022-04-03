# prin all Azure admins and their roles
$RolesCollection = @()
$Roles = Get-MsolRole
ForEach ($Role In $Roles){
  $Members = Get-MsolRoleMember -RoleObjectId $Role.ObjectId
  ForEach ($Member In $Members) {
    $obj = New-Object PSObject -Property @{
      RoleName = $Role.Name
      MemberName = $Member.EmailAddress
    }
    $RolesCollection += $obj
  }
}
Write-Output $RolesCollection | Sort-Object RoleName,MemberName | ft RoleName,MemberName 
