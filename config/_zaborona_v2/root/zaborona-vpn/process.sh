#!/bin/bash
set -e

#cp result/knot-aliases-alt.conf /etc/knot-resolver/knot-aliases-alt.conf
#systemctl restart kresd@1.service

cp result/dnsmasq-aliases-alt.conf /etc/dnsmasq.d/zaborona-dns-resovler
systemctl restart dnsmasq

cp result/openvpn-blocked-ranges.txt /etc/openvpn/server/ccd/DEFAULT

iptables -F zbrnhlpvpnwhitelist

echo "" > result/openvpn-blocked-ranges-ferm-whitelist.conf
echo "# dummy file. Filled by zaboronahelp script." >> result/openvpn-blocked-ranges-ferm-whitelist.conf
echo "@def $WHITELIST = (" >> result/openvpn-blocked-ranges-ferm-whitelist.conf

while read -r line
do
    iptables -w -A zbrnhlpvpnwhitelist -d "$line" -j ACCEPT
    echo "$line" >> result/openvpn-blocked-ranges-ferm-whitelist.conf

done < result/blocked-ranges.txt

echo ");" >> result/openvpn-blocked-ranges-ferm-whitelist.conf

exit 0
