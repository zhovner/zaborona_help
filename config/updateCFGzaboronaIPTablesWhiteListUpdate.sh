#!/bin/bash
set -e

HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

LISTLINK_ALLCONFIG="https:/raw.githubusercontent.com/zhovner/zaborona_help/master/config/updateCFGzaboronaIPTablesWhiteList.txt"

WORKFOLDERNAME="/tmp"
WORKFOLDERNAME2="/root"
FILENAMERESULT="updateCFGzaboronaIPTablesWhiteList-tmp1"
FILENAMERESULT2="updateCFGzaboronaIPTablesWhiteList-tmp2"
FILENAMERESULT3="updateCFGzaboronaIPTablesWhiteList.txt"

	touch $WORKFOLDERNAME/$FILENAMERESULT3
#	LISTLINK_ALLCONFIG_DONE=$LISTLINK_ALLCONFIG/$FILENAMEALLCONFIG_INCLUDE1
	curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMERESULT3 "$LISTLINK_ALLCONFIG" &&
LISTSIZE="$(curl -sI --connect-timeout 15 "$LISTLINK_ALLCONFIG" | awk 'BEGIN {IGNORECASE=1;} /content-length/ {sub(/[ \t\r\n]+$/, "", $2); print $2}')"
[[ "$LISTSIZE" == "$(stat -c '%s' $WORKFOLDERNAME2/$FILENAMERESULT3)" ]] && echo "The files are the same ($WORKFOLDERNAME2/$FILENAMERESULT3)" && exit 2

# Собираем все в один файл, чтобы за один раз прогнать все записи и не плодить много парсинга
#echo "Собираем все в один файл, чтобы за один раз прогнать все записи и не плодить много парсинга"
echo "Update File"
mv $WORKFOLDERNAME/$FILENAMERESULT3 $WORKFOLDERNAME2/$FILENAMERESULT3

echo "Update File OK"

exit 0
