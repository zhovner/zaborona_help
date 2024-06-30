#!/bin/bash
set -e

HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

LISTLINK_ALLCONFIG="https://ipv4.fetus.jp/ru.txt"

WORKFOLDERNAME="/tmp"
#WORKFOLDERNAME=$PWD/result
#WORKFOLDERNAME2="/root"
WORKFOLDERNAME2=$PWD
FILENAMERESULT="ipsdb0.txt"
FILENAMERESULT1="ipsdbtmp.txt"
FILENAMERESULT2="SubnetRUzoneDBoriginalFormat.txt"
FILENAMERESULT3="SubnetRUzoneDB.txt"
FILENAMERESULT4="SubnetRUzoneUpdateOriginalFormat.txt"
FILENAMERESULT5="updateCFGzaboronaIPTablesWhiteList.txt"
FILENAMERESULT6="ipsdbtmp999.txt"

# Если файла нет, то создаем. Если файл есть, то оставляем, как есть
if [ ! -f $WORKFOLDERNAME2/$FILENAMERESULT2 ]; then
touch $WORKFOLDERNAME2/$FILENAMERESULT2
fi

if [ ! -f $WORKFOLDERNAME2/$FILENAMERESULT1 ]; then
touch $WORKFOLDERNAME2/$FILENAMERESULT1
fi

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
[[ "$LISTSIZE" == "$(stat -c '%s' $WORKFOLDERNAME2/$FILENAMERESULT2)" ]] && echo "The files are the same ($WORKFOLDERNAME2/$FILENAMERESULT4)" && exit 2

#sort -u $WORKFOLDERNAME/$FILENAMEALLCONFIG_INCLUDE1 >> $WORKFOLDERNAME/$FILENAMERESULT2
#done

# Собираем все в один файл, чтобы за один раз прогнать все записи и не плодить много парсинга
#echo "Собираем все в один файл, чтобы за один раз прогнать все записи и не плодить много парсинга"
echo "Update File"
#sort -u $WORKFOLDERNAME/$FILENAMERESULT_TMP1 $WORKFOLDERNAME/$FILENAMERESULT_TMP2 $WORKFOLDERNAME/$FILENAMERESULT_TMP4 > $WORKFOLDERNAME/$FILENAMERESULT

# Заменяем временную базу айпишников, если файл со списком айпишников изменился, который мы загружаем из стороннего ресурса
cp $WORKFOLDERNAME/$FILENAMERESULT4 $WORKFOLDERNAME2/$FILENAMERESULT2

# Заменяем нашу базу айпишников, если файл со списком айпишников изменился, который мы загружаем из стороннего ресурса
mv $WORKFOLDERNAME/$FILENAMERESULT4 $WORKFOLDERNAME2/$FILENAMERESULT3

# Удаляем пустые строки и коментарии из файла
sed -i -e '/^#/d' -e '/^$/d' $WORKFOLDERNAME2/$FILENAMERESULT3

while read -r line
do
#	# Delete Old IPs
#	iptables -w -D ZABORONA_V4 -d "$line" -j ACCEPT

	if [[ -z $(iptables -S | grep $line) ]]; then
		echo "$line - Address not found in iptables. Add it."
		# Add New IPs
		iptables -w -A ZABORONA_V4 -d "$line" -j ACCEPT
	fi

#
#	# Add New IPs
#    iptables -w -A ZABORONA_V4 -d "$line" -j ACCEPT
#
done < $WORKFOLDERNAME2/$FILENAMERESULT3

# Выполняем сортировку и проверку на дубликаты айпишников
#sort -u $WORKFOLDERNAME2/$FILENAMERESULT3 $WORKFOLDERNAME2/$FILENAMERESULT5 > $WORKFOLDERNAME2/$FILENAMERESULT1
sort -u $WORKFOLDERNAME2/$FILENAMERESULT3 > $WORKFOLDERNAME2/$FILENAMERESULT1

#while read -r lineBits
#do
#    C_NET="$(echo $lineBits | awk -F '/' '{print $1}')"
#    C_NETMASK_BITS="$(sipcalc -- "$lineBits" | awk '/(bits)/ {print $5; exit;}')"
#    echo $"push \"route ${C_NET} ${C_NETMASK}\"" >> $WORKFOLDERNAME2/$FILENAMERESULT6
#done < $WORKFOLDERNAME2/$FILENAMERESULT1

# Заменяем оригинальный файл ipsdb.txt отсортированным файлом, для заполнения iptables при перезагрузке сервера
mv $WORKFOLDERNAME2/$FILENAMERESULT1 $WORKFOLDERNAME2/$FILENAMERESULT

./updateCFGzaboronaOpenVPNRoutes.sh

echo "Update File OK"

exit 0
