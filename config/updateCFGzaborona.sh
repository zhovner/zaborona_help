#!/bin/bash
set -e

HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

#LISTLINK_ALLCONFIG="https:/raw.githubusercontent.com/zhovner/zaborona_help/master/config/_zaborona_v2/etc/dnsmasq.d/zaborona-dns-resovler"
LISTLINK_ALLCONFIG="https:/raw.githubusercontent.com/zhovner/zaborona_help/master/config/domainsdb.txt"
#LISTLINK_ALLCONFIG2="https:/zaborona.help/domainsdb.txt"

WORKFOLDERNAME="/tmp"
#WORKFOLDERNAME=$PWD/result
WORKFOLDERNAME2="/etc/dnsmasq.d"
FILENAMERESULT="zaborona-dns-resovler-tmp1"
FILENAMERESULT2="zaborona-dns-resovler-tmp2"
FILENAMERESULT3="zaborona-dns-resovler"
FILENAMERESULT4="domainsdb.txt"

#curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMERESULT3 "$LISTLINK_ALLCONFIG_DONE"

#FILENAMEALLCONFIG_INCLUDE1=

#for FILENAMEALLCONFIG_INCLUDE1 in $LISTLINK_ALLCONFIG; do
#	touch $WORKFOLDERNAME/$FILENAMERESULT3
#	LISTLINK_ALLCONFIG_DONE=$LISTLINK_ALLCONFIG/$FILENAMEALLCONFIG_INCLUDE1
	curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMERESULT4 "$LISTLINK_ALLCONFIG" &&
LISTSIZE="$(curl -sI --connect-timeout 15 "$LISTLINK_ALLCONFIG" | awk 'BEGIN {IGNORECASE=1;} /content-length/ {sub(/[ \t\r\n]+$/, "", $2); print $2}')"
[[ "$LISTSIZE" == "$(stat -c '%s' $WORKFOLDERNAME2/$FILENAMERESULT3)" ]] && echo "The files are the same ($WORKFOLDERNAME2/$FILENAMERESULT3)" && exit 2
#sort -u $WORKFOLDERNAME/$FILENAMEALLCONFIG_INCLUDE1 >> $WORKFOLDERNAME/$FILENAMERESULT2
#done

# Собираем все в один файл, чтобы за один раз прогнать все записи и не плодить много парсинга
#echo "Собираем все в один файл, чтобы за один раз прогнать все записи и не плодить много парсинга"

# Generate dnsmasq aliases
echo -n > $WORKFOLDERNAME/$FILENAMERESULT3
while read -r line
do
	# convert an IDN to Punycode
	PunycodeConvert="$(echo $line | idn)"
    echo "server=/$PunycodeConvert/127.0.0.4#5959" >> $WORKFOLDERNAME/$FILENAMERESULT3
done < $WORKFOLDERNAME/$FILENAMERESULT4

echo "Update File"
#sort -u $WORKFOLDERNAME/$FILENAMERESULT_TMP1 $WORKFOLDERNAME/$FILENAMERESULT_TMP2 $WORKFOLDERNAME/$FILENAMERESULT_TMP4 > $WORKFOLDERNAME/$FILENAMERESULT
mv $WORKFOLDERNAME/$FILENAMERESULT3 $WORKFOLDERNAME2/$FILENAMERESULT3

echo "Update File OK"

sleep 2

echo "DNSMASQ Restart"
systemctl reload dnsmasq

exit 0
