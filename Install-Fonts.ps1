<#  Install-Fonts 3.0
    Place Fonts in the 'Fonts' subfolder of the script folder
    
      *** CURRENTLY ONLY SUPPORTS ***
    TrueType FONTS (.TTF EXTENSION)
    
    Script uses the extended file attributes "Title" and "Type" to create the required registry key
    -Details on finding extended file attibutes are here: https://stackoverflow.com/questions/9420055/enumerate-file-properties-in-powershell
    -And here for more details: http://web.archive.org/web/20160201231836/http://powershell.com/cs/blogs/tobias/archive/2011/01/07/organizing-videos-and-music.aspx
    Script uses the extended file attribute "Type" to determine font type and sets the $FontType Variable
    -Note this currently requires coding to add additional font types.
    The string ' (TrueType)' is appended to the file "Title" to properly format the registry key
    A reboot is required for the added Font(s) to be available
    Peter McDaniel, Olenick and Associates, 08.12.2019
#>

$Shell = New-Object -COMObject Shell.Application
$FONTS = "C:\Windows\Fonts"
ForEach($File in $(Get-ChildItem -Path "\\yourdomain.co.uk\sysvol\yourdomain.co.uk\scripts\Fonts\")){
    If (Test-Path "C:\Windows\Fonts\$($File.name)")
    { }
    Else
    {
$Path = $File.FullName
$Folder = Split-Path $Path
$File = Split-Path $Path -Leaf
$ShellFolder = $Shell.Namespace($Folder)
$ShellFile = $ShellFolder.ParseName($File)
$ExtAtt2 = $ShellFolder.GetDetailsOf($ShellFile, 2)

#Set the $FontType Variable
  If ($ExtAtt2 -Like '*TrueType font file*') {$FontType = '(TrueType)'}

$ExtAtt21 = $ShellFolder.GetDetailsOf($ShellFile, 21) + ' ' + $FontType
New-ItemProperty -Name $ExtAtt21 -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType string -Value $File -Force
Copy-item $Path -Destination $FONTS
    }
}