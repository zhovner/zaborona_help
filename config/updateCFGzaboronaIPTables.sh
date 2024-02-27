#!/bin/bash
set -e

HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

#LISTLINK_ALLCONFIG="https:/raw.githubusercontent.com/zhovner/zaborona_help/master/config/updateCFGzaboronaIPTables.txt"
LISTLINK_ALLCONFIG="https:/raw.githubusercontent.com/zhovner/zaborona_help/master/config/ipsdbnewip.txt"

WORKFOLDERNAME="/tmp"
#WORKFOLDERNAME=$PWD/result
#WORKFOLDERNAME2="/root"
WORKFOLDERNAME2=$PWD
FILENAMERESULT="updateCFGzaboronaIPTables-tmp1"
FILENAMERESULT2="updateCFGzaboronaIPTables-tmp2"
FILENAMERESULT3="updateCFGzaboronaIPTables.txt"
FILENAMERESULT4="ipsdbnewip.txt"

#curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMERESULT3 "$LISTLINK_ALLCONFIG_DONE"

#FILENAMEALLCONFIG_INCLUDE1=

#for FILENAMEALLCONFIG_INCLUDE1 in $LISTLINK_ALLCONFIG; do
#	touch $WORKFOLDERNAME/$FILENAMERESULT3
#	LISTLINK_ALLCONFIG_DONE=$LISTLINK_ALLCONFIG/$FILENAMEALLCONFIG_INCLUDE1
#	curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMERESULT3 "$LISTLINK_ALLCONFIG" &&
#LISTSIZE="$(curl -sI --connect-timeout 15 "$LISTLINK_ALLCONFIG" | awk 'BEGIN {IGNORECASE=1;} /content-length/ {sub(/[ \t\r\n]+$/, "", $2); print $2}')"
#[[ "$LISTSIZE" == "$(stat -c '%s' $WORKFOLDERNAME2/$FILENAMERESULT3)" ]] && echo "The files are the same ($WORKFOLDERNAME2/$FILENAMERESULT3)" && exit 2

	curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMERESULT4 "$LISTLINK_ALLCONFIG" &&
LISTSIZE="$(curl -sI --connect-timeout 15 "$LISTLINK_ALLCONFIG" | awk 'BEGIN {IGNORECASE=1;} /content-length/ {sub(/[ \t\r\n]+$/, "", $2); print $2}')"
[[ "$LISTSIZE" == "$(stat -c '%s' $WORKFOLDERNAME2/$FILENAMERESULT3)" ]] && echo "The files are the same ($WORKFOLDERNAME2/$FILENAMERESULT4)" && exit 2

#sort -u $WORKFOLDERNAME/$FILENAMEALLCONFIG_INCLUDE1 >> $WORKFOLDERNAME/$FILENAMERESULT2
#done

# Собираем все в один файл, чтобы за один раз прогнать все записи и не плодить много парсинга
#echo "Собираем все в один файл, чтобы за один раз прогнать все записи и не плодить много парсинга"
echo "Update File"
#sort -u $WORKFOLDERNAME/$FILENAMERESULT_TMP1 $WORKFOLDERNAME/$FILENAMERESULT_TMP2 $WORKFOLDERNAME/$FILENAMERESULT_TMP4 > $WORKFOLDERNAME/$FILENAMERESULT
mv $WORKFOLDERNAME/$FILENAMERESULT4 $WORKFOLDERNAME2/$FILENAMERESULT3

while read -r line
do
    iptables -w -A ZABORONA_V4 -d "$line" -j ACCEPT

done < /$WORKFOLDERNAME2/$FILENAMERESULT3

echo "Update File OK"

exit 0
