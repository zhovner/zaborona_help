#!/bin/bash
# Show Errors And Stop Script
#set -e

HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

# Generate New route file for Mikrotik
echo -n > ./bird-add-ranges_gen.txt
echo -n > ./bird-add-ranges.txt

#cat ./updateCFGzaboronaOpenVPNRoutesBIG_header0.txt > ./openvpn-blocked-ranges.txt

while read -r line
do
	# Если в файле есть мусор (пробелы, комментарии)
	#line="$(echo "$line" | xargs)"
    #[[ -z "$line" || "$line" =~ ^# ]] && continue
    echo "route $line blackhole;" >> ./bird-add-ranges_gen.txt
    #echo "/ip route remove [find dst-address=$line gateway=ovpn-out0-tmpl]" >> ./mikrotik-del-ranges_gen.txt
	# Массовое удаление (осторожно)
    #echo "/ip route remove [find dst-address=$line]" >> ./mikrotik-del-ranges_gen.txt
	# Массовое удаление (осторожно)
	#echo "/ip route remove [find gateway=ovpn-out0-tmpl]" >> ./mikrotik-del-ranges_gen.txt
done < ./ipsdb0.txt

#sort -u ./openvpn-blocked-ranges.txt ./ccd_zaborona_big_routes_DEFAULT.txt > ./openvpn-blocked-ranges_sorted.txt
#sort -u ./bird-add-ranges_gen.txt > ./bird-add-ranges.txt

cat ./bird-add-ranges_gen.txt >> ./bird-add-ranges.txt

#mv ./bird-add-ranges.txt /etc/bird/routes.conf
cp ./bird-add-ranges.txt /etc/bird/routes.conf

# Перезагружаем конфиг BIRD
birdc configure

echo "BIRD конфиг обновлен и перезагружен."

echo "Update File OK"

exit 0
