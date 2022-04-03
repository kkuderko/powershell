# list AD group members
#Get-ADGroup -Server YOURDC -Filter '(name -like "*citrix*")' -Properties Name | Select-Object Name
#$group = get-adgroup -server YOURDC -Identity "AD Group" | select –ExpandProperty distinguishedname
#Get-ADObject -server YOURDC -filter * –Properties memberof,name,mail | where {$group -contains $_.memberof} | select name,mail | Format-Table -Auto
Get-ADGroup -Server YOURDC -Identity 'AD Group' -Properties members | Select-Object -ExpandProperty members | Measure-Object
