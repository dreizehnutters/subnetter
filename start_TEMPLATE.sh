#!/bin/bash

IFACE=$1
echo "[*] adding $IFACE config";

#### CHANGE ME vvvvvv
# <[VLAN]ID>@<IP>/<SUBNET>
data=$(cat <<EOF

133@32.64.133.7/24
100@32.64.121.9/16

EOF
)
### ^^^

# VLAN MODE
if [ -n "$2" ]; then
    for line in `echo $data | tr ' ' '\n'`; do
        VLAN_ID=$(echo $line | cut -d '@' -f1);
        IP=$(echo $line | cut -d '@' -f2);
        echo -e "\t[-] adding VLAN $VLAN_ID for $IFACE with IP: $IP";
        ip link add link $IFACE name $IFACE.$VLAN_ID type vlan id $VLAN_ID;
        ifconfig $IFACE.$VLAN_ID $IP up;
    done
# SUBNET MODE
else
    for line in `echo $data | tr ' ' '\n'`; do
        ID=$(echo $line | cut -d '@' -f1);
        IP=$(echo $line | cut -d '@' -f2);
        echo -e "\t[-] adding subnet $ID for $IFACE with IP: $IP";
        ifconfig $IFACE:$ID $IP up;
    done
fi

exit 0