#!/bin/bash

# check every 30 seconds if link is still available
while true; do
        # init var
        reset_eth0=0

        # check if IP-Adress is assigned
        if ! /usr/sbin/ip address show eth0 | /usr/bin/grep -q -E "inet [0-2]?[0-9]{1,2}\."; then
                reset_eth0=1
                /usr/bin/logger "eth0 check failed! Could not get IPv4 address - starting reconnect..."
        fi

        # when IPv4 is set correctly, check if default GW is  pingable
        if [ $reset_eth0 -eq 0 ]; then
                defaultgw=$(/usr/sbin/ip -4 route show default | /usr/bin/awk '{print $3 }')
                if ! /usr/bin/ping -c 1 $defaultgw > /dev/null; then
                        reset_eth0=1
                        /usr/bin/logger "eth0 check failed! Could not access default GW - starting reconnect..."
                fi
        fi

        if [ $reset_eth0 -eq 1 ]; then
                /usr/sbin/ip link set eth0 down
                sleep 1
                /usr/sbin/ip link set eth0 up
                sleep 60
                status=$(/usr/sbin/ip -4 addr show eth0 | grep "inet 192" | /usr/bin/awk '{print $2}')
                if [ -z $status ]; then
                        /usr/bin/logger "Reconnection failed..."
                else
                        /usr/bin/logger "Successsfully reconnected eth0. Current IPv4 $status"
                fi
        fi
        sleep 30
done
