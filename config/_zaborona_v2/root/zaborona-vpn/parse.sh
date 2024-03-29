#!/bin/bash
set -e

HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

FILENAMEDOMAINS_OFFICIAL="domains.txt"
FILENAME_INCLUDE_HOSTS_DIST="include-hosts-dist.txt"
FILENAME_INCLUDE_IPS_DIST="include-ips-dist.txt"
FILENAME_INCLUDE_NXDOMAIN_DIST="include-nxdomain-dist.txt"
FILENAME_INCLUDE_BLOCKPORT_DIST="include-blockport-dist.txt"
FILENAME_INCLUDE_BLOCKSTRING_DIST="include-blockstring-dist.txt"
FILENAME_EXCLUDE_HOSTS_DIST="exclude-hosts-dist.txt"
FILENAME_EXCLUDE_IPS_DIST="exclude-ips-dist.txt"
FILENAME_EXCLUDE_NXDOMAIN_DIST="exclude-nxdomain-dist.txt"
FILENAME_EXCLUDE_BLOCKPORT_DIST="exclude-blockport-dist.txt"
FILENAME_EXCLUDE_BLOCKSTRING_DIST="exclude-blockstring-dist.txt"
WORKFOLDERNAME="temp"
FILENAMERESULT="list.csv"

# Extract domains from list
echo "Extract domains from list"
awk -F ';' '{print $2}' $WORKFOLDERNAME/$FILENAMERESULT | sort -u | awk '/^$/ {next} /\\/ {next} /^[а-яА-Яa-zA-Z0-9\-\_\.\*]*+$/ {gsub(/\*\./, ""); gsub(/\.$/, ""); print}' | idn > result/hostlist_original.txt

# Generate zones from domains
echo "Generate zones from domains"
# FIXME: nxdomain list parsing is disabled due to its instability on z-i
###cat exclude.txt temp/nxdomain.txt > temp/exclude.txt

sort -u config/exclude-hosts-{dist,custom}.txt > temp/exclude-hosts.txt
sort -u config/exclude-ips-{dist,custom}.txt > temp/exclude-ips.txt
sort -u config/include-hosts-{dist,custom}.txt > temp/include-hosts.txt
sort -u config/include-ips-{dist,custom}.txt > temp/include-ips.txt
sort -u config/exclude-blockport-{dist,custom}.txt temp/$FILENAMEBLOCKPORT temp/$FILENAMEBLOCKPORT_CUSTOM > result/exclude-blockport.txt
sort -u config/exclude-blockstring-{dist,custom}.txt temp/$FILENAMEBLOCKSTRING temp/$FILENAMEBLOCKSTRING_CUSTOM > result/exclude-blockstring.txt
sort -u config/include-blockport-{dist,custom}.txt temp/$FILENAMEBLOCKPORT temp/$FILENAMEBLOCKPORT_CUSTOM > result/include-blockport.txt
sort -u config/include-blockstring-{dist,custom}.txt temp/$FILENAMEBLOCKSTRING temp/$FILENAMEBLOCKSTRING_CUSTOM > result/include-blockstring.txt
sort -u config/exclude-bgp-ips-{dist,custom}.txt temp/$FILENAMEBLOCKPORT temp/$FILENAMEBLOCKPORT_CUSTOM > result/exclude-bgp-ips.txt
sort -u config/include-bgp-ips-{dist,custom}.txt temp/$FILENAMEBLOCKSTRING temp/$FILENAMEBLOCKSTRING_CUSTOM > result/include-bgp-ips.txt
sort -u temp/include-hosts.txt result/hostlist_original.txt > temp/hostlist_original_with_include.txt

# 
awk -f scripts/getzones.awk temp/hostlist_original_with_include.txt | grep -v -F -x -f temp/exclude-hosts.txt | sort -u > result/hostlist_zones.txt

# Check for NXDOMAIN = Non-Existing Domain
if [[ "$RESOLVE_NXDOMAIN" == "yes" ]];
then
    scripts/resolve-dns-nxdomain.py result/hostlist_zones.txt >> temp/exclude-hosts.txt
    awk -f scripts/getzones.awk temp/hostlist_original_with_include.txt | grep -v -F -x -f temp/exclude-hosts.txt | sort -u > result/hostlist_zones.txt
fi

# Generate a list of IP addresses
awk -F';' '$1 ~ /\// {print $1}' $WORKFOLDERNAME/$FILENAMERESULT | grep -P '([0-9]{1,3}\.){3}[0-9]{1,3}\/[0-9]{1,2}' -o | sort -Vu > result/iplist_special_range.txt

awk -F ';' '($1 ~ /^([0-9]{1,3}\.){3}[0-9]{1,3}/) {gsub(/ \| /, RS, $1); print $1}' $WORKFOLDERNAME/$FILENAMERESULT | \
    awk '/^([0-9]{1,3}\.){3}[0-9]{1,3}$/' | sort -u > result/iplist_all.txt

awk -F ';' '($1 ~ /^([0-9]{1,3}\.){3}[0-9]{1,3}/) && (($2 == "" && $3 == "") || ($1 == $2)) {gsub(/ \| /, RS); print $1}' $WORKFOLDERNAME/$FILENAMERESULT | \
    awk '/^([0-9]{1,3}\.){3}[0-9]{1,3}$/' | sort -u > result/iplist_blockedbyip.txt

grep -F -v 'Ид2971-18' $WORKFOLDERNAME/$FILENAMERESULT | \
    awk -F ';' '($1 ~ /^([0-9]{1,3}\.){3}[0-9]{1,3}/) && (($2 == "" && $3 == "") || ($1 == $2)) {gsub(/ \| /, RS); print $1}' | \
    awk '/^([0-9]{1,3}\.){3}[0-9]{1,3}$/' | sort -u > result/iplist_blockedbyip_noid2971.txt

awk -F ';' '$1 ~ /\// {print $1}' $WORKFOLDERNAME/$FILENAMERESULT | egrep -o '([0-9]{1,3}\.){3}[0-9]{1,3}\/[0-9]{1,2}' | sort -u > result/blocked-ranges.txt


# Generate OpenVPN route file
echo -n > result/openvpn-blocked-ranges.txt
while read -r line
do
    C_NET="$(echo $line | awk -F '/' '{print $1}')"
    C_NETMASK="$(sipcalc -- "$line" | awk '/Network mask/ {print $4; exit;}')"
    echo $"push \"route ${C_NET} ${C_NETMASK}\"" >> result/openvpn-blocked-ranges.txt
done < result/blocked-ranges.txt


# Generate dnsmasq aliases
echo -n > result/dnsmasq-aliases-alt.conf
while read -r line
do
    echo "server=/$line/127.0.0.4" >> result/dnsmasq-aliases-alt.conf
done < result/hostlist_zones.txt


# Generate knot-resolver aliases
echo 'blocked_hosts = {' > result/knot-aliases-alt.conf
while read -r line
do
    line="$line."
    echo "${line@Q}," >> result/knot-aliases-alt.conf
done < result/hostlist_zones.txt
echo '}' >> result/knot-aliases-alt.conf


# Generate squid zone file
echo -n > result/squid-whitelist-zones.conf
while read -r line
do
    echo ".$line" >> result/squid-whitelist-zones.conf
done < result/hostlist_zones.txt


# Print results
echo "Blocked domains: $(wc -l result/hostlist_zones.txt)" >&2
echo "iplist_all: $(wc -l result/iplist_all.txt)" >&2
echo "iplist_special_range: $(wc -l result/iplist_special_range.txt)" >&2
echo "iplist_blockedbyip: $(wc -l result/iplist_blockedbyip.txt)" >&2
echo "iplist_blockedbyip_noid2971: $(wc -l result/iplist_blockedbyip_noid2971.txt)" >&2

exit 0
