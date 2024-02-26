# Info
network setup helper

# Example 

## set two VLAN ID (133) & (100) for eth2
```bash
~ # ❯❯❯ ip -c a | grep eth2
3: eth2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 00:0c:29:2d:40:15 brd ff:ff:ff:ff:ff:ff
```

```bash
~/t/network # ❯❯❯ cp start_TEMPLATE.sh start_eth2.sh
~/t/network # ❯❯❯ nano start_eth2.sh
~/t/network # ❯❯❯ head -n 11 start_eth2.sh
#!/bin/bash

IFACE=$1
echo "[*] adding $IFACE config";

#### CHANGE ME vvvvvv
# <[VLAN]ID>@<IP>/<SUBNET>
data=$(cat <<EOF

133@1.2.133.7/24
100@4.5.100.9/16
```
call script with `VLAN`
```bash
~/t/network # ❯❯❯ ./network_bootstrap.sh eth2 VLAN
[*] adding eth2 config
	[-] adding VLAN 133 for eth2 with IP: 1.2.133.7/24
	[-] adding VLAN 100 for eth2 with IP: 4.5.100.9/16
net.ipv4.ip_forward = 1
[*] set iptales for eth2
	[-] adding iptables postrouting for eth2.133
	[-] adding iptables postrouting for eth2.100
net.ipv4.conf.all.rp_filter = 0
```

```bash
~/t/network # ❯❯❯ ip -c a | grep eth2
3: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
4: eth2.133@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    inet 1.2.133.7/24 brd 1.2.133.255 scope global eth2.133
5: eth2.100@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    inet 4.5.100.9/16 brd 4.5.255.255 scope global eth2.100
```

```bash
~/t/network # ❯❯❯ iptables -t nat -L -v -n | grep eth2
    0     0 MASQUERADE  all  --  *      eth2.133  0.0.0.0/0            0.0.0.0/0           
    0     0 MASQUERADE  all  --  *      eth2.100  0.0.0.0/0            0.0.0.0/0           
```

## set two subnets (x.x.133.7) & (x.x.100.9) for eth2

```bash
~ # ❯❯❯ ip -c a | grep eth2
3: eth2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 00:0c:29:2d:40:15 brd ff:ff:ff:ff:ff:ff
```

```bash
~/t/network # ❯❯❯ cp start_TEMPLATE.sh start_eth2.sh
~/t/network # ❯❯❯ nano start_eth2.sh
~/t/network # ❯❯❯ head -n 11 start_eth2.sh
#!/bin/bash

IFACE=$1
echo "[*] adding $IFACE config";

#### CHANGE ME vvvvvv
# <[VLAN]ID>@<IP>/<SUBNET>
data=$(cat <<EOF

133@32.64.133.7/24
100@32.64.100.9/16
```

```bash
~/t/network # ❯❯❯ ./network_bootstrap.sh eth2
[*] adding eth2 config
	[-] adding subnet 133 for eth2 with IP: 32.64.133.7/24
	[-] adding subnet 100 for eth2 with IP: 32.64.100.9/16
net.ipv4.ip_forward = 1
[*] set iptales for eth2
	[-] adding iptables postrouting for eth2.133
	[-] adding iptables postrouting for eth2.100
net.ipv4.conf.all.rp_filter = 0
```

```bash
~/t/network # ❯❯❯ ip -c a | grep eth2
3: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    inet 32.64.133.7/24 brd 32.64.133.255 scope global eth2:133
    inet 32.64.100.9/16 brd 32.64.255.255 scope global eth2:100
```

```bash
~/t/network # ❯❯❯ iptables -t nat -L -v -n | grep eth2
    0     0 MASQUERADE  all  --  *      eth2.133  0.0.0.0/0            0.0.0.0/0           
    0     0 MASQUERADE  all  --  *      eth2.100  0.0.0.0/0            0.0.0.0/0           
```

# Setup kali VM as router / GW for others
+ set given interface as `hostonly` in VMware setup
+ change `network_bootstrap.sh` for new interface (set `IP` for `IFACE`)
+ set `GW_IP` as default GW in connected machines via `route add default gw <GW_IP> <IFACE>`
