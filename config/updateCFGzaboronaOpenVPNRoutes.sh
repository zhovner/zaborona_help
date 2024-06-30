#!/bin/bash
set -e

HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

# Generate OpenVPN route file
echo -n > ./openvpn-blocked-ranges.txt

cat ./updateCFGzaboronaOpenVPNRoutesBIG_header0.txt > ./openvpn-blocked-ranges.txt

while read -r line
do
    C_NET="$(echo $line | awk -F '/' '{print $1}')"
    C_NETMASK="$(sipcalc -- "$line" | awk '/Network mask/ {print $4; exit;}')"
    echo $"push \"route ${C_NET} ${C_NETMASK}\"" >> ./openvpn-blocked-ranges.txt
done < ./ipsdb0.txt

mv ./openvpn-blocked-ranges.txt /etc/openvpn/ccd_zaborona_big_routes/DEFAULT

echo "Update File OK"

exit 0