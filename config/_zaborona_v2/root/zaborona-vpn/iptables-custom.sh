#!/bin/bash

WAN_4="ens3"
WAN_6="ens3"
VPN_ADDR_4=""
VPN_ADDR_6=""

# Включаем форвардинг пакетов
echo 1 > /proc/sys/net/ipv4/ip_forward

# Сбрасываем настройки брандмауэра
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X

# Разрешаем любой трафик на локальном интерфейсе
iptables -t filter -A INPUT -i lo -j ACCEPT 

# Разрешаем инициированные нами подключения извне
iptables -t filter -A INPUT -i $WAN_4 -m state --state ESTABLISHED,RELATED,NEW -j ACCEPT

# Разрешаем подключения по SSH
iptables -t filter -A INPUT -i $WAN_4 -p tcp --dport 22 -j ACCEPT

#Запрещаем входящие извне
#iptables -A INPUT -i $WAN_4 -j DROP

### NO FERM - If you are not using ferm, then uncomment the following block of code ### 
#VPNUDP_RANGE="192.168.100.0/22"
#VPNUDP_DNS="192.168.100.1/32"
#VPNTCP_RANGE="192.168.104.0/22"
#VPNTCP_DNS="192.168.104.1/32"
##EXT_INTERFACE="host0 eth0"
#VPN_ADDR_4=""
#VPN_ADDR_6=""

DNSMAP_RANGE="10.224.0.0/15"
VPN_NAME_INTERFACE="zaborona+ wg+ wghub+ ppp+"

VPN_ADDR_4_01="192.168.224.0/22"
VPN_ADDR_4_02="192.168.228.0/22"
VPN_ADDR_4_03="192.168.232.0/22"
VPN_ADDR_4_04="192.168.236.0/22"
VPN_ADDR_4_05="192.168.240.0/22"
VPN_ADDR_4_06="192.168.244.0/22"
VPN_ADDR_4_07="192.168.248.0/22"
VPN_ADDR_4_08="192.168.252.0/22"
VPN_ADDR_4_09="192.168.220.0/22"
VPN_ADDR_4_10="192.168.216.0/22"
VPN_ADDR_4_11="192.168.212.0/22"
VPN_ADDR_4_12="192.168.208.0/22"
VPN_ADDR_4_13="192.168.112.0/22"
VPN_ADDR_4_14="192.168.111.0/24"
VPN_ADDR_4_15="192.168.204.0/22"
VPN_ADDR_4_16="192.168.17.0/24"
VPN_ADDR_4_17="192.168.16.0/24"
VPN_ADDR_4_18="192.168.15.0/24"

VPN_ADDR_4_DNS01="192.168.224.1/32"
VPN_ADDR_4_DNS02="192.168.228.1/32"
VPN_ADDR_4_DNS03="192.168.232.1/32"
VPN_ADDR_4_DNS04="192.168.236.1/32"
VPN_ADDR_4_DNS05="192.168.240.1/32"
VPN_ADDR_4_DNS06="192.168.244.1/32"
VPN_ADDR_4_DNS07="192.168.248.1/32"
VPN_ADDR_4_DNS08="192.168.252.1/32"
VPN_ADDR_4_DNS09="192.168.220.1/32"
VPN_ADDR_4_DNS10="192.168.216.1/32"
VPN_ADDR_4_DNS11="192.168.212.1/32"
VPN_ADDR_4_DNS12="192.168.208.1/32"
VPN_ADDR_4_DNS13="192.168.112.1/32"
VPN_ADDR_4_DNS14="192.168.111.1/32"
VPN_ADDR_4_DNS15="192.168.204.1/32"
VPN_ADDR_4_DNS16="192.168.17.1/32"
VPN_ADDR_4_DNS17="192.168.16.1/32"
VPN_ADDR_4_DNS18="192.168.15.1/32"

iptables -t filter -N ZABORONA_V4

for VPN_NAME_INTERFACE1 in $VPN_NAME_INTERFACE; do
#	iptables -t filter -A FORWARD -i $VPN_NAME_INTERFACE1 -o $WAN_4 -m state --state ESTABLISHED,RELATED,DNAT -j ACCEPT
	iptables -t filter -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED,NEW,DNAT -j ACCEPT
	# ACCEPT marked "invalid" packet if it's for zapret set
	iptables -t filter -A FORWARD -i $VPN_NAME_INTERFACE1 -m connmark --mark 1 -j ZABORONA_V4
	iptables -t filter -A FORWARD -i $VPN_NAME_INTERFACE1 -m connmark --mark 1 -j REJECT
	iptables -t filter -A FORWARD -i $VPN_NAME_INTERFACE1 -o $WAN_4 -j ACCEPT
	iptables -t filter -A FORWARD -o $VPN_NAME_INTERFACE1 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
done

iptables -t filter -A FORWARD -p gre -j ACCEPT
iptables -t filter -A FORWARD -p esp -j ACCEPT
iptables -t filter -A FORWARD -p icmp -j ACCEPT
iptables -t filter -A FORWARD -j REJECT

iptables -t nat -N dnsmap
##iptables -t nat -A PREROUTING -s $VPNUDP_RANGE !-d $VPNUDP_DNS -p udp --dport 53 -m u32 --u32 '0x1C & 0xFFCF = 0x0100 && 0x1E & 0xFFFF = 0x0001' -j REDIRECT --to-ports 53
##iptables -t nat -A PREROUTING -s $VPNTCP_RANGE !-d $VPNTCP_DNS -p tcp --dport 53 -m u32 --u32 '0x1C & 0xFFCF = 0x0100 && 0x1E & 0xFFFF = 0x0001' -j REDIRECT --to-ports 53
# DNSMASQ PORT=5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_01 ! -d $VPN_ADDR_4_DNS01 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_02 ! -d $VPN_ADDR_4_DNS02 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_03 ! -d $VPN_ADDR_4_DNS03 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_04 ! -d $VPN_ADDR_4_DNS04 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_05 ! -d $VPN_ADDR_4_DNS05 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_06 ! -d $VPN_ADDR_4_DNS06 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_07 ! -d $VPN_ADDR_4_DNS07 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_08 ! -d $VPN_ADDR_4_DNS08 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_09 ! -d $VPN_ADDR_4_DNS09 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_10 ! -d $VPN_ADDR_4_DNS10 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_11 ! -d $VPN_ADDR_4_DNS11 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_12 ! -d $VPN_ADDR_4_DNS12 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_13 ! -d $VPN_ADDR_4_DNS13 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_14 ! -d $VPN_ADDR_4_DNS14 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_15 ! -d $VPN_ADDR_4_DNS15 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_16 ! -d $VPN_ADDR_4_DNS16 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_17 ! -d $VPN_ADDR_4_DNS17 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_18 ! -d $VPN_ADDR_4_DNS18 -p tcp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_01 ! -d $VPN_ADDR_4_DNS01 -p tcp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_02 ! -d $VPN_ADDR_4_DNS02 -p tcp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_03 ! -d $VPN_ADDR_4_DNS03 -p tcp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_04 ! -d $VPN_ADDR_4_DNS04 -p tcp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_05 ! -d $VPN_ADDR_4_DNS05 -p tcp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_06 ! -d $VPN_ADDR_4_DNS06 -p tcp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_07 ! -d $VPN_ADDR_4_DNS07 -p tcp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_08 ! -d $VPN_ADDR_4_DNS08 -p tcp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_09 ! -d $VPN_ADDR_4_DNS09 -p tcp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_10 ! -d $VPN_ADDR_4_DNS10 -p tcp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_11 ! -d $VPN_ADDR_4_DNS11 -p tcp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_12 ! -d $VPN_ADDR_4_DNS12 -p tcp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_13 ! -d $VPN_ADDR_4_DNS13 -p tcp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_14 ! -d $VPN_ADDR_4_DNS14 -p tcp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_15 ! -d $VPN_ADDR_4_DNS15 -p tcp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_16 ! -d $VPN_ADDR_4_DNS16 -p tcp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_17 ! -d $VPN_ADDR_4_DNS17 -p tcp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_18 ! -d $VPN_ADDR_4_DNS18 -p tcp --dport 53 -j REDIRECT --to-ports 5353

#iptables -t nat -A PREROUTING -s $VPNUDP_RANGE -d $VPNUDP_DNS -j ACCEPT
#iptables -t nat -A PREROUTING -s $VPNTCP_RANGE -d $VPNTCP_DNS -j ACCEPT
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_01 -d $VPN_ADDR_4_DNS01 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_02 -d $VPN_ADDR_4_DNS02 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_03 -d $VPN_ADDR_4_DNS03 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_04 -d $VPN_ADDR_4_DNS04 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_05 -d $VPN_ADDR_4_DNS05 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_06 -d $VPN_ADDR_4_DNS06 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_07 -d $VPN_ADDR_4_DNS07 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_08 -d $VPN_ADDR_4_DNS08 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_09 -d $VPN_ADDR_4_DNS09 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_10 -d $VPN_ADDR_4_DNS10 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_11 -d $VPN_ADDR_4_DNS11 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_12 -d $VPN_ADDR_4_DNS12 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_13 -d $VPN_ADDR_4_DNS13 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_14 -d $VPN_ADDR_4_DNS14 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_15 -d $VPN_ADDR_4_DNS15 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_16 -d $VPN_ADDR_4_DNS16 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_17 -d $VPN_ADDR_4_DNS17 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_18 -d $VPN_ADDR_4_DNS18 -p udp --dport 53 -j REDIRECT --to-ports 5353

#iptables -t nat -A PREROUTING -s $VPNUDP_RANGE !-d $DNSMAP_RANGE -j MARK --set-mark 1
#iptables -t nat -A PREROUTING -s $VPNTCP_RANGE !-d $DNSMAP_RANGE -j MARK --set-mark 1
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_01 ! -d $DNSMAP_RANGE -j MARK --set-mark 1
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_02 ! -d $DNSMAP_RANGE -j MARK --set-mark 1
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_03 ! -d $DNSMAP_RANGE -j MARK --set-mark 1
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_04 ! -d $DNSMAP_RANGE -j MARK --set-mark 1
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_05 ! -d $DNSMAP_RANGE -j MARK --set-mark 1
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_06 ! -d $DNSMAP_RANGE -j MARK --set-mark 1
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_07 ! -d $DNSMAP_RANGE -j MARK --set-mark 1
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_08 ! -d $DNSMAP_RANGE -j MARK --set-mark 1
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_09 ! -d $DNSMAP_RANGE -j MARK --set-mark 1
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_10 ! -d $DNSMAP_RANGE -j MARK --set-mark 1
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_11 ! -d $DNSMAP_RANGE -j MARK --set-mark 1
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_12 ! -d $DNSMAP_RANGE -j MARK --set-mark 1
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_13 ! -d $DNSMAP_RANGE -j MARK --set-mark 1
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_14 ! -d $DNSMAP_RANGE -j MARK --set-mark 1
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_15 ! -d $DNSMAP_RANGE -j MARK --set-mark 1
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_16 ! -d $DNSMAP_RANGE -j MARK --set-mark 1
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_17 ! -d $DNSMAP_RANGE -j MARK --set-mark 1
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_18 ! -d $DNSMAP_RANGE -j MARK --set-mark 1

#iptables -t nat -A PREROUTING -s $VPNUDP_RANGE -d $DNSMAP_RANGE -j dnsmap
#iptables -t nat -A PREROUTING -s $VPNTCP_RANGE -d $DNSMAP_RANGE -j dnsmap
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_01 -d $DNSMAP_RANGE -j dnsmap
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_02 -d $DNSMAP_RANGE -j dnsmap
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_03 -d $DNSMAP_RANGE -j dnsmap
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_04 -d $DNSMAP_RANGE -j dnsmap
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_05 -d $DNSMAP_RANGE -j dnsmap
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_06 -d $DNSMAP_RANGE -j dnsmap
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_07 -d $DNSMAP_RANGE -j dnsmap
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_08 -d $DNSMAP_RANGE -j dnsmap
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_09 -d $DNSMAP_RANGE -j dnsmap
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_10 -d $DNSMAP_RANGE -j dnsmap
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_11 -d $DNSMAP_RANGE -j dnsmap
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_12 -d $DNSMAP_RANGE -j dnsmap
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_13 -d $DNSMAP_RANGE -j dnsmap
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_14 -d $DNSMAP_RANGE -j dnsmap
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_15 -d $DNSMAP_RANGE -j dnsmap
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_16 -d $DNSMAP_RANGE -j dnsmap
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_17 -d $DNSMAP_RANGE -j dnsmap
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_18 -d $DNSMAP_RANGE -j dnsmap

#iptables -t nat -A POSTROUTING -s $VPNUDP_RANGE -j MASQUERADE
#iptables -t nat -A POSTROUTING -s $VPNTCP_RANGE -j MASQUERADE
iptables -t nat -A POSTROUTING -s $VPN_ADDR_4_01 -o $WAN_4 -j MASQUERADE
iptables -t nat -A POSTROUTING -s $VPN_ADDR_4_02 -o $WAN_4 -j MASQUERADE
iptables -t nat -A POSTROUTING -s $VPN_ADDR_4_03 -o $WAN_4 -j MASQUERADE
iptables -t nat -A POSTROUTING -s $VPN_ADDR_4_04 -o $WAN_4 -j MASQUERADE
iptables -t nat -A POSTROUTING -s $VPN_ADDR_4_05 -o $WAN_4 -j MASQUERADE
iptables -t nat -A POSTROUTING -s $VPN_ADDR_4_06 -o $WAN_4 -j MASQUERADE
iptables -t nat -A POSTROUTING -s $VPN_ADDR_4_07 -o $WAN_4 -j MASQUERADE
iptables -t nat -A POSTROUTING -s $VPN_ADDR_4_08 -o $WAN_4 -j MASQUERADE
iptables -t nat -A POSTROUTING -s $VPN_ADDR_4_09 -o $WAN_4 -j MASQUERADE
iptables -t nat -A POSTROUTING -s $VPN_ADDR_4_10 -o $WAN_4 -j MASQUERADE
iptables -t nat -A POSTROUTING -s $VPN_ADDR_4_11 -o $WAN_4 -j MASQUERADE
iptables -t nat -A POSTROUTING -s $VPN_ADDR_4_12 -o $WAN_4 -j MASQUERADE
iptables -t nat -A POSTROUTING -s $VPN_ADDR_4_13 -o $WAN_4 -j MASQUERADE
iptables -t nat -A POSTROUTING -s $VPN_ADDR_4_14 -o $WAN_4 -j MASQUERADE
iptables -t nat -A POSTROUTING -s $VPN_ADDR_4_15 -o $WAN_4 -j MASQUERADE
iptables -t nat -A POSTROUTING -s $VPN_ADDR_4_16 -o $WAN_4 -j MASQUERADE
iptables -t nat -A POSTROUTING -s $VPN_ADDR_4_17 -o $WAN_4 -j MASQUERADE
iptables -t nat -A POSTROUTING -s $VPN_ADDR_4_18 -o $WAN_4 -j MASQUERADE

iptables -t filter -A INPUT -i $WAN_4 -p gre -j ACCEPT
# IKEv2-IPsec
iptables -t filter -A INPUT -i $WAN_4 -p esp -j ACCEPT
iptables -t filter -A INPUT -i $WAN_4 -p udp --dport 500 -j ACCEPT
iptables -t filter -A INPUT -i $WAN_4 -p tcp --dport 500 -j ACCEPT
iptables -t filter -A INPUT -i $WAN_4 -p udp --dport 4500 -j ACCEPT
iptables -t filter -A INPUT -i $WAN_4 -p udp --dport 1701 -j ACCEPT
iptables -t filter -A INPUT -i $WAN_4 -p tcp --dport 1723 -j ACCEPT

### NO FERM - If you are not using ferm, then uncomment the following block of code ###

### DROP NETWORKS ###
### 224.0.0.0/4 (MULTICAST D)
### 240.0.0.0/5 (E)
iptables -I INPUT -i $WAN_4 -s 224.0.0.0/4 -j DROP
iptables -I INPUT -i $WAN_4 -s 240.0.0.0/5 -j DROP
### DROP NETWORKS ### 

### DROP TORRENTS ###
iptables -t filter -I FORWARD -m string --string "BitTorrent" --algo bm --to 65535 -j DROP
iptables -t filter -I FORWARD -m string --string "BitTorrent protocol" --algo bm --to 65535 -j DROP
iptables -t filter -I FORWARD -m string --string "peer_id=" --algo bm --to 65535 -j DROP
iptables -t filter -I FORWARD -m string --string ".torrent" --algo bm --to 65535 -j DROP
iptables -t filter -I FORWARD -m string --string "announce.php?passkey=" --algo bm --to 65535 -j DROP
iptables -t filter -I FORWARD -m string --string "torrent" --algo bm --to 65535 -j DROP
iptables -t filter -I FORWARD -m string --string "announce" --algo bm --to 65535 -j DROP
iptables -t filter -I FORWARD -m string --string "info_hash" --algo bm --to 65535 -j DROP
### DROP TORRENTS ###

iptables -t mangle -A PREROUTING -m string --algo bm --string "BitTorrent" -j DROP
iptables -t mangle -A PREROUTING -m string --string "get_peers" --algo bm -j DROP
iptables -t mangle -A PREROUTING -m string --string "announce_peer" --algo bm -j DROP
iptables -t mangle -A PREROUTING -m string --string "find_node" --algo bm -j DROP
iptables -t mangle -A PREROUTING -p udp -m string --algo bm --string "BitTorrent" -j DROP
iptables -t mangle -A PREROUTING -p udp -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -t mangle -A PREROUTING -p udp -m string --algo bm --string "peer_id=" -j DROP
iptables -t mangle -A PREROUTING -p udp -m string --algo bm --string ".torrent" -j DROP
iptables -t mangle -A PREROUTING -p udp -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -t mangle -A PREROUTING -p udp -m string --algo bm --string "torrent" -j DROP
iptables -t mangle -A PREROUTING -p udp -m string --algo bm --string "announce" -j DROP
iptables -t mangle -A PREROUTING -p udp -m string --algo bm --string "info_hash" -j DROP
iptables -t mangle -A PREROUTING -p udp -m string --algo bm --string "tracker" -j DROP

iptables -t mangle -A POSTROUTING -p udp -m string --algo bm --string "BitTorrent" -j DROP
iptables -t mangle -A POSTROUTING -p udp -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -t mangle -A POSTROUTING -p udp -m string --algo bm --string "peer_id=" -j DROP
iptables -t mangle -A POSTROUTING -p udp -m string --algo bm --string ".torrent" -j DROP
iptables -t mangle -A POSTROUTING -p udp -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -t mangle -A POSTROUTING -p udp -m string --algo bm --string "torrent" -j DROP
iptables -t mangle -A POSTROUTING -p udp -m string --algo bm --string "announce" -j DROP
iptables -t mangle -A POSTROUTING -p udp -m string --algo bm --string "info_hash" -j DROP
iptables -t mangle -A POSTROUTING -p udp -m string --algo bm --string "tracker" -j DROP

# DROP CONN PORTS #
#iptables -t mangle -A POSTROUTING -s 192.168.0.0/16 -o $WAN_4 -d 0.0.0.0/0 -p tcp --dport 22 -j LOG log-prefix ' IP address tried to connect to blocked ports!';
#iptables -t mangle -A POSTROUTING -i $VPN_NAME_INTERFACE -o $WAN_4 -p tcp --dport 22 -j DROP
#iptables -t mangle -A POSTROUTING -i $VPN_NAME_INTERFACE -o $WAN_4 -p tcp --dport 25 -j DROP
#iptables -t mangle -A POSTROUTING -i $VPN_NAME_INTERFACE -o $WAN_4 -p tcp --dport 465 -j DROP
#iptables -t mangle -A POSTROUTING -i $VPN_NAME_INTERFACE -o $WAN_4 -p tcp --dport 587 -j DROP
#iptables -t mangle -A POSTROUTING -i $VPN_NAME_INTERFACE -o $WAN_4 -p tcp --dport 1337 -j DROP
#iptables -t mangle -A POSTROUTING -i $VPN_NAME_INTERFACE -o $WAN_4 -p tcp --dport 6969 -j DROP
for VPN_NAME_INTERFACE1 in $VPN_NAME_INTERFACE; do
#	iptables -t mangle -A POSTROUTING -s 192.168.0.0/16 -o $WAN_4 -d 0.0.0.0/0 -p tcp -m multiport --dports 22,25,465,587,1337,6969 -j LOG log-prefix ' IP address tried to connect to blocked ports!';
	iptables -t filter -I FORWARD -i $VPN_NAME_INTERFACE1 -o $WAN_4 -p tcp -m tcp -m multiport --dports 22,25,465,587,1337,6969 -j REJECT
done
# DROP CONN PORTS #

# DNS Redirect to localhost
#iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT
#iptables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT

#
#iptables -A FORWARD -i $WAN_4 -o zaborona+ -j ACCEPT
#iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

#iptables -t nat -A POSTROUTING -o $WAN_4 -s 192.168.0.0/16 -j MASQUERADE
#echo 1 > /proc/sys/net/ipv4/ip_forward

# PREROUTING - Access For VPN-users (PPTP). All traffic
#iptables -t nat -I POSTROUTING -p tcp -s 192.168.115.0/24 -d 0.0.0.0/0 -o $WAN_4 -j MASQUERADE
#iptables -I FORWARD -p gre -j ACCEPT
#iptables -I FORWARD -i $WAN_4 -p tcp --dport 1723 -j ACCEPT
#iptables -I FORWARD -i $WAN_4 -o ppp+ -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
#iptables -I FORWARD -i ppp+ -o $WAN_4 -d 0.0.0.0/0 -j ACCEPT

############################
#iptables -I FORWARD -i $WAN_4 -o ppp+ -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -I FORWARD -i ppp+ -o $WAN_4 -d 0.0.0.0/0 -j ACCEPT
#iptables -I FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
# PPTP
#iptables -t nat -I POSTROUTING -p tcp -s 192.168.216.0/22 -d 0.0.0.0/0 -o $WAN_4 -j MASQUERADE
# L2TP-IPsec
#iptables -t nat -I POSTROUTING -p tcp -s 192.168.212.0/22 -d 0.0.0.0/0 -o $WAN_4 -j MASQUERADE
# IKEv2-IPsec
#iptables -I INPUT -i $WAN_4 -p esp -j ACCEPT
#iptables -t nat -I POSTROUTING -p tcp -s 192.168.208.0/22 -d 0.0.0.0/0 -o $WAN_4 -j MASQUERADE
# WireGuard
#iptables -t nat -I POSTROUTING -p tcp -s 192.168.220.0/22 -d 0.0.0.0/0 -o $WAN_4 -j MASQUERADE
#iptables -t nat -I POSTROUTING -p udp -s 192.168.220.0/22 -d 0.0.0.0/0 -o $WAN_4 -j MASQUERADE

#iptables -I FORWARD -i $WAN_4 -p tcp --dport 1723 -j ACCEPT
#iptables -I FORWARD -p gre -j ACCEPT
#iptables -I INPUT -p gre -j ACCEPT

#iptables -I INPUT -i $WAN_4 -p udp --dport 500 -j ACCEPT
#iptables -I INPUT -i $WAN_4 -p tcp --dport 500 -j ACCEPT
#iptables -I INPUT -i $WAN_4 -p udp --dport 4500 -j ACCEPT
#iptables -I INPUT -i $WAN_4 -p udp --dport 1701 -j ACCEPT
#iptables -I INPUT -i $WAN_4 -p tcp --dport 1723 -j ACCEPT

#iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
#iptables -I FORWARD -s 192.168.115.0/24  -j ACCEPT
#iptables -I FORWARD -s 192.168.116.0/24  -j ACCEPT
#iptables -I FORWARD -s 192.168.120.0/21  -j ACCEPT
#iptables -I FORWARD -s 192.168.80.0/24  -j ACCEPT
############################

### INDIVIDUAL CFG ###
# Examlpe: iptables -I FORWARD -s 192.168.216.5/32 -o $WAN_4 -d 0.0.0.0/0 -j ACCEPT
#iptables -I FORWARD -s 192.168.216.2/32 -o $WAN_4 -d 0.0.0.0/0 -j ACCEPT
#iptables -I FORWARD -s 192.168.17.0/24 -o $WAN_4 -d 0.0.0.0/0 -j ACCEPT
#iptables -I FORWARD -s 192.168.16.0/24 -o $WAN_4 -d 0.0.0.0/0 -j ACCEPT
#iptables -I FORWARD -s 192.168.15.0/24 -o $WAN_4 -d 0.0.0.0/0 -j ACCEPT
### INDIVIDUAL CFG ###

# Tor DNS and Routes #
#iptables -t nat -I PREROUTING -p udp --dport 53 -m string --hex-string "|056f6e696f6e00|" --algo bm -j REDIRECT --to-ports 5300
#iptables -t nat -I OUTPUT -p udp --dport 53 -m string --hex-string "|056f6e696f6e00|" --algo bm -j REDIRECT --to-ports 5300
##iptables -t nat -I PREROUTING -p tcp -d 192.168.13.0/24 -j REDIRECT --to-port 9040
##iptables -t nat -I OUTPUT -p tcp -d 192.168.13.0/24 -j REDIRECT --to-port 9040
# Tor DNS and Routes #
 
exit 0
