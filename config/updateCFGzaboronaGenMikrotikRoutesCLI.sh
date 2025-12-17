#!/bin/bash
# Show Errors And Stop Script
#set -e

HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

# Generate New route file for Mikrotik
echo -n > ./mikrotik-add-ranges_gen.txt
echo -n > ./mikrotik-del-ranges_gen.txt
echo -n > ./mikrotik-add-ranges.txt
echo -n > ./mikrotik-del-ranges.txt

#cat ./updateCFGzaboronaOpenVPNRoutesBIG_header0.txt > ./openvpn-blocked-ranges.txt

while read -r line
do
	# Если в файле есть мусор (пробелы, комментарии)
	#line="$(echo "$line" | xargs)"
    #[[ -z "$line" || "$line" =~ ^# ]] && continue
    echo "/ip route add dst-address=$line gateway=ovpn-out0-tmpl" >> ./mikrotik-add-ranges_gen.txt
    echo "/ip route remove [find dst-address=$line gateway=ovpn-out0-tmpl]" >> ./mikrotik-del-ranges_gen.txt
	# Массовое удаление (осторожно)
    #echo "/ip route remove [find dst-address=$line]" >> ./mikrotik-del-ranges_gen.txt
	# Массовое удаление (осторожно)
	#echo "/ip route remove [find gateway=ovpn-out0-tmpl]" >> ./mikrotik-del-ranges_gen.txt
done < ./ipsdb0.txt

#sort -u ./openvpn-blocked-ranges.txt ./ccd_zaborona_big_routes_DEFAULT.txt > ./openvpn-blocked-ranges_sorted.txt
sort -u ./mikrotik-add-ranges_gen.txt > ./mikrotik-add-ranges.txt
sort -u ./mikrotik-del-ranges_gen.txt > ./mikrotik-del-ranges.txt

#cat ./updateCFGzaboronaOpenVPNRoutesBIG_header0.txt >> ./openvpn-blocked-ranges_sorted.txt

#mv ./openvpn-blocked-ranges_sorted.txt /etc/openvpn/ccd_zaborona_big_routes/DEFAULT

echo "Update File OK"

exit 0
