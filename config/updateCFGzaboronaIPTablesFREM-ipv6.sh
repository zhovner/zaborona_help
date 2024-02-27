#!/bin/bash
set -e

HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

#LISTLINK_ALLCONFIG="https:/raw.githubusercontent.com/zhovner/zaborona_help/master/config/ferm/whitelist_ipv6.conf"
LISTLINK_ALLCONFIG="https:/raw.githubusercontent.com/zhovner/zaborona_help/master/config/ipsdb_v6.txt"

WORKFOLDERNAME="/tmp"
WORKFOLDERNAME2="/etc/ferm"
WORKFOLDERNAME3=$PWD
FILENAMERESULT="zaborona-dns-resovler-tmp1"
FILENAMERESULT2="zaborona-dns-resovler-tmp2"
FILENAMERESULT3="whitelist_ipv6.conf"
FILENAMERESULT4="ipsdbFERM_v6.txt"

#curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMERESULT3 "$LISTLINK_ALLCONFIG_DONE"

#FILENAMEALLCONFIG_INCLUDE1=

#for FILENAMEALLCONFIG_INCLUDE1 in $LISTLINK_ALLCONFIG; do
#	touch $WORKFOLDERNAME/$FILENAMERESULT3
##	LISTLINK_ALLCONFIG_DONE=$LISTLINK_ALLCONFIG/$FILENAMEALLCONFIG_INCLUDE1
#	curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMERESULT3 "$LISTLINK_ALLCONFIG" &&
#LISTSIZE="$(curl -sI --connect-timeout 15 "$LISTLINK_ALLCONFIG" | awk 'BEGIN {IGNORECASE=1;} /content-length/ {sub(/[ \t\r\n]+$/, "", $2); print $2}')"
#[[ "$LISTSIZE" == "$(stat -c '%s' $WORKFOLDERNAME2/$FILENAMERESULT3)" ]] && echo "The files are the same ($WORKFOLDERNAME2/$FILENAMERESULT3)" && exit 2

	curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMERESULT4 "$LISTLINK_ALLCONFIG" &&
LISTSIZE="$(curl -sI --connect-timeout 15 "$LISTLINK_ALLCONFIG" | awk 'BEGIN {IGNORECASE=1;} /content-length/ {sub(/[ \t\r\n]+$/, "", $2); print $2}')"
[[ "$LISTSIZE" == "$(stat -c '%s' $WORKFOLDERNAME2/$FILENAMERESULT3)" ]] && echo "The files are the same ($WORKFOLDERNAME2/$FILENAMERESULT3)" && exit 2

#sort -u $WORKFOLDERNAME/$FILENAMEALLCONFIG_INCLUDE1 >> $WORKFOLDERNAME/$FILENAMERESULT2
#done

# Собираем все в один файл, чтобы за один раз прогнать все записи и не плодить много парсинга
#echo "Собираем все в один файл, чтобы за один раз прогнать все записи и не плодить много парсинга"

	# Generate ferm file - IP ACCEPT
	cp $WORKFOLDERNAME3/updateCFGzaboronaIPTablesFREM-ipv6_header.txt $WORKFOLDERNAME/$FILENAMERESULT3
	
	while read -r line
	do
		#iptables -w -A ZABORONA_V4 -d "$line" -j ACCEPT
		echo "$line" >> $WORKFOLDERNAME/$FILENAMERESULT3
	
	done < $WORKFOLDERNAME/$FILENAMERESULT4
	
	echo ");\n" >> $WORKFOLDERNAME/$FILENAMERESULT3

echo "Update File"
#sort -u $WORKFOLDERNAME/$FILENAMERESULT_TMP1 $WORKFOLDERNAME/$FILENAMERESULT_TMP2 $WORKFOLDERNAME/$FILENAMERESULT_TMP4 > $WORKFOLDERNAME/$FILENAMERESULT
mv $WORKFOLDERNAME/$FILENAMERESULT3 $WORKFOLDERNAME2/$FILENAMERESULT3

echo "Update File OK"

#sleep 2

#echo "FERM Restart"
#systemctl restart ferm

exit 0
