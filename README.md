# eth0_watchdog für den Raspberry Pi
Aufgrund eines Bugs, wird die Netzwerkkarte des Raspberry Pi 2 nicht neu initialisiert, wenn der Link temporär ausfällt. Mit einem Script kann die Netzwerkkarte jedoch regelmäßig neu initialisiert werden, wenn der Link ausfällt, solange bis die Netzwerkverbindung wieder hergestellt wurde.

## Funktionsweise
Das Script eth0_watchdog.sh wird per `systemd` beim Systemstart ausgeführt und prüft alle 30 Sekunden, ob dem Interface `eth0` noch eine IP-Adresse zugeordet ist und das Default Gateway noch per Ping erreichbar ist. Falls eine dieser Checks fehlschlägt wird per `ip link set eth0 down` und `up` das Interface herunter und wieder hoch gefahren, so dass eine erneute Initialisierung durch den Netzwerkmanager (bei Raspberry OS standardmäßig dhcpcd) erzwungen wird.

## Installation

```
# 1. install in /opt
cd /opt

# 2. clone project
git clone https://github.com/nerdiges/eth0_watchdog.git

# 3. Copy service file for systemd
cp eth0_watchdog.service /etc/systemd/system/eth0_watchdog.service

# 4. Reload systemd to integrate script
systemctl daemon-reload

# 5. Start service
systemctl start eth0_watchdog.service

# 6. Check if service is running
systemctl status eth0_watchdog.service

# 7. Autostart service on boot
systemctl enable eth0_watchdog.service
```

Siehe auch: https://nerdig.es/raspi-eth0-watchdog/
