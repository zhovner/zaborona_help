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

# Get hostname
HOSTNAME="$(hostname)"

# Get master interface name
MASTERIF="$(ls /sys/class/net | awk '{print $1}' | head -n 1)"

### CONFIG FILES ###
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
	cp -vR $WORKFOLDERNAME/zaborona_help-master/config/_zaborona_v2/etc/dnsmasq.d/zaborona /etc/dnsmasq.d/zaborona
	cp -vR $WORKFOLDERNAME/zaborona_help-master/config/_zaborona_v2/etc/dnsmasq.d/zaborona-dns-resovler /etc/dnsmasq.d/zaborona-dns-resovler
	cp -vR $WORKFOLDERNAME/zaborona_help-master/config/_zaborona_v2/etc/sysctl.d/99-openvpn.conf /etc/sysctl.d/99-openvpn.conf
	cp -vR $WORKFOLDERNAME/zaborona_help-master/config/_zaborona_v2/etc/sysctl.d/99-swap.conf /etc/sysctl.d/99-swap.conf
	cp -vR $WORKFOLDERNAME/zaborona_help-master/config/_zaborona_v2/etc/systemd/system/openvpn-server@.service.d /etc/systemd/system/
	cp -vR $WORKFOLDERNAME/zaborona_help-master/config/_zaborona_v2/etc/systemd/system/dnsmap.service /etc/systemd/system/dnsmap.service
	cp -vR $WORKFOLDERNAME/zaborona_help-master/config/_zaborona_v2/etc/systemd/system/firewall-config-script-custom.service /etc/systemd/system/firewall-config-script-custom.service
	cp -vR $WORKFOLDERNAME/zaborona_help-master/config/_zaborona_v2/etc/systemd/system/iperf3.service /etc/systemd/system/iperf3.service
	cp -vR $WORKFOLDERNAME/zaborona_help-master/config/_zaborona_v2/etc/openvpn/*.conf /etc/openvpn/
	cp -vR $WORKFOLDERNAME/zaborona_help-master/config/_zaborona_v2/etc/openvpn/*.crt /etc/openvpn/
	cp -vR $WORKFOLDERNAME/zaborona_help-master/config/_zaborona_v2/etc/openvpn/*.pem /etc/openvpn/
	cp -vR $WORKFOLDERNAME/zaborona_help-master/config/_zaborona_v2/etc/openvpn/logs /etc/openvpn/
	cp -vR $WORKFOLDERNAME/zaborona_help-master/config/_zaborona_v2/etc/openvpn/ccd /etc/openvpn/
	cp -vR $WORKFOLDERNAME/zaborona_help-master/config/_zaborona_v2/etc/openvpn/ccd_zaborona /etc/openvpn/
	cp -vR $WORKFOLDERNAME/zaborona_help-master/config/_zaborona_v2/etc/openvpn/ccd_zaborona_big_routes /etc/openvpn/
	cp -vR $WORKFOLDERNAME/zaborona_help-master/config/_zaborona_v2/etc/openvpn/ccd_zaborona_max_routes /etc/openvpn/
	cp -vR $WORKFOLDERNAME/zaborona_help-master/config/_zaborona_v2/etc/openvpn/ccd_zaborona_ru_routes /etc/openvpn/
    rm -r $WORKFOLDERNAME/zaborona_help-master

else

    # If the previous command ended with an error (for example, there is no such file), then download it via git
    # Если предыдущая команда закончилась с ошибкой (например такого файла нет), то скачиваем через git
    #cd $WORKFOLDERNAME && git fetch --all && git reset --hard origin/prod
    git clone https://github.com/zhovner/zaborona_help
    cp -vR $WORKFOLDERNAME/zaborona_help/config/_zaborona_v2/root/dnsmap $WORKFOLDERNAME/
    cp -vR $WORKFOLDERNAME/zaborona_help/config/_zaborona_v2/root/easy-rsa-ipsec $WORKFOLDERNAME/
    cp -vR $WORKFOLDERNAME/zaborona_help/config/_zaborona_v2/root/zaborona-vpn $WORKFOLDERNAME/
	cp -vR $WORKFOLDERNAME/zaborona_help/config/_zaborona_v2/etc/dnsmasq.d/zaborona /etc/dnsmasq.d/zaborona
	cp -vR $WORKFOLDERNAME/zaborona_help/config/_zaborona_v2/etc/dnsmasq.d/zaborona-dns-resovler /etc/dnsmasq.d/zaborona-dns-resovler
	cp -vR $WORKFOLDERNAME/zaborona_help/config/_zaborona_v2/etc/sysctl.d/99-openvpn.conf /etc/sysctl.d/99-openvpn.conf
	cp -vR $WORKFOLDERNAME/zaborona_help/config/_zaborona_v2/etc/sysctl.d/99-swap.conf /etc/sysctl.d/99-swap.conf
	cp -vR $WORKFOLDERNAME/zaborona_help/config/_zaborona_v2/etc/systemd/system/openvpn-server@.service.d /etc/systemd/system/
	cp -vR $WORKFOLDERNAME/zaborona_help/config/_zaborona_v2/etc/systemd/system/dnsmap.service /etc/systemd/system/dnsmap.service
	cp -vR $WORKFOLDERNAME/zaborona_help/config/_zaborona_v2/etc/systemd/system/firewall-config-script-custom.service /etc/systemd/system/firewall-config-script-custom.service
	cp -vR $WORKFOLDERNAME/zaborona_help/config/_zaborona_v2/etc/systemd/system/iperf3.service /etc/systemd/system/iperf3.service
	cp -vR $WORKFOLDERNAME/zaborona_help/config/_zaborona_v2/etc/openvpn/*.conf /etc/openvpn/
	cp -vR $WORKFOLDERNAME/zaborona_help/config/_zaborona_v2/etc/openvpn/*.crt /etc/openvpn/
	cp -vR $WORKFOLDERNAME/zaborona_help/config/_zaborona_v2/etc/openvpn/*.pem /etc/openvpn/
	cp -vR $WORKFOLDERNAME/zaborona_help/config/_zaborona_v2/etc/openvpn/logs /etc/openvpn/
	cp -vR $WORKFOLDERNAME/zaborona_help/config/_zaborona_v2/etc/openvpn/ccd /etc/openvpn/
	cp -vR $WORKFOLDERNAME/zaborona_help/config/_zaborona_v2/etc/openvpn/ccd_zaborona /etc/openvpn/
	cp -vR $WORKFOLDERNAME/zaborona_help/config/_zaborona_v2/etc/openvpn/ccd_zaborona_big_routes /etc/openvpn/
	cp -vR $WORKFOLDERNAME/zaborona_help/config/_zaborona_v2/etc/openvpn/ccd_zaborona_max_routes /etc/openvpn/
	cp -vR $WORKFOLDERNAME/zaborona_help/config/_zaborona_v2/etc/openvpn/ccd_zaborona_ru_routes /etc/openvpn/
    rm -r $WORKFOLDERNAME/zaborona_help

fi

chmod +x $WORKFOLDERNAME/dnsmap/*.sh
chmod +x $WORKFOLDERNAME/dnsmap/*.py
chmod +x $WORKFOLDERNAME/easy-rsa-ipsec/*.sh
chmod +x $WORKFOLDERNAME/zaborona-vpn/*.sh
chmod +x $WORKFOLDERNAME/zaborona-vpn/config/*.sh
chmod +x $WORKFOLDERNAME/zaborona-vpn/scripts/*.py

echo "Edit the netdata config and restart the service"
# Редактируем конфиг netdata и перезапускаем службу
sed -i 's/127.0.0.1/0.0.0.0/' /etc/netdata/netdata.conf
service netdata restart

echo "We re-read the start scripts so that the changes take effect."
# Перечитываем стартовые скрипты, чтобы изменения вступили в силу.
systemctl daemon-reload

echo "We add it to startup and immediately start both OpenVPN processes."
# Добавляем в автозагрузку и сразу стартуем оба процесса OpenVPN.
systemctl enable openvpn@zaborona1
systemctl enable openvpn@zaborona2
systemctl enable openvpn@zaborona3
systemctl enable openvpn@zaborona4
systemctl enable openvpn@zaborona5udp
systemctl enable openvpn@zaborona6udp
systemctl enable openvpn@zaborona7udp
systemctl enable openvpn@zaborona8udp
systemctl enable openvpn@zaborona12
systemctl enable openvpn@zaborona13udp
echo "!!! Скопировать crt и key !!! Иначе OpenVPN не запустится!"

echo "Restart the dnsmasq and ferm services. They are added to startup by default after installation."
# Перезапускаем сервисы dnsmasq и ferm. Они добавлены в автозагрузку по умолчанию после установки.
systemctl reload dnsmasq
#systemctl reload ferm

echo "We get the name of the interface that looks at the Internet, write it in the file and launch the file for execution"
# Получаем имя интерфейса, который смотрит в интернет, прописываем его в файле и запускаем файл на выполнение
sed -i 's/WAN_4="changeIF"/WAN_4="$MASTERIF"/' $WORKFOLDERNAME/zaborona-vpn/iptables-custom.sh
sed -i 's/WAN_6="changeIF"/WAN_6="$MASTERIF"/' $WORKFOLDERNAME/zaborona-vpn/iptables-custom.sh
$WORKFOLDERNAME/zaborona-vpn/iptables-custom.sh

echo "To add it to the crontab, with no duplication"
# Добавления задания в crontab с проверкой дублирования
croncmd="#* * * * * curl -X POST -F 'server=zbrn-srv-$HOSTNAME' http://samp.monitor.example.com/tgbot_take.php"
cronjob="# Check Alive Server\n $croncmd"
( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -
croncmd="0 0 * * * /root/updateCFGzaborona.sh"
cronjob="# Update DNS\n $croncmd"
( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -
croncmd="0 0 * * * /root/updateCFGzaboronaIPTables.sh"
cronjob="# Update IPTables (without restarting ferm)\n $croncmd"
( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -
croncmd="0 0 * * * /root/updateCFGzaboronaIPTablesFREM.sh"
cronjob="# Update FERM IPv4\n $croncmd"
( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -
croncmd="0 0 * * * /root/updateCFGzaboronaIPTablesFREM-ipv6.sh"
cronjob="# Update FERM IPv6\n $croncmd"
( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -
croncmd="0 0 * * * /root/updateCFGzaboronaOpenVPNRoutesNEW.sh"
cronjob="# Update OpenVPN Routes\n $croncmd"
( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -
croncmd="0 0 * * * /root/updateCFGzaboronaOpenVPNRoutesBIG.sh"
cronjob="# Update OpenVPN BIG Routes\n $croncmd"
( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -

echo "We start updating configs after updating files"
# Запускаем обновление конфигов после обновления файлов
#cd "./zaborona-vpn"
#./doall.sh

### CONFIG FILES ###

exit 0