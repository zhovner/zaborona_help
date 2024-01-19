#!/bin/bash
set -e

HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

LISTLINK_ALLCONFIG="https:/raw.githubusercontent.com/zhovner/zaborona_help/master/config/openvpn/ccd3-4_max_routes/DEFAULT"

WORKFOLDERNAME0="ccd_zaborona_max_routes"
WORKFOLDERNAME="/tmp"
WORKFOLDERNAME2="/etc/openvpn/ccd_zaborona_max_routes"
WORKFOLDERNAME3="$WORKFOLDERNAME/$WORKFOLDERNAME0"
FILENAMERESULT="zaborona-dns-resovler-tmp1"
FILENAMERESULT2="zaborona-dns-resovler-tmp2"
FILENAMERESULT3="DEFAULT"

mkdir "$WORKFOLDERNAME/$WORKFOLDERNAME0"

#curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMERESULT3 "$LISTLINK_ALLCONFIG_DONE"

#FILENAMEALLCONFIG_INCLUDE1=

#for FILENAMEALLCONFIG_INCLUDE1 in $LISTLINK_ALLCONFIG; do
	touch $WORKFOLDERNAME3/$FILENAMERESULT3
#	LISTLINK_ALLCONFIG_DONE=$LISTLINK_ALLCONFIG/$FILENAMEALLCONFIG_INCLUDE1
	curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME3/$FILENAMERESULT3 "$LISTLINK_ALLCONFIG" &&
LISTSIZE="$(curl -sI --connect-timeout 15 "$LISTLINK_ALLCONFIG" | awk 'BEGIN {IGNORECASE=1;} /content-length/ {sub(/[ \t\r\n]+$/, "", $2); print $2}')"
[[ "$LISTSIZE" == "$(stat -c '%s' $WORKFOLDERNAME2/$FILENAMERESULT3)" ]] && echo "The files are the same ($WORKFOLDERNAME2/$FILENAMERESULT3)" && exit 2
#sort -u $WORKFOLDERNAME/$FILENAMEALLCONFIG_INCLUDE1 >> $WORKFOLDERNAME/$FILENAMERESULT2
#done

# Собираем все в один файл, чтобы за один раз прогнать все записи и не плодить много парсинга
#echo "Собираем все в один файл, чтобы за один раз прогнать все записи и не плодить много парсинга"
echo "Update File"
#sort -u $WORKFOLDERNAME/$FILENAMERESULT_TMP1 $WORKFOLDERNAME/$FILENAMERESULT_TMP2 $WORKFOLDERNAME/$FILENAMERESULT_TMP4 > $WORKFOLDERNAME/$FILENAMERESULT
mv $WORKFOLDERNAME3/$FILENAMERESULT3 $WORKFOLDERNAME2/$FILENAMERESULT3

echo "Update File OK"

#sleep 2

#echo "DNSMASQ Restart"
#systemctl restart dnsmasq

exit 0
