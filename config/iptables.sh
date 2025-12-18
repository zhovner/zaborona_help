#!/bin/bash

#sleep 10

WAN_4="ens3"
WAN_6="ens3"
VPN_ADDR_4=""
VPN_ADDR_6=""

# Включаем форвардинг пакетов
echo 1 > /proc/sys/net/ipv4/ip_forward

# Сбрасываем настройки брандмауэра
iptables -t filter -F ZABORONA_V4
iptables -t filter -F ZABORONA-IPROUTE_V4
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X

# Полиикта по-умолчанию
#iptables -t filter -P FORWARD DROP

# Разрешаем любой трафик на локальном интерфейсе
iptables -t filter -A INPUT -i lo -j ACCEPT 

# Разрешаем инициированные нами подключения извне
iptables -t filter -A INPUT -i $WAN_4 -m state --state ESTABLISHED,RELATED -j ACCEPT

# Разрешаем подключения по SSH
iptables -t filter -A INPUT -i $WAN_4 -p tcp --dport 22 -j ACCEPT

iptables -t filter -A INPUT -i $WAN_4 -p gre -j ACCEPT
# IKEv2-IPsec
iptables -t filter -A INPUT -i $WAN_4 -p esp -j ACCEPT
iptables -t filter -A INPUT -i $WAN_4 -p udp --dport 500 -j ACCEPT
iptables -t filter -A INPUT -i $WAN_4 -p tcp --dport 500 -j ACCEPT
iptables -t filter -A INPUT -i $WAN_4 -p udp --dport 4500 -j ACCEPT
iptables -t filter -A INPUT -i $WAN_4 -p udp --dport 1701 -j ACCEPT
iptables -t filter -A INPUT -i $WAN_4 -p tcp --dport 1723 -j ACCEPT
iptables -t filter -A INPUT -i $WAN_4 -p tcp --dport 53 -j DROP
iptables -t filter -A INPUT -i $WAN_4 -p udp --dport 53 -j DROP

#Запрещаем входящие извне
#iptables -A INPUT -i $WAN_4 -j DROP

### NO FERM - If you are not using ferm, then uncomment the following block of code ###
### EXAMPLE ### 
#VPNUDP_RANGE="192.168.100.0/22"
#VPNUDP_DNS="192.168.100.1/32"
#VPNTCP_RANGE="192.168.104.0/22"
#VPNTCP_DNS="192.168.104.1/32"
##EXT_INTERFACE="host0 eth0"
#VPN_ADDR_4=""
#VPN_ADDR_6=""
### EXAMPLE ### 

DNSMAP_RANGE="10.224.0.0/15"
VPN_NAME_INTERFACE="zaborona+ zbrn+ wg+ wghub+ ppp+"

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
VPN_ADDR_4_19="192.168.199.0/24"
VPN_ADDR_4_20="192.168.200.0/22"

#VPN_ADDR_4=(
#"192.168.224.0/22"
#"192.168.228.0/22"
#"192.168.232.0/22"
#"192.168.236.0/22"
#"192.168.240.0/22"
#"192.168.244.0/22"
#"192.168.248.0/22"
#"192.168.252.0/22"
#"192.168.220.0/22"
#"192.168.216.0/22"
#"192.168.212.0/22"
#"192.168.208.0/22"
#"192.168.112.0/22"
#"192.168.111.0/24"
#"192.168.204.0/22"
#"192.168.17.0/24"
#"192.168.16.0/24"
#"192.168.15.0/24"
#"192.168.204.0/24"
#"192.168.200.0/22"
#)

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
VPN_ADDR_4_DNS19="192.168.199.1/32"
VPN_ADDR_4_DNS20="192.168.200.1/32"

#VPN_ADDR_4_DNS=(
#"192.168.224.1/32"
#"192.168.228.1/32"
#"192.168.232.1/32"
#"192.168.236.1/32"
#"192.168.240.1/32"
#"192.168.244.1/32"
#"192.168.248.1/32"
#"192.168.252.1/32"
#"192.168.220.1/32"
#"192.168.216.1/32"
#"192.168.212.1/32"
#"192.168.208.1/32"
#"192.168.112.1/32"
#"192.168.111.1/32"
#"192.168.204.1/32"
#"192.168.17.1/32"
#"192.168.16.1/32"
#"192.168.15.1/32"
#"192.168.204.1/32"
#"192.168.200.1/32"
#)

VPN_ADDR_4_DNSFAKE1="208.67.222.222/32"
VPN_ADDR_4_DNSFAKE2="208.67.220.220/32"
VPN_ADDR_4_DNSFAKE3="77.88.8.8/32"
VPN_ADDR_4_DNSFAKE4="77.88.8.1/32"

#VPN_ADDRS=("208.67.222.222/32" "208.67.220.220/32" "77.88.8.8/32" "77.88.8.1/32")

# iproute firewall
iptables -t filter -N ZABORONA_V4
iptables -t filter -N ZABORONA-IPROUTE_V4
# iproute nat
#iptables -t nat -N ZABORONA_V4
#iptables -t nat -N ZABORONA-IPROUTE_V4

iptables -t filter -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED,DNAT -j ACCEPT
iptables -w -t filter -A ZABORONA_V4 -d $DNSMAP_RANGE -m connmark --mark 1 -j ACCEPT
iptables -w -t filter -A ZABORONA_V4 -d $DNSMAP_RANGE -j ACCEPT

for VPN_NAME_INTERFACE1 in $VPN_NAME_INTERFACE; do
##	iptables -t filter -A FORWARD -i $VPN_NAME_INTERFACE1 -o $WAN_4 -m conntrack --ctstate ESTABLISHED,RELATED,DNAT -j ACCEPT
#	iptables -t filter -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED,DNAT -j ACCEPT
	iptables -t filter -A FORWARD -o $VPN_NAME_INTERFACE1 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
	# ACCEPT marked "invalid" packet if it's for zapret set
	iptables -t filter -A FORWARD -i $VPN_NAME_INTERFACE1 -m connmark --mark 1 -j ZABORONA_V4
	iptables -t filter -A FORWARD -i $VPN_NAME_INTERFACE1 -m connmark --mark 1 -j ZABORONA-IPROUTE_V4
	iptables -t filter -A FORWARD -i $VPN_NAME_INTERFACE1 -m connmark --mark 1 -j REJECT
	iptables -t filter -A FORWARD -i $VPN_NAME_INTERFACE1 -j ZABORONA_V4
	iptables -t filter -A FORWARD -i $VPN_NAME_INTERFACE1 -j ZABORONA-IPROUTE_V4
	iptables -t filter -A FORWARD -i $VPN_NAME_INTERFACE1 -o $WAN_4 -j ACCEPT
##	iptables -t filter -A FORWARD -i $VPN_NAME_INTERFACE1 -o $WAN_4 -p tcp -m tcp -m multiport --dports 1:1024 -j ACCEPT
##	iptables -t filter -A FORWARD -i $VPN_NAME_INTERFACE1 -o $WAN_4 -p udp -m udp -m multiport --dports 1:1024 -j ACCEPT
#	iptables -t filter -A FORWARD -i $VPN_NAME_INTERFACE1 -o $WAN_4 -p udp -m udp -m multiport ! --dports 1:1024 -j REJECT
#	iptables -t filter -A FORWARD -o $VPN_NAME_INTERFACE1 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
#	iptables -t filter -A FORWARD -o $WAN_4 -m conntrack --ctstate ESTABLISHED,RELATED,DNAT -j ACCEPT
	# Запрещаем транзитный трафик извне (если запретить, перестанут открываться сайты)
#	iptables -t filter -A FORWARD -i $WAN_4 -o $VPN_NAME_INTERFACE1 -j DROP
#	iptables -t filter -A FORWARD -i $VPN_NAME_INTERFACE1 -m connmark --mark 1 -j REJECT
#	iptables -t filter -A FORWARD -i $VPN_NAME_INTERFACE1 -o $WAN_4 -j DROP
done

#iptables -t filter -A FORWARD -o $WAN_4 -m conntrack --ctstate ESTABLISHED,RELATED,DNAT -j ACCEPT

iptables -t filter -A FORWARD -p gre -j ACCEPT
iptables -t filter -A FORWARD -p esp -j ACCEPT
iptables -t filter -A FORWARD -p icmp -j ACCEPT

# Лог и блокировка остального
#iptables -t filter -A FORWARD -j LOG --log-prefix "ZABORONA_DROP: " --log-level 4
iptables -t filter -A FORWARD -j REJECT

# 20251028
# 2. Восстанавливать метку на всех пакетах
iptables -t nat -A PREROUTING -j CONNMARK --restore-mark
iptables -t mangle -A OUTPUT -j CONNMARK --restore-mark
# 20251028

# dnsmap range ips: 10.224.0.0/15
iptables -t nat -N dnsmap
iptables -t nat -N dnsmaptor
iptables -t nat -N dnsmapi2p
###iptables -t nat -A PREROUTING -s $VPNUDP_RANGE !-d $VPNUDP_DNS -p udp --dport 53 -m u32 --u32 '0x1C & 0xFFCF = 0x0100 && 0x1E & 0xFFFF = 0x0001' -j REDIRECT --to-ports 53
###iptables -t nat -A PREROUTING -s $VPNTCP_RANGE !-d $VPNTCP_DNS -p tcp --dport 53 -m u32 --u32 '0x1C & 0xFFCF = 0x0100 && 0x1E & 0xFFFF = 0x0001' -j REDIRECT --to-ports 53
## DNSMASQ PORT=5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_01 ! -d $VPN_ADDR_4_DNS01 -p udp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_02 ! -d $VPN_ADDR_4_DNS02 -p udp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_03 ! -d $VPN_ADDR_4_DNS03 -p udp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_04 ! -d $VPN_ADDR_4_DNS04 -p udp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_05 ! -d $VPN_ADDR_4_DNS05 -p udp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_06 ! -d $VPN_ADDR_4_DNS06 -p udp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_07 ! -d $VPN_ADDR_4_DNS07 -p udp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_08 ! -d $VPN_ADDR_4_DNS08 -p udp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_09 ! -d $VPN_ADDR_4_DNS09 -p udp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_10 ! -d $VPN_ADDR_4_DNS10 -p udp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_11 ! -d $VPN_ADDR_4_DNS11 -p udp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_12 ! -d $VPN_ADDR_4_DNS12 -p udp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_13 ! -d $VPN_ADDR_4_DNS13 -p udp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_14 ! -d $VPN_ADDR_4_DNS14 -p udp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_15 ! -d $VPN_ADDR_4_DNS15 -p udp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_16 ! -d $VPN_ADDR_4_DNS16 -p udp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_17 ! -d $VPN_ADDR_4_DNS17 -p udp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_18 ! -d $VPN_ADDR_4_DNS18 -p tcp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_01 ! -d $VPN_ADDR_4_DNS01 -p tcp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_02 ! -d $VPN_ADDR_4_DNS02 -p tcp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_03 ! -d $VPN_ADDR_4_DNS03 -p tcp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_04 ! -d $VPN_ADDR_4_DNS04 -p tcp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_05 ! -d $VPN_ADDR_4_DNS05 -p tcp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_06 ! -d $VPN_ADDR_4_DNS06 -p tcp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_07 ! -d $VPN_ADDR_4_DNS07 -p tcp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_08 ! -d $VPN_ADDR_4_DNS08 -p tcp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_09 ! -d $VPN_ADDR_4_DNS09 -p tcp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_10 ! -d $VPN_ADDR_4_DNS10 -p tcp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_11 ! -d $VPN_ADDR_4_DNS11 -p tcp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_12 ! -d $VPN_ADDR_4_DNS12 -p tcp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_13 ! -d $VPN_ADDR_4_DNS13 -p tcp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_14 ! -d $VPN_ADDR_4_DNS14 -p tcp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_15 ! -d $VPN_ADDR_4_DNS15 -p tcp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_16 ! -d $VPN_ADDR_4_DNS16 -p tcp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_17 ! -d $VPN_ADDR_4_DNS17 -p tcp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_18 ! -d $VPN_ADDR_4_DNS18 -p tcp --dport 53 -j REDIRECT --to-ports 5353
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_19 ! -d $VPN_ADDR_4_DNS19 -p tcp --dport 53 -j REDIRECT --to-ports 5353

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
## AdGuardHOME
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_09 -d $VPN_ADDR_4_DNS09 -p udp --dport 53 -j REDIRECT --to-ports 5359
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_10 -d $VPN_ADDR_4_DNS10 -p udp --dport 53 -j REDIRECT --to-ports 5359
##
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_11 -d $VPN_ADDR_4_DNS11 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_12 -d $VPN_ADDR_4_DNS12 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_13 -d $VPN_ADDR_4_DNS13 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_14 -d $VPN_ADDR_4_DNS14 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_15 -d $VPN_ADDR_4_DNS15 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_16 -d $VPN_ADDR_4_DNS16 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_17 -d $VPN_ADDR_4_DNS17 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_18 -d $VPN_ADDR_4_DNS18 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_19 -d $VPN_ADDR_4_DNS19 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_20 -d $VPN_ADDR_4_DNS20 -p udp --dport 53 -j REDIRECT --to-ports 5353

# VPN_ADDR_4_DNSFAKE1
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_01 -d $VPN_ADDR_4_DNSFAKE1 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_02 -d $VPN_ADDR_4_DNSFAKE1 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_03 -d $VPN_ADDR_4_DNSFAKE1 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_04 -d $VPN_ADDR_4_DNSFAKE1 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_05 -d $VPN_ADDR_4_DNSFAKE1 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_06 -d $VPN_ADDR_4_DNSFAKE1 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_07 -d $VPN_ADDR_4_DNSFAKE1 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_08 -d $VPN_ADDR_4_DNSFAKE1 -p udp --dport 53 -j REDIRECT --to-ports 5353
## AdGuardHOME
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_09 -d $VPN_ADDR_4_DNSFAKE1 -p udp --dport 53 -j REDIRECT --to-ports 5359
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_10 -d $VPN_ADDR_4_DNSFAKE1 -p udp --dport 53 -j REDIRECT --to-ports 5359
##
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_11 -d $VPN_ADDR_4_DNSFAKE1 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_12 -d $VPN_ADDR_4_DNSFAKE1 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_13 -d $VPN_ADDR_4_DNSFAKE1 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_14 -d $VPN_ADDR_4_DNSFAKE1 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_15 -d $VPN_ADDR_4_DNSFAKE1 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_16 -d $VPN_ADDR_4_DNSFAKE1 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_17 -d $VPN_ADDR_4_DNSFAKE1 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_18 -d $VPN_ADDR_4_DNSFAKE1 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_19 -d $VPN_ADDR_4_DNSFAKE1 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_20 -d $VPN_ADDR_4_DNSFAKE1 -p udp --dport 53 -j REDIRECT --to-ports 5353

# VPN_ADDR_4_DNSFAKE2
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_01 -d $VPN_ADDR_4_DNSFAKE2 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_02 -d $VPN_ADDR_4_DNSFAKE2 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_03 -d $VPN_ADDR_4_DNSFAKE2 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_04 -d $VPN_ADDR_4_DNSFAKE2 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_05 -d $VPN_ADDR_4_DNSFAKE2 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_06 -d $VPN_ADDR_4_DNSFAKE2 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_07 -d $VPN_ADDR_4_DNSFAKE2 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_08 -d $VPN_ADDR_4_DNSFAKE2 -p udp --dport 53 -j REDIRECT --to-ports 5353
## AdGuardHOME
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_09 -d $VPN_ADDR_4_DNSFAKE2 -p udp --dport 53 -j REDIRECT --to-ports 5359
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_10 -d $VPN_ADDR_4_DNSFAKE2 -p udp --dport 53 -j REDIRECT --to-ports 5359
##
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_11 -d $VPN_ADDR_4_DNSFAKE2 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_12 -d $VPN_ADDR_4_DNSFAKE2 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_13 -d $VPN_ADDR_4_DNSFAKE2 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_14 -d $VPN_ADDR_4_DNSFAKE2 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_15 -d $VPN_ADDR_4_DNSFAKE2 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_16 -d $VPN_ADDR_4_DNSFAKE2 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_17 -d $VPN_ADDR_4_DNSFAKE2 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_18 -d $VPN_ADDR_4_DNSFAKE2 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_19 -d $VPN_ADDR_4_DNSFAKE2 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_20 -d $VPN_ADDR_4_DNSFAKE2 -p udp --dport 53 -j REDIRECT --to-ports 5353

# VPN_ADDR_4_DNSFAKE3
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_01 -d $VPN_ADDR_4_DNSFAKE3 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_02 -d $VPN_ADDR_4_DNSFAKE3 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_03 -d $VPN_ADDR_4_DNSFAKE3 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_04 -d $VPN_ADDR_4_DNSFAKE3 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_05 -d $VPN_ADDR_4_DNSFAKE3 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_06 -d $VPN_ADDR_4_DNSFAKE3 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_07 -d $VPN_ADDR_4_DNSFAKE3 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_08 -d $VPN_ADDR_4_DNSFAKE3 -p udp --dport 53 -j REDIRECT --to-ports 5353
## AdGuardHOME
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_09 -d $VPN_ADDR_4_DNSFAKE3 -p udp --dport 53 -j REDIRECT --to-ports 5359
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_10 -d $VPN_ADDR_4_DNSFAKE3 -p udp --dport 53 -j REDIRECT --to-ports 5359
##
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_11 -d $VPN_ADDR_4_DNSFAKE3 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_12 -d $VPN_ADDR_4_DNSFAKE3 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_13 -d $VPN_ADDR_4_DNSFAKE3 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_14 -d $VPN_ADDR_4_DNSFAKE3 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_15 -d $VPN_ADDR_4_DNSFAKE3 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_16 -d $VPN_ADDR_4_DNSFAKE3 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_17 -d $VPN_ADDR_4_DNSFAKE3 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_18 -d $VPN_ADDR_4_DNSFAKE3 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_19 -d $VPN_ADDR_4_DNSFAKE3 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_20 -d $VPN_ADDR_4_DNSFAKE3 -p udp --dport 53 -j REDIRECT --to-ports 5353

# VPN_ADDR_4_DNSFAKE4
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_01 -d $VPN_ADDR_4_DNSFAKE4 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_02 -d $VPN_ADDR_4_DNSFAKE4 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_03 -d $VPN_ADDR_4_DNSFAKE4 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_04 -d $VPN_ADDR_4_DNSFAKE4 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_05 -d $VPN_ADDR_4_DNSFAKE4 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_06 -d $VPN_ADDR_4_DNSFAKE4 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_07 -d $VPN_ADDR_4_DNSFAKE4 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_08 -d $VPN_ADDR_4_DNSFAKE4 -p udp --dport 53 -j REDIRECT --to-ports 5353
## AdGuardHOME
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_09 -d $VPN_ADDR_4_DNSFAKE4 -p udp --dport 53 -j REDIRECT --to-ports 5359
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_10 -d $VPN_ADDR_4_DNSFAKE4 -p udp --dport 53 -j REDIRECT --to-ports 5359
##
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_11 -d $VPN_ADDR_4_DNSFAKE4 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_12 -d $VPN_ADDR_4_DNSFAKE4 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_13 -d $VPN_ADDR_4_DNSFAKE4 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_14 -d $VPN_ADDR_4_DNSFAKE4 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_15 -d $VPN_ADDR_4_DNSFAKE4 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_16 -d $VPN_ADDR_4_DNSFAKE4 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_17 -d $VPN_ADDR_4_DNSFAKE4 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_18 -d $VPN_ADDR_4_DNSFAKE4 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_19 -d $VPN_ADDR_4_DNSFAKE4 -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_20 -d $VPN_ADDR_4_DNSFAKE4 -p udp --dport 53 -j REDIRECT --to-ports 5353

# 2025-11-14
# На серверах OVH антиспам система фиксирует количество запросов к одному ДНС-серверу
# и если оно превышает допустимую границу, которая на их обородувании настроена, то
# сервер считается, как уязвимый и создает ДДОС, и хостинг его блокирует навсегда.
# Было принято решение завернуть все запросы на локальный AdGuardHOME, а из него
# через DOH/DOT отправлять ДНС-запросы к серверам, чтобы не палить значительный объем
# трафика, который идет на 53 порт к публичным ДНС-серверам. Так же на AdGuardHOME настроено
# кеширование запросов на время от 12 до 24 часов (в зависимости от ОЗУ)

# Заворачиваем все ДНС-запросы с клиентов маршрута bigroutes, независимо от ДНС-серверов, которые они у себя прописали
# AdGuardHOME REDIRECT 127.0.0.5:53 -> 5359
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_09 -p udp --dport 53 -j REDIRECT --to-ports 5359
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_10 -p udp --dport 53 -j REDIRECT --to-ports 5359
# AdGuardHOME REDIRECT 127.0.0.5:53 -> 5359

# Заворачиваем все ДНС-запросы со всех клиентов, независимо от ДНС-серверов, которые они у себя прописали
# AdGuardHOME REDIRECT 192.168.0.0/16:53 -> 5359
iptables -t nat -A PREROUTING -s 192.168.0.0/16 -p udp --dport 53 -j REDIRECT --to-ports 5359
iptables -t nat -A PREROUTING -s 192.168.0.0/16 -p tcp --dport 53 -j REDIRECT --to-ports 5359
# AdGuardHOME REDIRECT 192.168.0.0/16:53 -> 5359
# 2025-11-14

## Проверка: если VPN_ADDR **не входит** в список
#found=false
#for val in "${VPN_ADDRS[@]}"; do
#    if [[ $VPN_ADDR == "$val" ]]; then
#        found=true
#        break
#    fi
#done
#
#if ! $found; then
#    echo "VPN_ADDR не найден в списке, выполняем другое действие"
#    # Здесь вставить другой код
#else
#    echo "VPN_ADDR найден в списке"
#fi

# 1. Установить и сохранить метку
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
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_19 ! -d $DNSMAP_RANGE -j MARK --set-mark 1
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_20 ! -d $DNSMAP_RANGE -j MARK --set-mark 1
#iptables -t mangle -A PREROUTING -m mark --mark 1 -j CONNMARK --save-mark
iptables -t nat -A PREROUTING -m mark --mark 1 -j CONNMARK --save-mark

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
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_09 -d $DNSMAP_RANGE -j dnsmap
#iptables -t nat -A PREROUTING -s $VPN_ADDR_4_10 -d $DNSMAP_RANGE -j dnsmap
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_11 -d $DNSMAP_RANGE -j dnsmap
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_12 -d $DNSMAP_RANGE -j dnsmap
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_13 -d $DNSMAP_RANGE -j dnsmap
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_14 -d $DNSMAP_RANGE -j dnsmap
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_15 -d $DNSMAP_RANGE -j dnsmap
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_16 -d $DNSMAP_RANGE -j dnsmap
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_17 -d $DNSMAP_RANGE -j dnsmap
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_18 -d $DNSMAP_RANGE -j dnsmap
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_19 -d $DNSMAP_RANGE -j dnsmap
iptables -t nat -A PREROUTING -s $VPN_ADDR_4_20 -d $DNSMAP_RANGE -j dnsmap

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
iptables -t nat -A POSTROUTING -s $VPN_ADDR_4_19 -o $WAN_4 -j MASQUERADE
iptables -t nat -A POSTROUTING -s $VPN_ADDR_4_20 -o $WAN_4 -j MASQUERADE

# Balanced Connections
#iptables -t nat -I PREROUTING -i $WAN_4 -p tcp -m tcp --dport 1194 -m conntrack --ctstate NEW -m statistic --mode random --probability 0.50000000000 -j REDIRECT --to-ports 1195
#iptables -t nat -I PREROUTING -i $WAN_4 -p tcp -m tcp --dport 1196 -m conntrack --ctstate NEW -m statistic --mode random --probability 0.50000000000 -j REDIRECT --to-ports 1197
#iptables -t nat -I PREROUTING -i $WAN_4 -p udp -m udp --dport 1194 -m conntrack --ctstate NEW -m statistic --mode random --probability 0.50000000000 -j REDIRECT --to-ports 1195
#iptables -t nat -I PREROUTING -i $WAN_4 -p udp -m udp --dport 1196 -m conntrack --ctstate NEW -m statistic --mode random --probability 0.50000000000 -j REDIRECT --to-ports 1197

### NO FERM - If you are not using ferm, then uncomment the following block of code ###

### DROP NETWORKS ###
### 224.0.0.0/4 (MULTICAST D)
### 240.0.0.0/5 (E)
iptables -I INPUT -i $WAN_4 -s 224.0.0.0/4 -j DROP
iptables -I INPUT -i $WAN_4 -s 240.0.0.0/5 -j DROP
iptables -t filter -I FORWARD -s 224.0.0.0/4 -j DROP
iptables -t filter -I FORWARD -s 240.0.0.0/4 -j DROP
### DROP NETWORKS ### 

### DROP TORRENTS ###
iptables -t filter -I FORWARD -m string --string "BitTorrent" --algo bm --to 65535 -j DROP
iptables -t filter -I FORWARD -m string --string "BitTorrent protocol" --algo bm --to 65535 -j DROP
#iptables -t filter -I FORWARD -m string --string "peer_id=" --algo bm --to 65535 -j DROP
#iptables -t filter -I FORWARD -m string --string ".torrent" --algo bm --to 65535 -j DROP
#iptables -t filter -I FORWARD -m string --string "announce.php?passkey=" --algo bm --to 65535 -j DROP
#iptables -t filter -I FORWARD -m string --string "torrent" --algo bm --to 65535 -j DROP
#iptables -t filter -I FORWARD -m string --string "announce" --algo bm --to 65535 -j DROP
#iptables -t filter -I FORWARD -m string --string "info_hash" --algo bm --to 65535 -j DROP
#iptables -t filter -I FORWARD -m string --string "get_peers" --algo bm --to 65535 -j DROP
#iptables -t filter -I FORWARD -m string --string "announce_peer" --algo bm --to 65535 -j DROP
#iptables -t filter -I FORWARD -m string --string "find_node" --algo bm --to 65535 -j DROP
# Attention! When using this rule, all domains and requests containing the word "tracker" will be dropped!
#iptables -t filter -I FORWARD -m string --string "tracker" --algo bm --to 65535 -j DROP
### DROP TORRENTS ###

#iptables -t mangle -A PREROUTING -m string --algo bm --string "BitTorrent" -j DROP
#iptables -t mangle -A PREROUTING -m string --string "get_peers" --algo bm -j DROP
#iptables -t mangle -A PREROUTING -m string --string "announce_peer" --algo bm -j DROP
#iptables -t mangle -A PREROUTING -m string --string "find_node" --algo bm -j DROP
iptables -t mangle -I PREROUTING -p udp -m string --algo bm --string "BitTorrent" -j DROP
iptables -t mangle -I PREROUTING -p udp -m string --algo bm --string "BitTorrent protocol" -j DROP
#iptables -t mangle -A PREROUTING -p udp -m string --algo bm --string "peer_id=" -j DROP
#iptables -t mangle -A PREROUTING -p udp -m string --algo bm --string ".torrent" -j DROP
#iptables -t mangle -A PREROUTING -p udp -m string --algo bm --string "announce.php?passkey=" -j DROP
#iptables -t mangle -A PREROUTING -p udp -m string --algo bm --string "torrent" -j DROP
#iptables -t mangle -A PREROUTING -p udp -m string --algo bm --string "announce" -j DROP
#iptables -t mangle -A PREROUTING -p udp -m string --algo bm --string "info_hash" -j DROP
#iptables -t mangle -A PREROUTING -p udp -m string --algo bm --string "tracker" -j DROP

iptables -t mangle -I POSTROUTING -p udp -m string --algo bm --string "BitTorrent" -j DROP
iptables -t mangle -I POSTROUTING -p udp -m string --algo bm --string "BitTorrent protocol" -j DROP
#iptables -t mangle -A POSTROUTING -p udp -m string --algo bm --string "peer_id=" -j DROP
#iptables -t mangle -A POSTROUTING -p udp -m string --algo bm --string ".torrent" -j DROP
#iptables -t mangle -A POSTROUTING -p udp -m string --algo bm --string "announce.php?passkey=" -j DROP
#iptables -t mangle -A POSTROUTING -p udp -m string --algo bm --string "torrent" -j DROP
#iptables -t mangle -A POSTROUTING -p udp -m string --algo bm --string "announce" -j DROP
#iptables -t mangle -A POSTROUTING -p udp -m string --algo bm --string "info_hash" -j DROP
#iptables -t mangle -A POSTROUTING -p udp -m string --algo bm --string "tracker" -j DROP

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
#	iptables -t filter -I FORWARD -i $VPN_NAME_INTERFACE1 -o $WAN_4 -p tcp -m tcp -m multiport --dports 22,25,465,587,1337,6969 -j REJECT
	iptables -t filter -I FORWARD -i $VPN_NAME_INTERFACE1 -o $WAN_4 -p tcp -m tcp -m multiport --dports 22,135:139,445,543,1337,6969 -j REJECT
	iptables -t filter -I FORWARD -i $VPN_NAME_INTERFACE1 -o $WAN_4 -p udp -m udp -m multiport --dports 22,135:139,445,543,1337,6969 -j REJECT
	# Mail
	iptables -t filter -I FORWARD -i $VPN_NAME_INTERFACE1 -o $WAN_4 -p tcp -m tcp -m multiport --dports 25,109 -j REJECT
	iptables -t filter -I FORWARD -i $VPN_NAME_INTERFACE1 -o $WAN_4 -p udp -m udp -m multiport --dports 25,109 -j REJECT
	# pop3 - 110,995
	# imap - 143,993
	# smtp - 25,465
	# pop2 - 109
	# Block all ports: 1024-65535 (test)
#	iptables -t filter -I FORWARD -i $VPN_NAME_INTERFACE1 -o $WAN_4 -p tcp -m tcp -m multiport --dports 1024:65535 -j REJECT
#	iptables -t filter -I FORWARD -i $VPN_NAME_INTERFACE1 -o $WAN_4 -p udp -m udp -m multiport --dports 1024:65535 -j REJECT
	# Block all ports, except: 80,443,109,110,995,143,993,465
#	iptables -t filter -I FORWARD -i $VPN_NAME_INTERFACE1 -o $WAN_4 -p tcp -m tcp -m multiport ! --dports 80,443,109,110,995,143,993,465 -j REJECT
#	iptables -t filter -I FORWARD -i $VPN_NAME_INTERFACE1 -o $WAN_4 -p udp -m udp -m multiport ! --dports 80,443,109,110,995,143,993,465 -j REJECT
done
# Если не указать айпишник либо сеть, то заблокируется любой форвард!
	# Block all ports, except: 80,443,109,110,995,143,993,465
# LostArk Game: 6010,6020,6040,22056
#	iptables -t filter -I FORWARD -p tcp -m tcp -m multiport ! --dports 80,443,109,110,995,143,993,465 -j REJECT
#	iptables -t filter -I FORWARD -p udp -m udp -m multiport ! --dports 80,443,109,110,995,143,993,465 -j REJECT
    iptables -t filter -I FORWARD -s 192.168.0.0/16 -p udp -m udp -m multiport ! --dports 1:1024,1194,1196,1200,2222,5432,8443,8080 -j REJECT
    iptables -t filter -I FORWARD -s 192.168.0.0/16 -p tcp -m tcp -m multiport ! --dports 1:1024,1194,1196,1200,2222,5432,8443,8080 -j REJECT
#    iptables -t filter -I FORWARD -s 192.168.0.0/16 -p udp -m udp -m multiport --dports 135:139,445,543,6969 -j REJECT
#    iptables -t filter -I FORWARD -s 192.168.0.0/16 -p tcp -m tcp -m multiport --dports 135:139,445,543,6969 -j REJECT
#    iptables -t filter -I FORWARD -s 192.168.0.0/16 -p udp -m udp -m multiport --dports 1024:65535 -j REJECT
#    iptables -t filter -I FORWARD -s 192.168.0.0/16 -p tcp -m tcp -m multiport --dports 1024:65535 -j REJECT

# 20251007
#	iptables -N LOG_CONN_LIMIT
#	iptables -A LOG_CONN_LIMIT -j LOG --log-prefix "CONNLIMIT DROP: " --log-level 4
#	iptables -A LOG_CONN_LIMIT -j REJECT
#	iptables -I FORWARD -s 192.168.0.0/16 -p tcp --syn -m connlimit --connlimit-above 1000 -j LOG_CONN_LIMIT
#	iptables -I FORWARD -s 192.168.0.0/16 -p udp -m connlimit --connlimit-above 200 -j LOG_CONN_LIMIT
# 20251007

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
#iptables -I FORWARD -i ppp+ -o $WAN_4 -d 0.0.0.0/0 -j ACCEPT
#iptables -I FORWARD -i zbrnfullacces -o $WAN_4 -d 0.0.0.0/0 -j ACCEPT
#iptables -t nat -I POSTROUTING -p tcp -s 192.168.203.0/24 -d 0.0.0.0/0 -o $WAN_4 -j MASQUERADE
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
# MyConf Full Access
#iptables -I FORWARD -i zbrnfullacces -o $WAN_4 -d 0.0.0.0/0 -j ACCEPT
#iptables -t nat -I POSTROUTING -p tcp -s 192.168.203.0/24 -d 0.0.0.0/0 -o $WAN_4 -j MASQUERADE
#iptables -I FORWARD -s 192.168.203.0/24 -o $WAN_4 -d 0.0.0.0/0 -j ACCEPT
#iptables -t nat -I PREROUTING -s 192.168.203.0/24 -p udp --dport 53 -j ACCEPT
### INDIVIDUAL CFG ###

#iptables -I FORWARD -i zaborona12 -o ens3 -d 0.0.0.0/0 -j ACCEPT
#iptables -t nat -I POSTROUTING -p tcp -s 192.168.220.0/22 -d 0.0.0.0/0 -o ens3 -j MASQUERADE
#iptables -I FORWARD -s 192.168.220.0/22 -o ens3 -d 0.0.0.0/0 -j ACCEPT
#iptables -t nat -I PREROUTING -s 192.168.220.0/22 -p udp --dport 53 -j ACCEPT
#
#iptables -I FORWARD -i zaborona13 -o ens3 -d 0.0.0.0/0 -j ACCEPT
#iptables -t nat -I POSTROUTING -p tcp -s 192.168.216.0/22 -d 0.0.0.0/0 -o ens3 -j MASQUERADE
#iptables -I FORWARD -s 192.168.216.0/22 -o ens3 -d 0.0.0.0/0 -j ACCEPT
#iptables -t nat -I PREROUTING -s 192.168.216.0/22 -p udp --dport 53 -j ACCEPT

# Tor DNS and Routes #
#iptables -t nat -I PREROUTING -p udp --dport 53 -m string --hex-string "|056f6e696f6e00|" --algo bm -j REDIRECT --to-ports 5300
#iptables -t nat -I OUTPUT -p udp --dport 53 -m string --hex-string "|056f6e696f6e00|" --algo bm -j REDIRECT --to-ports 5300
##iptables -t nat -I PREROUTING -p tcp -d 192.168.13.0/24 -j REDIRECT --to-port 9040
##iptables -t nat -I OUTPUT -p tcp -d 192.168.13.0/24 -j REDIRECT --to-port 9040
# Tor DNS and Routes #

# 20251007
#echo 1 > /proc/sys/net/ipv4/ip_forward
#sysctl -w net.netfilter.nf_conntrack_max=1048576
#sysctl -w net.netfilter.nf_conntrack_buckets=131072
# 20251007

# DNS REDIRECT: 127.0.0.5:53 -> 127.0.0.5:5359 (AdGuardHome)
# UDP
iptables -t nat -A OUTPUT -p udp -d 127.0.0.5 --dport 53 -j REDIRECT --to-ports 5359
# TCP
iptables -t nat -A OUTPUT -p tcp -d 127.0.0.5 --dport 53 -j REDIRECT --to-ports 5359

iptables -t nat -A OUTPUT -p udp -d 127.0.0.1 --dport 53 -j ACCEPT
iptables -t nat -A OUTPUT -p tcp -d 127.0.0.1 --dport 53 -j ACCEPT
iptables -t nat -A OUTPUT -p udp -d 127.0.0.5 --dport 53 -j ACCEPT
iptables -t nat -A OUTPUT -p tcp -d 127.0.0.5 --dport 53 -j ACCEPT
iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports 5359
iptables -t nat -A OUTPUT -p tcp --dport 53 -j REDIRECT --to-ports 5359

# Если предполагается использовать FERM, то эту строку нужно закомментировать!
/root/updateCFGzaboronaIPTablesWhiteList.sh

# Мы обнаружили сетевую атаку с IP-адреса из вашей сети.
# Подключённый к ней компьютер, вероятно, заражён и является частью ботнета.
/root/iptables_blockip.sh
 
exit 0
