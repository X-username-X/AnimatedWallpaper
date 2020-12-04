#
# Start the animated wallpaper automatically
#
$name = 'AnimatedWallpaper'
$path = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
$command =  $PsHome + '\powershell.exe -ExecutionPolicy Bypass -NoProfile -File "' + $PWD + '\AnimatedWallpaper.ps1" -f "' + $PWD + '"'

$test = Get-Item $path
If ($test.GetValue($name) -ne $command) {
    New-ItemProperty -Path $path –Name $name -Value $command -Force | Out-Null
    Write-Output 'Added AnimatedWallpaper to automatic startup'
}
Else
{
    Remove-ItemProperty -Path $path –Name $name | Out-Null
    Write-Output INFO:
    Write-Output 'Removed AnimatedWallpaper from automatic startup'
}


