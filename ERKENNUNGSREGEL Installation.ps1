#Zu suchendes Programm. Achtung: CASE SENSITIVE
$Name = "Printix"
$result = (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | findstr.exe $Name)

if ($result.Length -ge "1" ){
#installiert
exit 0
}else{
#nicht installiert
exit 1
}
