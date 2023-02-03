#!/bin/bash
set -e

HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

### OFFICIAL LIST SITE ###
LISTLINK_OFFICIAL="https://uablacklist.net"
FILENAMEDOMAINS_OFFICIAL="domains.txt"
### OFFICIAL LIST SITE ###

LISTLINK_ALLCONFIG="https://raw.githubusercontent.com/zhovner/zaborona_help/master/config/_zaborona_v2/root/zaborona-vpn/config"

### INCLUDE ###
FILENAMEALLCONFIG_INCLUDE="include-hosts-dist.txt include-ips-dist.txt include-nxdomain-dist.txt include-blockport-dist.txt include-blockstring-dist.txt"
FILENAMEALLCONFIG_INCLUDE_CUSTOM="include-hosts-custom.txt include-ips-custom.txt include-nxdomain-custom.txt include-blockport-custom.txt include-blockstring-custom.txt"
### INCLUDE ###

### EXCLUDE ###
FILENAMEALLCONFIG_EXCLUDE="exclude-hosts-dist.txt exclude-ips-dist.txt exclude-nxdomain-dist.txt exclude-blockport-dist.txt exclude-blockstring-dist.txt"
FILENAMEALLCONFIG_EXCLUDE_CUSTOM="exclude-hosts-custom.txt exclude-ips-custom.txt exclude-nxdomain-custom.txt exclude-blockport-custom.txt exclude-blockstring-custom.txt"
### EXCLUDE ###

WORKFOLDERNAME="temp"
WORKFOLDERNAME2="result"
FILENAMERESULT="list.csv"

touch $WORKFOLDERNAME/$FILENAMEDOMAINS_OFFICIAL
LISTLINK_OFFICIAL_DONE=$LISTLINK_OFFICIAL$FILENAMEDOMAINS_OFFICIAL
curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMEDOMAINS "$LISTLINK_OFFICIAL_DONE" ||
#LISTSIZE="$(curl -sI --connect-timeout 15 "$LISTLINK_OFFICIAL_DONE" | awk 'BEGIN {IGNORECASE=1;} /content-length/ {sub(/[ \t\r\n]+$/, "", $2); print $2}')"
#[[ "$LISTSIZE" != "$(stat -c '%s' $WORKFOLDERNAME/$FILENAMEDOMAINS_OFFICIAL)" ]] && echo "List 1 size differs" && exit 2

for FILENAMEALLCONFIG_INCLUDE1 in $FILENAMEALLCONFIG_INCLUDE; do
	touch $WORKFOLDERNAME/$FILENAMEALLCONFIG_INCLUDE1
	LISTLINK_ALLCONFIG_DONE=$LISTLINK_ALLCONFIG/$FILENAMEALLCONFIG_INCLUDE1
	curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMEALLCONFIG_INCLUDE1 "$LISTLINK_ALLCONFIG_DONE" ||
LISTSIZE="$(curl -sI --connect-timeout 15 "$LISTLINK_CUSTOM" | awk 'BEGIN {IGNORECASE=1;} /content-length/ {sub(/[ \t\r\n]+$/, "", $2); print $2}')"
[[ "$LISTSIZE" != "$(stat -c '%s' $WORKFOLDERNAME/$FILENAMEALLCONFIG_INCLUDE1)" ]] && echo "List 2 size differs" && exit 2
done

#for FILENAMEALLCONFIG_INCLUDE_CUSTOM1 in $FILENAMEALLCONFIG_INCLUDE_CUSTOM; do
#	touch $WORKFOLDERNAME/$FILENAMEALLCONFIG_INCLUDE_CUSTOM1
#	LISTLINK_ALLCONFIG_DONE=$LISTLINK_ALLCONFIG/$FILENAMEALLCONFIG_INCLUDE_CUSTOM1
#	curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMEALLCONFIG_INCLUDE_CUSTOM1 "$LISTLINK_ALLCONFIG_DONE" ||
LISTSIZE="$(curl -sI --connect-timeout 15 "$LISTLINK_CUSTOM" | awk 'BEGIN {IGNORECASE=1;} /content-length/ {sub(/[ \t\r\n]+$/, "", $2); print $2}')"
[[ "$LISTSIZE" != "$(stat -c '%s' $WORKFOLDERNAME/$FILENAMEALLCONFIG_INCLUDE_CUSTOM1)" ]] && echo "List 2 size differs" && exit 2
#done

for FILENAMEALLCONFIG_EXCLUDE1 in $FILENAMEALLCONFIG_EXCLUDE; do
	touch $WORKFOLDERNAME/$FILENAMEALLCONFIG_EXCLUDE1
	LISTLINK_ALLCONFIG_DONE=$LISTLINK_ALLCONFIG/$FILENAMEALLCONFIG_EXCLUDE1
	curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMEALLCONFIG_EXCLUDE1 "$LISTLINK_ALLCONFIG_DONE" ||
LISTSIZE="$(curl -sI --connect-timeout 15 "$LISTLINK_CUSTOM" | awk 'BEGIN {IGNORECASE=1;} /content-length/ {sub(/[ \t\r\n]+$/, "", $2); print $2}')"
[[ "$LISTSIZE" != "$(stat -c '%s' $WORKFOLDERNAME/$FILENAMEALLCONFIG_EXCLUDE1)" ]] && echo "List 2 size differs" && exit 2
done

#for FILENAMEALLCONFIG_EXCLUDE_CUSTOM1 in $FILENAMEALLCONFIG_EXCLUDE_CUSTOM; do
#	touch $WORKFOLDERNAME/$FILENAMEALLCONFIG_EXCLUDE_CUSTOM1
#	LISTLINK_ALLCONFIG_DONE=$LISTLINK_ALLCONFIG/$FILENAMEALLCONFIG_EXCLUDE_CUSTOM1
#	curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMEALLCONFIG_EXCLUDE_CUSTOM1 "$LISTLINK_ALLCONFIG_DONE" ||
LISTSIZE="$(curl -sI --connect-timeout 15 "$LISTLINK_CUSTOM" | awk 'BEGIN {IGNORECASE=1;} /content-length/ {sub(/[ \t\r\n]+$/, "", $2); print $2}')"
[[ "$LISTSIZE" != "$(stat -c '%s' $WORKFOLDERNAME/$FILENAMEALLCONFIG_EXCLUDE_CUSTOM1)" ]] && echo "List 2 size differs" && exit 2
#done

# Собираем все в один файл, чтобы за один раз прогнать все записи и не плодить много парсинга
sort -u $WORKFOLDERNAME/$FILENAMEDOMAINS_INCLUDE $WORKFOLDERNAME/$FILENAMEDOMAINS_INCLUDE_CUSTOM > $WORKFOLDERNAME/$FILENAMERESULT

exit 0
