#
# Load required assemblies
#
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [System.Reflection.Assembly]::LoadWithPartialName("PresentationFramework")	

#
# Set Wallpaper
#
$wallpaper = Join-Path -Path $PSScriptRoot -ChildPath 'Doro_FullHD.png'

$SPI_SETDESKWALLPAPER  = 0x14;
$SPI_SETDESKWALLPAPER  = 0x14;
$SPIF_UPDATEINIFILE    = 0x01;
$SPIF_SENDWININICHANGE = 0x02;
    
$tmp = '[DllImport("user32.dll")] public static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);'
$SystemParametersInfo = Add-Type -MemberDefinition $tmp -name Win32SystemParametersInfoW -namespace Win32Functions -PassThru

$SystemParametersInfo::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $wallpaper, $SPIF_UPDATEINIFILE -or $SPIF_SENDWININICHANGE);
