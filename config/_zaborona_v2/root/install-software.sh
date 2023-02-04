#!/bin/sh
set -e

#HERE="$(dirname "$(readlink -f "${0}")")"
#cd "$HERE"

# Installing software for the correct work of the resolver ( Устанавливаем софт для корректрой работы резолвера )
echo "Installing software for the correct work of the resolver ( Устанавливаем софт для корректрой работы резолвера )"
apt install -y iptables curl pip python3 dnsmasq htop iftop net-tools git openvpn ferm idn

chmod +x ./dnsmap/*.sh
chmod +x ./dnsmap/*.py
chmod +x ./easy-rsa-ipsec/*.sh
chmod +x ./zaborona-vpn/*.sh
chmod +x ./zaborona-vpn/config/*.sh
chmod +x ./zaborona-vpn/scripts/*.py

cd "./zaborona-vpn"
./doall.sh
