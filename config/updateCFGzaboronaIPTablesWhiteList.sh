#!/bin/bash
# Show Errors And Stop Script
#set -e

HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

# Сбрасываем настройки брандмауэра
iptables -t filter -F ZABORONA_V4
#iptables -t filter -F ZABORONA-IPROUTE_V4
#iptables -t filter -X

while read -r line
do
    iptables -w -A ZABORONA_V4 -d "$line" -j ACCEPT
	echo "Add: $line"

#done < /root/updateCFGzaboronaIPTablesWhiteList.txt
done < /root/ipsdb0.txt

echo "Update File OK"

exit 0
