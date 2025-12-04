#!/bin/bash
set -e

HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

WORKFOLDERNAME="/tmp"
#WORKFOLDERNAME=$PWD/result
WORKFOLDERNAME2="/etc/dnsmasq.d"
WORKFOLDERNAME3=$PWD
FILENAMERESULT="zaborona-dns-resovler-tmp1"
FILENAMERESULT2="zaborona-dns-resovler-tmp2"
FILENAMERESULT3="zaborona-dns-resovler"
FILENAMERESULT4="domainsdb.txt"
FILENAMERESULT5="domainsdbexclude.txt"
FILENAMERESULT6="zaborona-dns-resovler-excludedns-result"
FILENAMERESULT7="domainsdb-automatic_filling.txt"

# Generate dnsmasq aliases
echo -n > $WORKFOLDERNAME/$FILENAMERESULT3
while read -r line
do
	# convert an IDN to Punycode
	PunycodeConvert="$(echo $line | idn)"
    echo "server=/$PunycodeConvert/127.0.0.4#5959" >> $WORKFOLDERNAME/$FILENAMERESULT3
#done < $WORKFOLDERNAME/$FILENAMERESULT4
done < $WORKFOLDERNAME3/$FILENAMERESULT4

while read -r line2
do
	# convert an IDN to Punycode
	PunycodeConvert="$(echo $line2 | idn)"
    echo "server=/$PunycodeConvert/127.0.0.4#5959" >> $WORKFOLDERNAME/$FILENAMERESULT3
#done < $WORKFOLDERNAME/$FILENAMERESULT4
done < $WORKFOLDERNAME3/$FILENAMERESULT7

echo "Update File"
#sort -u $WORKFOLDERNAME/$FILENAMERESULT_TMP1 $WORKFOLDERNAME/$FILENAMERESULT_TMP2 $WORKFOLDERNAME/$FILENAMERESULT_TMP4 > $WORKFOLDERNAME/$FILENAMERESULT
sort -u $WORKFOLDERNAME/$FILENAMERESULT3 > $WORKFOLDERNAME/$FILENAMERESULT

cp $WORKFOLDERNAME3/$FILENAMERESULT5 $WORKFOLDERNAME/$FILENAMERESULT5
# Удаляем строки с коментариями, удаляем комментарии, расположенные внутри строк и удаляем пустые строки из файла
sed -i -e '/^#/d' -e 's/#.*//' -e '/^$/d' $WORKFOLDERNAME/$FILENAMERESULT5
# Удаляем строки (исключенные домены), которые нам не нужны (читаем из файла $WORKFOLDERNAME/$FILENAMERESULT5)
awk 'FNR==NR {exclude[$0]; next} !($0 in exclude)' $WORKFOLDERNAME/$FILENAMERESULT5 $WORKFOLDERNAME/$FILENAMERESULT > $WORKFOLDERNAME/$FILENAMERESULT6

#mv $WORKFOLDERNAME/$FILENAMERESULT3 $WORKFOLDERNAME2/$FILENAMERESULT3
mv $WORKFOLDERNAME/$FILENAMERESULT6 $WORKFOLDERNAME2/$FILENAMERESULT3

#echo "$WORKFOLDERNAME/$FILENAMERESULT"

echo "Update File OK"

sleep 2

echo "DNSMASQ Restart"
systemctl reload dnsmasq

exit 0
