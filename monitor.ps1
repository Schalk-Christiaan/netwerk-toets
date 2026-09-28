# Netwerk-toets: log publieke IP-verandering, pakkieverlies na radio.co en aantal BUTT-instansies.
# Gebruik: powershell -ExecutionPolicy Bypass -File .\monitor.ps1 -Target <radio.co-host>
# Log: netwerk-log.txt langs die script. Stop met Ctrl+C.
param([Parameter(Mandatory)][string]$Target)

$log = Join-Path $PSScriptRoot "netwerk-log.txt"
function Log($m) {
    $line = "{0}  {1}" -f (Get-Date -f 'yyyy-MM-dd HH:mm:ss'), $m
    Write-Host $line
    Add-Content $log $line
}

$ping = New-Object System.Net.NetworkInformation.Ping
$ip = $null; $up = $true; $butt = -1; $tick = 0
Log "START target=$Target"

while ($true) {
    # pakkieverlies: elke sekonde, log net oorgange
    try { $ok = $ping.Send($Target, 1000).Status -eq 'Success' } catch { $ok = $false }
    if ($ok -ne $up) { $up = $ok; Log ("PING " + $(if ($up) { "herstel" } else { "VERLORE" })) }

    # IP en BUTT-instansies: elke 5 sekondes, log net veranderinge
    if ($tick % 5 -eq 0) {
        try { $now = Invoke-RestMethod https://api.ipify.org -TimeoutSec 2 } catch { $now = "FAIL" }
        if ($now -ne $ip) {
            # ISP-naam net opgesoek wanneer die IP verander (ipinfo se gratis limiet)
            try { $org = (Invoke-RestMethod "https://ipinfo.io/$now/org" -TimeoutSec 3).Trim() } catch { $org = "?" }
            Log "IP $ip -> $now  [$org]"; $ip = $now
        }
        $n = @(Get-Process butt -ErrorAction SilentlyContinue).Count
        if ($n -ne $butt) { Log "BUTT-instansies: $butt -> $n"; $butt = $n }
    }
    $tick++
    Start-Sleep 1
}
