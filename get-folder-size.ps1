# list subfolder sizes
$startDirectory = 'F:\profiles'
$directoryItems = Get-ChildItem $startDirectory | Where-Object {$_.PSIsContainer -eq $true} | Sort-Object 
foreach ($i in $directoryItems)
{
    $subFolderItems = Get-ChildItem $i.FullName -recurse -force | Where-Object {$_.PSIsContainer -eq $false} | Measure-Object -property Length -sum | Select-Object Sum
    $i.FullName + "`t" + "{0:N2}" -f ($subFolderItems.sum / 1GB)
}