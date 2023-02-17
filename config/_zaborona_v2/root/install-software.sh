#!/bin/sh
#set -e

#HERE="$(dirname "$(readlink -f "${0}")")"
#cd "$HERE"

# Installing software for the correct work of the resolver ( Устанавливаем софт для корректрой работы резолвера )
echo "Installing software for the correct work of the resolver ( Устанавливаем софт для корректрой работы резолвера )"
apt install -y iptables curl pip python3 dnsmasq htop iftop net-tools git openvpn idn zip unzip python3-pip
pip install dnslib
# apt install -y ferm
# apt install -y wireguard
# apt install -y pptpd
# apt install -y ikev2

### INSTALL FILES ###
LISTLINK_ALLCONFIG_ARCHIVE="https://raw.githubusercontent.com/zhovner/zaborona_help/master/config/_zaborona_v2"
FILENAMEALLCONFIG_ARCHIVE="zaborona-vpn-config-archive.zip"
FILENAMEALLCONFIG_ARCHIVE_MD5="zaborona-vpn-config-archive-MD5.zip"
WORKFOLDERNAME="/root"
TMPFOLDERNAME="/tmp"
#MD51="$(md5sum $WORKFOLDERNAME/$FILENAMEALLCONFIG_ARCHIVE | awk '{print $1}')"
#MD52="$(md5sum $WORKFOLDERNAME/$FILENAMEALLCONFIG_ARCHIVE_MD5 | awk '{print $1}')"

curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMEALLCONFIG_ARCHIVE "$LISTLINK_ALLCONFIG_ARCHIVE/$FILENAMEALLCONFIG_ARCHIVE" || exit 1

echo "Unpack the archive to the specified folder. Default /root"	
# Распаковываем архив в указанную папку. По-умолчанию /root
#tar xvzf $FILENAMEALLCONFIG_ARCHIVE -C $WORKFOLDERNAME
unzip -o $WORKFOLDERNAME/$FILENAMEALLCONFIG_ARCHIVE
cp -vR $WORKFOLDERNAME/zaborona_help-master/config/_zaborona_v2/root/dnsmap $WORKFOLDERNAME/
cp -vR $WORKFOLDERNAME/zaborona_help-master/config/_zaborona_v2/root/easy-rsa-ipsec $WORKFOLDERNAME/
cp -vR $WORKFOLDERNAME/zaborona_help-master/config/_zaborona_v2/root/zaborona-vpn $WORKFOLDERNAME/
rm -r $WORKFOLDERNAME/zaborona_help-master

chmod +x ./dnsmap/*.sh
chmod +x ./dnsmap/*.py
chmod +x ./easy-rsa-ipsec/*.sh
chmod +x ./zaborona-vpn/*.sh
chmod +x ./zaborona-vpn/config/*.sh
chmod +x ./zaborona-vpn/scripts/*.py

echo "We start updating configs after updating files"
# Запускаем обновление конфигов после обновления файлов
#cd "./zaborona-vpn"
#./doall.sh

### INSTALL FILES ###
