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

YUM_PACKAGE_NAME="iptables curl python3 dnsmasq htop iftop net-tools git openvpn idn zip unzip python3-pip python3-dnslib python-dnslib netdata sipcalc"
DEB_PACKAGE_NAME="iptables curl python3 dnsmasq htop iftop net-tools git openvpn idn zip unzip python3-pip python3-dnslib netdata sipcalc"
UBNT_PACKAGE_NAME="iptables curl python3 dnsmasq htop iftop net-tools git openvpn idn zip unzip python3-pip python3-dnslib python-dnslib netdata sipcalc"

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
LISTLINK_ALLCONFIG_ARCHIVE="https://raw.githubusercontent.com/zhovner/zaborona_help/master/config/_zaborona_v2"
FILENAMEALLCONFIG_ARCHIVE="zaborona-vpn-config-archive0.zip"
FILENAMEALLCONFIG_ARCHIVE_MD5="zaborona-vpn-config-archive-MD5.zip"
WORKFOLDERNAME=$PWD
TMPFOLDERNAME="/tmp"
#MD51="$(md5sum $WORKFOLDERNAME/$FILENAMEALLCONFIG_ARCHIVE | awk '{print $1}')"
#MD52="$(md5sum $WORKFOLDERNAME/$FILENAMEALLCONFIG_ARCHIVE_MD5 | awk '{print $1}')"

#curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMEALLCONFIG_ARCHIVE "$LISTLINK_ALLCONFIG_ARCHIVE/$FILENAMEALLCONFIG_ARCHIVE" || exit 1

if  curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMEALLCONFIG_ARCHIVE "$LISTLINK_ALLCONFIG_ARCHIVE/$FILENAMEALLCONFIG_ARCHIVE"; then
    echo "Unpack the archive to the specified folder. Default $PWD"	
    # Распаковываем архив в указанную папку. По-умолчанию $PWD
    #tar xvzf $FILENAMEALLCONFIG_ARCHIVE -C $WORKFOLDERNAME
    unzip -o $WORKFOLDERNAME/$FILENAMEALLCONFIG_ARCHIVE
    cp -vR $WORKFOLDERNAME/zaborona_help-master/config/_zaborona_v2/root/dnsmap $WORKFOLDERNAME/
    cp -vR $WORKFOLDERNAME/zaborona_help-master/config/_zaborona_v2/root/easy-rsa-ipsec $WORKFOLDERNAME/
    cp -vR $WORKFOLDERNAME/zaborona_help-master/config/_zaborona_v2/root/zaborona-vpn $WORKFOLDERNAME/
    rm -r $WORKFOLDERNAME/zaborona_help-master

else

    # If the previous command ended with an error (for example, there is no such file), then download it via git
    # Если предыдущая команда закончилась с ошибкой (например такого файла нет), то скачиваем через git
    #cd $WORKFOLDERNAME && git fetch --all && git reset --hard origin/prod
    git clone https://github.com/zhovner/zaborona_help
    cp -vR $WORKFOLDERNAME/zaborona_help/config/_zaborona_v2/root/dnsmap $WORKFOLDERNAME/
    cp -vR $WORKFOLDERNAME/zaborona_help/config/_zaborona_v2/root/easy-rsa-ipsec $WORKFOLDERNAME/
    cp -vR $WORKFOLDERNAME/zaborona_help/config/_zaborona_v2/root/zaborona-vpn $WORKFOLDERNAME/
    rm -r $WORKFOLDERNAME/zaborona_help

fi

chmod +x ./dnsmap/*.sh
chmod +x ./dnsmap/*.py
chmod +x ./easy-rsa-ipsec/*.sh
chmod +x ./zaborona-vpn/*.sh
chmod +x ./zaborona-vpn/config/*.sh
chmod +x ./zaborona-vpn/scripts/*.py

#echo "Edit the netdata config and restart the service"
## Редактируем конфиг netdata и перезапускаем службу
#sed -i 's/127.0.0.1/0.0.0.0/' /etc/netdata/netdata.conf
#service netdata restart

#echo "To add it to the crontab, with no duplication"
## Добавления задания в crontab с проверкой дублирования
#croncmd="# Check Alive Server\n* * * * * curl -X POST -F 'server=zbrn-srv-ovh10' http://samp.monitor.example.com/tgbot_take.php"
#cronjob="0 */15 * * * $croncmd"
#( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -
#croncmd="# Update DNS\n0 0 * * * /root/updateCFGzaborona.sh"
#cronjob="0 */15 * * * $croncmd"
#( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -
#croncmd="# Update IPTables (without restarting ferm)\n0 0 * * * /root/updateCFGzaboronaIPTables.sh"
#cronjob="0 */15 * * * $croncmd"
#( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -
#croncmd="# Update FERM IPv4\n0 0 * * * /root/updateCFGzaboronaIPTablesFREM.sh"
#cronjob="0 */15 * * * $croncmd"
#( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -
#croncmd="# Update FERM IPv6\n0 0 * * * /root/updateCFGzaboronaIPTablesFREM-ipv6.sh"
#cronjob="0 */15 * * * $croncmd"
#( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -
#croncmd="# Update OpenVPN Routes\n0 0 * * * /root/updateCFGzaboronaOpenVPNRoutesNEW.sh"
#cronjob="0 */15 * * * $croncmd"
#( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -
#croncmd="# Update OpenVPN BIG Routes\n0 0 * * * /root/updateCFGzaboronaOpenVPNRoutesBIG.sh"
#cronjob="0 */15 * * * $croncmd"
#( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -

echo "We start updating configs after updating files"
# Запускаем обновление конфигов после обновления файлов
#cd "./zaborona-vpn"
#./doall.sh

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