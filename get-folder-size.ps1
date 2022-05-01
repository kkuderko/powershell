$startDirectory = 'F:\profiles'
$totalSize = 0
# list files
Get-ChildItem -Path $startDirectory -Recurse -File | Sort-Object Length -Descending | Select-Object Name,@{Name="GB";Expression={"{0:N0}" -f ($_.Length / 1GB) }},LastWriteTime
# calculate total size
$directoryItems = Get-ChildItem $startDirectory | Where-Object {$_.PSIsContainer -eq $true} | Sort-Object 
foreach ($i in $directoryItems)
{
    $subFolderItems = Get-ChildItem $i.FullName -recurse -force | Where-Object {$_.PSIsContainer -eq $false} | Measure-Object -property Length -sum | Select-Object Sum
    $totalSize += "{0:N2}" -f ($subFolderItems.sum / 1GB)
}
$totalSize = ("{0:f2}" -f $totalSize)
Write-Output "`nTotal Size of the $startDirectory folder: $totalSize GB"