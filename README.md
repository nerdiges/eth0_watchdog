# eth0_watchdog für den Raspberry Pi
Aufgrund eines Bugs, wird die Netzwerkkarte meines Raspberry Pi 2 nicht neu initialisiert, wenn der Link temporär ausfällt. Mit diesem Script wird die Netzwerkkarte neu initialisiert, wenn der Link zurück kommt.

## Funktionsweise
Dazu wird ein Script per `systemd` beim Systemstart ausgeführt, dass alle 30 Sekunden überprüft, ob dem Interface `eth0` noch eine IP-Adresse zugeordet ist und ob das Default Gateway noch per Ping erreichbar ist. Falls eine dieser Checks fehlschlägt wird `ip link set eth0 down`und `up` das interface herunter und wieder hoch gefahren, so dass der Netzwerkmanager (bei Raspberry OS standardmäßig dhcpcd) eine neue IP-Adresse bezieht.

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

