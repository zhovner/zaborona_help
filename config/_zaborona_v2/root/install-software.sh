#!/bin/sh
set -e

#HERE="$(dirname "$(readlink -f "${0}")")"
#cd "$HERE"

# Installing software for the correct work of the resolver ( Устанавливаем софт для корректрой работы резолвера )
echo "Installing software for the correct work of the resolver ( Устанавливаем софт для корректрой работы резолвера )"
apt install -y iptables curl pip python3 dnsmasq htop iftop net-tools git openvpn ferm idn

cd "./zaborona-vpn"
./doall.sh
