<#PSScriptInfo
.VERSION
    1.0
.GUID
    6f7521da-7042-4a7d-8698-912c1ee555cc
.AUTHOR
    Anonymous
.COPYRIGHT
    PUBLIC DOMAIN
.SYNOPSIS
    Animated Wallpaper for Windows 10 with PowerShell featuring Doro Pesch.
    Example: powershell.exe .\AnimatedWallpaper
.DESCRIPTION 
    Animated Wallpaper for Windows 10 with PowerShell featuring Doro Pesch.
    
    It rotates over three different images and sets these as background.
    After logout the effect is gone, and the standard wallpapcer is back.
.EXAMPLE
    powershell.exe .\AnimatedWallpaper
#>
#
# Load required assemblies
#
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [System.Reflection.Assembly]::LoadWithPartialName("PresentationFramework")	

#
# wallpapers
#
$wallpaper1 = Join-Path -Path $PSScriptRoot -ChildPath 'Doro_FullHD.png'    #original
$wallpaper2 = Join-Path -Path $PSScriptRoot -ChildPath 'Doro_FullHD_A.png'  #big smile (faceapp)
$wallpaper3 = Join-Path -Path $PSScriptRoot -ChildPath 'Doro_FullHD_B.png'  #extra big smile (faceapp)

#
# Set the systray icon
#
$iconb64 = 'R0lGODlhGAAYAHAAACwAAAAAGAAYAIYAAAABAQEREREiIiI2NjYCAgImJiYrKysnJycFBQUXFxcJCQk1NTU5OTlOTk5QUFBUVFRkZGRTU1MzMzM6OjoyMjIWFhYoKChDQ0NLS0tNTU1cXFxMTExAQEA4ODgSEhI7Ozs8PDxISEhWVlZlZWVdXV1bW1tGRkZBQUE0NDQuLi4jIyMcHBwxMTFYWFhhYWFtbW09PT0LCwsEBAQICAhKSkpqamodHR1mZmYUFBQGBgYYGBgNDQ0KCgp3d3dwcHADAwMwMDAqKipEREQvLy8HBwdZWVkPDw8hISE/Pz9FRUVCQkJoaGhXV1dgYGBfX18pKSk3NzcMDAxpaWkVFRU+Pj4aGhpSUlIgICAkJCQODg4tLS1RUVEZGRksLCwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH/4AAgoOEhYaHiImKAYqNAgMEBQYHCAkKC42DDA0ODxAREhMUFRaMjRcYGRoRERsQHB0eH6aJFiAhIiMkJSYjJygpKgqJCSseLC0hJy4vMCYaHTEItIUyCDMApjM0NTYSGCcT2JkzBYIzNzgQDzUoOYg6Ozw9Ah+EKD4+Pz8oh0AsDDwEEcKDUJAXOGD88CCImg4PQ0IQIEKryIgMLoxIOCIICSEgSZQkWeKBVgIbTJq0MzXgY4MkGJQEATLIgAgbTp40MAcACqEARDp0wBBFiqAeEzCEGDElSYEAUJYUohKjQZUqF2hYMcAgVowOUQDwuAKDUAIsMQhEAREESooYSV86TCBAYIegLEwI7YgSJEiDFB46UOgwBMWSKloGbeFCqIiQYBUYRPHAYLDcIowC0CByolAXL0SIBKngNwUSLAkGLRiQgsLPIzwSCGBxQweNHjpoDtLRI4HRn5mCCx8UCAA7'
$bitmap = [Drawing.Bitmap]::FromStream([IO.MemoryStream][Convert]::FromBase64String($iconb64))
$icon = [System.Drawing.Icon]::FromHandle($bitmap.GetHicon())

#
# Add the systray icon with info and exit
#
$systrayIcon = New-Object System.Windows.Forms.NotifyIcon
$systrayIcon.Text = 'DORO'
$systrayIcon.Icon = $icon
$systrayIcon.Visible = $true

$menuExit = New-Object System.Windows.Forms.MenuItem
$menuExit.Text = 'Exit'

$contextmenu = New-Object System.Windows.Forms.ContextMenu
$systrayIcon.ContextMenu = $contextmenu
$systrayIcon.contextMenu.MenuItems.AddRange($menuExit)

$systrayIcon.add_Click({
    if ($_.Button -eq [System.Windows.Forms.MouseButtons]::Left) {
        #[System.Windows.Forms.MessageBox]::Show("Info`n`nUsed CPU Time:`n" +  $info.UserProcessorTime + "`nhh:mm:ss:milli", "⚡ Animated Wallpaper", 0)
        [System.Windows.Forms.MessageBox]::Show("    Happy Metal`n        rules`n     the world! `n`n❤️ DOROMETALQUEEN ❤️", "⚡ Animated Wallpaper", 0)
    }
})

$menuExit.add_Click({
    $systrayIcon.Visible = $false
    Stop-Job -Job $jobid | Out-Null
	Stop-Process $pid | Out-Null
 })

#
# Wallpaper changer
# 
$scriptblock = {
    $SPI_SETDESKWALLPAPER  = 0x14;
    $SPIF_SENDWININICHANGE = 0x02;
    
    $tmp = '[DllImport("user32.dll")] public static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);'
    $SystemParametersInfo = Add-Type -MemberDefinition $tmp -name Win32SystemParametersInfoW -namespace Win32Functions -PassThru

    While ($true) {
        $SystemParametersInfo::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $args[0], $SPIF_SENDWININICHANGE);
        Sleep 5
        $SystemParametersInfo::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $args[1], $SPIF_SENDWININICHANGE);
        Sleep 3
        $SystemParametersInfo::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $args[2], $SPIF_SENDWININICHANGE);
        Sleep 0.8
        $SystemParametersInfo::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $args[1], $SPIF_SENDWININICHANGE);
        Sleep 1.2
    }
}
$jobid = Start-Job -ScriptBlock $scriptblock -ArgumentList $wallpaper1, $wallpaper2, $wallpaper3
 
#
# Hide the PowerShell window
#
$SW_HIDE = 0x00
$tmp = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync (IntPtr hWnd, int nCmdShow);'
$ShowWindowAsync = Add-Type -MemberDefinition $tmp -name Win32ShowWindowAsync -namespace Win32Functions -PassThru
$ShowWindowAsync::ShowWindowAsync((Get-Process -PID $pid).MainWindowHandle, $SW_HIDE) | Out-Null

#
# Set the window name
#
$tmp = '[DllImport("User32.dll", CharSet = CharSet.Auto)] public static extern bool SetWindowText (IntPtr hWnd, string lpString);'
$SetWindowText = Add-Type -MemberDefinition $tmp -name Win32SetWindowTextA -namespace Win32Functions -PassThru
$SetWindowText::SetWindowText((Get-Process -PID $pid).MainWindowHandle, "Animated Wallpaper") | Out-Null

#
# Minimize all windows
#
$tmp = '[DllImport("user32.dll")] public static extern int FindWindow (string lpClassName, string lpWindowName);'
$FindWindow = Add-Type -MemberDefinition $tmp -name Win32FindWindowA -namespace Win32Functions -PassThru
$hWnd = $FindWindow::FindWindow('Shell_TrayWnd', $null);

$tmp = '[DllImport("user32.dll")] public static extern int PostMessage (int hWnd, int Msg, int wParam, int lParam);'
$PostMessage =  Add-Type -MemberDefinition $tmp -name Win32PostMessage -namespace Win32Functions -PassThru
$PostMessage::PostMessage($hWnd, 0x111, 0x1A3, $null) | Out-Null

#
# Run the GUI message loop
#
$appcontext = New-Object System.Windows.Forms.ApplicationContext
[void][System.Windows.Forms.Application]::Run($appcontext)