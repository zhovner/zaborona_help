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

### INSTALL FILES ###
LISTLINK_ALLCONFIG_ARCHIVE="https://raw.githubusercontent.com/zhovner/zaborona_help/master/config/_zaborona_v2"
FILENAMEALLCONFIG_ARCHIVE="zaborona-vpn-config-archive.zip"
FILENAMEALLCONFIG_ARCHIVE_MD5="zaborona-vpn-config-archive-MD5.zip"
WORKFOLDERNAME="/root"
TMPFOLDERNAME="/tmp"

# Если файл zaborona-vpn-config-archive-MD5.tar.gz отсутствует, то загружаем его и переименовываем для проверки MD5
if [ -f $WORKFOLDERNAME/$FILENAMEALLCONFIG_ARCHIVE_MD5 ]; then 
    echo "Update process. Wait for the process to complete. This may take several minutes."
	curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMEALLCONFIG_ARCHIVE "$LISTLINK_ALLCONFIG_ARCHIVE/FILENAMEALLCONFIG_ARCHIVE" || exit 1
else
    echo "Getting a file for MD5 verification."
	curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMEALLCONFIG_ARCHIVE "$LISTLINK_ALLCONFIG_ARCHIVE/FILENAMEALLCONFIG_ARCHIVE" || exit 1

	echo "Renaming the archive for counting MD5"
	# Переименовываем архив для подсчета MD5
	cp $WORKFOLDERNAME/$FILENAMEALLCONFIG_ARCHIVE $WORKFOLDERNAME/$FILENAMEALLCONFIG_ARCHIVE_MD5
fi

if [ md5sum $WORKFOLDERNAME/$FILENAMEALLCONFIG_ARCHIVE -eq md5sum $WORKFOLDERNAME/$FILENAMEALLCONFIG_ARCHIVE_MD5 ] ; then
    echo "No update needed. Do you have the latest version!"
else
    echo "Unpack the archive to the specified folder. Default /root"	
	# Распаковываем архив в указанную папку. По-умолчанию /root
	#tar xvzf $FILENAMEALLCONFIG_ARCHIVE -C $WORKFOLDERNAME
	unzip –d $TMPFOLDERNAME $FILENAMEALLCONFIG_ARCHIVE
	cp -vR $TMPFOLDERNAME/zaborona_help-master/config/_zaborona_v2/root/dnsmap $WORKFOLDERNAME/
	cp -vR $TMPFOLDERNAME/zaborona_help-master/config/_zaborona_v2/root/easy-rsa-ipsec $WORKFOLDERNAME/
	cp -vR $TMPFOLDERNAME/zaborona_help-master/config/_zaborona_v2/root/zaborona-vpn $WORKFOLDERNAME/
	rm -f $TMPFOLDERNAME/zaborona_help-master

	echo "Renaming the archive for counting MD5"
	# Переименовываем архив для подсчета MD5
	mv $WORKFOLDERNAME/$FILENAMEALLCONFIG_ARCHIVE $WORKFOLDERNAME/$FILENAMEALLCONFIG_ARCHIVE_MD5

	echo "We start updating configs after updating files"
	# Запускаем обновление конфигов после обновления файлов
	#./doall.sh
fi
### INSTALL FILES ###

cd "./zaborona-vpn"
#./doall.sh
