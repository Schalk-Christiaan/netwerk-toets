# netwerk-toets

Toets of BUTT-afkoppelings saamval met ISP-failover (IP-verandering), pakkieverlies of 'n tweede BUTT-instansie.

## Gebruik (Windows 11)

```powershell
git clone https://github.com/Schalk-Christiaan/netwerk-toets.git
cd netwerk-toets
powershell -ExecutionPolicy Bypass -File .\monitor.ps1 -Target <radio.co-host>
```

- `-Target`: die host uit BUTT se Server-instelling. As dit dadelik `PING VERLORE` wys en so bly, blokkeer die host ICMP: gebruik `-Target 1.1.1.1`.
- Laat die venster 24 uur oop. Stop met Ctrl+C.
- Opdateer: `git pull`.

## Log

`netwerk-log.txt` langs die script, net veranderinge met tydstempel:

| Reël | Beteken |
|---|---|
| `IP a -> b` | Publieke IP het verander (failover het geskakel) |
| `PING VERLORE` / `PING herstel` | Pakkieverlies na die teiken |
| `BUTT-instansies: 1 -> 2` | 'n Tweede BUTT-proses het begin |

## Lees die resultaat

Vergelyk die tydstempels met BUTT se log (Settings → Main → logfile) en die router se WAN-failover-log.

| Wat jy sien | Gevolgtrekking |
|---|---|
| Elke afkoppeling val saam met 'n IP-verandering | Failover is die oorsaak |
| Afkoppelings met ping-verlies, IP bly dieselfde | Onstabiele lyn |
| Afkoppelings, maar geen IP-verandering of verlies | Twee BUTT-instansies, CPU, of radio.co-kant |
| IP verander, BUTT bly gekoppel | Failover is nie die oorsaak nie |
