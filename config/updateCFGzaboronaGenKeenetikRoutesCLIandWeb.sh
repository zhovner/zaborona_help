#!/bin/bash
# Show Errors And Stop Script
#set -e

HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

# Generate New route file for Mikrotik
echo -n > ./keenetik-add-ranges-cli_gen.txt
echo -n > ./keenetik-del-ranges-cli_gen.txt
echo -n > ./keenetik-add-ranges-web_gen.txt
#echo -n > ./keenetik-del-ranges-web_gen.txt

#cat ./updateCFGzaboronaOpenVPNRoutesBIG_header0.txt > ./openvpn-blocked-ranges.txt

while read -r line
do
	# Если в файле есть мусор (пробелы, комментарии)
	#line="$(echo "$line" | xargs)"
    #[[ -z "$line" || "$line" =~ ^# ]] && continue
    echo "ip route $line OpenVPN0 auto" >> ./keenetik-add-ranges-cli_gen.txt
    echo "no ip route interface OpenVPN0" >> ./keenetik-del-ranges-cli_gen.txt
	
    C_NET="$(echo $line | awk -F '/' '{print $1}')"
    C_NETMASK="$(sipcalc -- "$line" | awk '/Network mask/ {print $4; exit;}')"
    echo $"route ADD route ${C_NET} MASK ${C_NETMASK} OpenVPN0 auto" >> ./keenetik-add-ranges-web-cli_gen.txt
    #echo "no ip route interface OpenVPN0" >> ./keenetik-del-ranges-web_gen.txt
	# Массовое удаление (осторожно)
    #echo "/ip route remove [find dst-address=$line]" >> ./mikrotik-del-ranges_gen.txt
	# Массовое удаление (осторожно)
	#echo "/ip route remove [find gateway=ovpn-out0-tmpl]" >> ./mikrotik-del-ranges_gen.txt
done < ./ipsdb0.txt

#sort -u ./openvpn-blocked-ranges.txt ./ccd_zaborona_big_routes_DEFAULT.txt > ./openvpn-blocked-ranges_sorted.txt
sort -u ./keenetik-add-ranges-cli_gen.txt ./keenetik-add-ranges-cli.txt
sort -u ./keenetik-del-ranges-cli_gen.txt ./keenetik-del-ranges-cli.txt
sort -u ./keenetik-add-ranges-web_gen.txt ./keenetik-add-ranges-web.txt
#sort -u ./keenetik-del-ranges-web_gen.txt ./keenetik-del-ranges-web.txt

#cat ./updateCFGzaboronaOpenVPNRoutesBIG_header0.txt >> ./openvpn-blocked-ranges_sorted.txt

#mv ./openvpn-blocked-ranges_sorted.txt /etc/openvpn/ccd_zaborona_big_routes/DEFAULT

echo "Update File OK"

exit 0
