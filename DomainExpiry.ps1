#example .\DomainExpiry.ps1 rg.bm whois.asaplatform.info
#example .\DomainExpiry.ps1 google.com
#whois.exe from Microsoft https://learn.microsoft.com/en-us/sysinternals/downloads/whois
<#
PRTG parameters syntax
%host
#>

Param(
  [Parameter(Mandatory=$true)]
  [string]$domain,
  [string]$whoisserveroveride
)

$Command = "C:\Program Files (x86)\PRTG Network Monitor\Custom Sensors\EXEXML\whois.exe"
$Parms = "/accepteula $domain $whoisserveroveride"
$expirationtextsearch1 = "Registrar Registration Expiration Date: "
$expirationtextsearch2 = "Registry Expiry Date: "
$expirationtextsearch3 = "Expiry Date: "
$Prms = $Parms.Split(" ")
$whoisoutput = (& "$Command" $Prms) 
$datestring = Get-Date

$expirationresult = $whoisoutput | % { if($_ -match $expirationtextsearch1) {$_}}


if ($expirationresult -eq $null) {
  $expirationresult = $whoisoutput | % { if($_ -match $expirationtextsearch2) {$_}}
  if ($expirationresult -eq $null) {
    $expirationresult = $whoisoutput | % { if($_ -match $expirationtextsearch3) {$_}}
    # remove leading spaces
    $expirationresultNoSpaces = $expirationresult -replace '\s+', ' '
    $datestring = $expirationresultNoSpaces.Substring($expirationtextsearch3.Length)
  } else {
  # remove leading spaces
  $expirationresultNoSpaces = $expirationresult -replace '\s+', ' '
  $datestring = $expirationresultNoSpaces.Substring($expirationtextsearch2.Length)
  }
} else {
  # remove leading spaces
  $expirationresultNoSpaces = $expirationresult -replace '\s+', ' '
  $datestring = $expirationresultNoSpaces.Substring($expirationtextsearch1.Length)
}

$datestring = $datestring.Split([Environment]::NewLine) | Select -First 1
$expiredate = Get-Date $datestring
$daystoexpire = ($expiredate - (Get-Date)).Days

# sensor XML format
$XMLResult = @"
<prtg>
 <result>
  <channel>Days to Expiry</channel>
  <value>$daystoexpire</value>
  <unit>Custom</unit>
  <customUnit>days</customUnit>
  <mode>Absolute</mode>
  <LimitMinError>7</LimitMinError>
  <LimitMinWarning>14</LimitMinWarning>
  <LimitMode>1</LimitMode>
 </result>
 <text>The $domain domain registration expires in $daystoexpire days</text>
</prtg>
"@

# display output
Write-Host $XMLResult