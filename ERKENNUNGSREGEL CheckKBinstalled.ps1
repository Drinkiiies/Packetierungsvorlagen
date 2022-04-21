$result = systeminfo.exe | findstr.exe KB5005565

if ($result)
 {
    Write-Output "Found KB5005565"
    exit 0
 }
 else
 {
    exit 1
 }