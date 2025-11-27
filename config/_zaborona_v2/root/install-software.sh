#!/bin/sh

# Checking root privileges
if [ "$(id -u)" -ne 0 ]
  then echo "Please run as root or use sudo"
  exit 1
fi

# Stop script on errors
#set -e

HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

# Full path to the current directory ( Полный путь до текущей директории )
$PWD

YUM_PACKAGE_NAME="iptables curl python3 dnsmasq htop iftop net-tools git openvpn idn zip unzip python3-pip python3-dnslib python-dnslib netdata sipcalc gawk"
DEB_PACKAGE_NAME="iptables curl python3 dnsmasq htop iftop net-tools git openvpn idn zip unzip python3-pip python3-dnslib netdata sipcalc gawk"
UBNT_PACKAGE_NAME="iptables curl python3 dnsmasq htop iftop net-tools git openvpn idn zip unzip python3-pip python3-dnslib python-dnslib netdata sipcalc gawk"

# Installing software for the correct work of the resolver ( Устанавливаем софт для корректрой работы резолвера )
echo "Installing software for the correct work of the resolver ( Устанавливаем софт для корректрой работы резолвера )"
#apt install -y iptables curl pip python3 dnsmasq knot-resolver htop iftop net-tools git openvpn idn zip unzip python3-pip python3-dnslib
#pip install dnslib
#apt install knot-resolver
## Ubuntu
#apt install -y python-dnslib
## apt install -y ferm
## apt install -y wireguard
## apt install -y pptpd
## apt install -y ikev2

# Check OS
 if cat /etc/*release | grep ^NAME | grep CentOS; then
    echo "==============================================="
    echo "Installing packages $YUM_PACKAGE_NAME on CentOS"
    echo "==============================================="
    yum install -y $YUM_PACKAGE_NAME
 elif cat /etc/*release | grep ^NAME | grep Red; then
    echo "==============================================="
    echo "Installing packages $YUM_PACKAGE_NAME on RedHat"
    echo "==============================================="
    yum install -y $YUM_PACKAGE_NAME
 elif cat /etc/*release | grep ^NAME | grep Fedora; then
    echo "================================================"
    echo "Installing packages $YUM_PACKAGE_NAME on Fedorea"
    echo "================================================"
    yum install -y $YUM_PACKAGE_NAME
 elif cat /etc/*release | grep ^NAME | grep Ubuntu; then
    echo "==============================================="
    echo "Installing packages $DEB_PACKAGE_NAME on Ubuntu"
    echo "==============================================="
    apt-get update
    apt-get install -y $DEB_PACKAGE_NAME
    pip install dnslib
 elif cat /etc/*release | grep ^NAME | grep Debian ; then
    echo "==============================================="
    echo "Installing packages $DEB_PACKAGE_NAME on Debian"
    echo "==============================================="
    apt-get update
    apt-get install -y $DEB_PACKAGE_NAME
 elif cat /etc/*release | grep ^NAME | grep Mint ; then
    echo "============================================="
    echo "Installing packages $DEB_PACKAGE_NAME on Mint"
    echo "============================================="
    apt-get update
    apt-get install -y $DEB_PACKAGE_NAME
 elif cat /etc/*release | grep ^NAME | grep Knoppix ; then
    echo "================================================="
    echo "Installing packages $DEB_PACKAGE_NAME on Kanoppix"
    echo "================================================="
    apt-get update
    apt-get install -y $DEB_PACKAGE_NAME
 else
    echo "OS NOT DETECTED, couldn't install package: $DEB_PACKAGE_NAME"
    exit 1;
 fi

### INSTALL FILES ###

# Проверяем, какой конфиг существует и запускаем нужный. Если присутствуют оба конфига, то приоритет отдается новому конфигу.
if [ -f $PWD/first-config-software.sh ]
then
	# First Config Software
	$PWD/first-config-software.sh
elif [ -f $PWD/first-config-software_oldcfg.sh ]
then
	# First Config Software (Old Configs)
	$PWD/first-config-software_oldcfg.sh
else
	echo "Не найдены файлы для старта конфигурации"
fi

exit 0