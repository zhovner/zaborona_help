#!/bin/bash
set -e

HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

#LISTLINK_ALLCONFIG="https:/raw.githubusercontent.com/zhovner/zaborona_help/master/config/_zaborona_v2/etc/dnsmasq.d/zaborona-dns-resovler"
LISTLINK_ALLCONFIG="https:/raw.githubusercontent.com/zhovner/zaborona_help/master/config/domainsdb.txt"
#LISTLINK_ALLCONFIG2="https:/zaborona.help/domainsdb.txt"

#WORKFOLDERNAME="/tmp"
#WORKFOLDERNAME=$PWD/result
WORKFOLDERNAME=$PWD
#WORKFOLDERNAME2="/etc/dnsmasq.d"
FILENAMERESULT="zaborona-dns-resovler-tmp1"
FILENAMERESULT2="zaborona-dns-resovler-tmp2"
FILENAMERESULT3="domainsdb_webproxy.txt"
FILENAMERESULT4="domainsdb_originalFormat.txt"
FILENAMERESULT5="domainsdb_checked.txt"
FILENAMERESULT6="domainsdb_webproxy_allsubdomains.txt"
FILENAMERESULT7="domainsdb_webproxy_done.txt"
FILENAMERESULT8="domainsdb_webproxy_done2.txt"

#curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMERESULT3 "$LISTLINK_ALLCONFIG_DONE"

#FILENAMEALLCONFIG_INCLUDE1=

#for FILENAMEALLCONFIG_INCLUDE1 in $LISTLINK_ALLCONFIG; do
#	touch $WORKFOLDERNAME/$FILENAMERESULT3
#	LISTLINK_ALLCONFIG_DONE=$LISTLINK_ALLCONFIG/$FILENAMEALLCONFIG_INCLUDE1
	curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMERESULT4 "$LISTLINK_ALLCONFIG" &&
LISTSIZE="$(curl -sI --connect-timeout 15 "$LISTLINK_ALLCONFIG" | awk 'BEGIN {IGNORECASE=1;} /content-length/ {sub(/[ \t\r\n]+$/, "", $2); print $2}')"
[[ "$LISTSIZE" == "$(stat -c '%s' $WORKFOLDERNAME/$FILENAMERESULT5)" ]] && echo "The files are the same ($WORKFOLDERNAME/$FILENAMERESULT5)" && exit 2
#done

# Заменяем временную базу доменов, если файл со списком доменов изменился, который мы загружаем из стороннего ресурса
cp $WORKFOLDERNAME/$FILENAMERESULT4 $WORKFOLDERNAME/$FILENAMERESULT3

cp $WORKFOLDERNAME/$FILENAMERESULT4 $WORKFOLDERNAME/$FILENAMERESULT5

# Удаляем пустые строки и коментарии из файла
sed -i -e '/^#/d' -e '/^$/d' $WORKFOLDERNAME/$FILENAMERESULT3

# Создаем очищенный файл с новым именем
cp $WORKFOLDERNAME/$FILENAMERESULT3 $WORKFOLDERNAME/$FILENAMERESULT6

# Добавляем префикс
sed -i -e 's/^/*./' $WORKFOLDERNAME/$FILENAMERESULT6

# Добавляем префикс для всех субдоменов
echo "*.ru" >> $WORKFOLDERNAME/$FILENAMERESULT6

sort -u $WORKFOLDERNAME/$FILENAMERESULT3 $WORKFOLDERNAME/$FILENAMERESULT6 > $WORKFOLDERNAME/$FILENAMERESULT7

# Убираем перенос строк и ставим запятую вместо переноса строки
paste -s -d ',' $WORKFOLDERNAME/$FILENAMERESULT7 > $WORKFOLDERNAME/$FILENAMERESULT8

cp $WORKFOLDERNAME/$FILENAMERESULT8 $WORKFOLDERNAME/webproxywhitelist.cfg
mv $WORKFOLDERNAME/webproxywhitelist.cfg /etc/3proxy/whitelist.cfg

echo "Update File OK"

echo "3proxy Restart"
#/etc/init.d/3proxy stop
#sleep 5
#/etc/init.d/3proxy start
/etc/init.d/3proxy reload

exit 0
