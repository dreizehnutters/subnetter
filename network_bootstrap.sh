#!/bin/bash

if [ -z "$1" ]; then  echo -e "Usage:\n$0 eth1,[eth2] [VLAN FLAG]";echo -e "configure subnet/VLAN ID settings in each start_<IFACE>.sh script";exit 1;fi

### CHANGE ME for GW settings vvv
# ifconfig eth1 up
# ifconfig eth1 192.168.1.1/24
### ^^^

IFS=',' read -r -a StringArray <<< "$1"
 
for IFACE in ${StringArray[@]}; do
   [ ! -f "start_$IFACE.sh" ] && echo "[!!] start_$IFACE.sh file missing" && continue
   ifconfig $IFACE up;
   chmod +x start_$IFACE.sh;
   ./start_$IFACE.sh $IFACE $2;
done

# enable IP forwarding
sysctl -w net.ipv4.ip_forward=1;

sleep 2
# set forwaring
for IFACE in ${StringArray[@]}; do
   echo "[*] set iptales for $IFACE"
   if [ -n "$2" ]; then
      IFACES=$(ip a | grep $IFACE | grep "@" |cut -d ' ' -f2 | cut -d '@' -f1);
   else
      IFACES=$(ip a | grep $IFACE | grep ":" | grep -v "<" |cut -d ' ' -f11);
   fi
   for IF in $IFACES; do
      echo -e "\t[-] adding iptables postrouting for $IF";
      iptables -t nat -A POSTROUTING -o $IF -j MASQUERADE;
   done
done

sysctl -w net.ipv4.conf.all.rp_filter=0;

exit 0;