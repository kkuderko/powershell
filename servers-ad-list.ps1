# list all AD servers
Get-ADComputer -Server YOURDC -Filter '(operatingsystem -like "*server*") -and (enabled -eq "true")' -Properties Name,Operatingsystem,IPv4Address |
Sort-Object -Property IPv4Address, Name -Descending |
Select-Object -Property Name,Operatingsystem,IPv4Address |
Format-Table -AutoSize