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
FILENAMERESULT_TMP1="list_tmp1.csv"
FILENAMERESULT_TMP2="list_tmp2.csv"
FILENAMERESULT_TMP3="list_tmp3.csv"
FILENAMERESULT_TMP4="list_tmp4.csv"
FILENAMERESULT_TMP5="list_tmp5.csv"

touch $WORKFOLDERNAME/$FILENAMEDOMAINS_OFFICIAL
LISTLINK_OFFICIAL_DONE=$LISTLINK_OFFICIAL/$FILENAMEDOMAINS_OFFICIAL
curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMEDOMAINS "$LISTLINK_OFFICIAL_DONE" &&
#LISTSIZE="$(curl -sI --connect-timeout 15 "$LISTLINK_OFFICIAL_DONE" | awk 'BEGIN {IGNORECASE=1;} /content-length/ {sub(/[ \t\r\n]+$/, "", $2); print $2}')"
#[[ "$LISTSIZE" != "$(stat -c '%s' $WORKFOLDERNAME/$FILENAMEDOMAINS_OFFICIAL)" ]] && echo "List 1 size differs ($FILENAMEDOMAINS_OFFICIAL)" && exit 2
sort -u $WORKFOLDERNAME/$FILENAMEDOMAINS_OFFICIAL >> $WORKFOLDERNAME/$FILENAMERESULT_TMP1

for FILENAMEALLCONFIG_INCLUDE1 in $FILENAMEALLCONFIG_INCLUDE; do
	touch $WORKFOLDERNAME/$FILENAMEALLCONFIG_INCLUDE1
	LISTLINK_ALLCONFIG_DONE=$LISTLINK_ALLCONFIG/$FILENAMEALLCONFIG_INCLUDE1
	curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMEALLCONFIG_INCLUDE1 "$LISTLINK_ALLCONFIG_DONE" &&
#LISTSIZE="$(curl -sI --connect-timeout 15 "$LISTLINK_ALLCONFIG_DONE" | awk 'BEGIN {IGNORECASE=1;} /content-length/ {sub(/[ \t\r\n]+$/, "", $2); print $2}')"
#[[ "$LISTSIZE" != "$(stat -c '%s' $WORKFOLDERNAME/$FILENAMEALLCONFIG_INCLUDE1)" ]] && echo "List 2 size differs ($FILENAMEALLCONFIG_INCLUDE1)" && exit 2
sort -u $WORKFOLDERNAME/$FILENAMEALLCONFIG_INCLUDE1 >> $WORKFOLDERNAME/$FILENAMERESULT_TMP2
done

#for FILENAMEALLCONFIG_INCLUDE_CUSTOM1 in $FILENAMEALLCONFIG_INCLUDE_CUSTOM; do
#	touch $WORKFOLDERNAME/$FILENAMEALLCONFIG_INCLUDE_CUSTOM1
#	LISTLINK_ALLCONFIG_DONE=$LISTLINK_ALLCONFIG/$FILENAMEALLCONFIG_INCLUDE_CUSTOM1
#	curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMEALLCONFIG_INCLUDE_CUSTOM1 "$LISTLINK_ALLCONFIG_DONE" ||
#LISTSIZE="$(curl -sI --connect-timeout 15 "$LISTLINK_ALLCONFIG_DONE" | awk 'BEGIN {IGNORECASE=1;} /content-length/ {sub(/[ \t\r\n]+$/, "", $2); print $2}')"
#[[ "$LISTSIZE" != "$(stat -c '%s' $WORKFOLDERNAME/$FILENAMEALLCONFIG_INCLUDE_CUSTOM1)" ]] && echo "List 2 size differs ($FILENAMEALLCONFIG_INCLUDE_CUSTOM1)" && exit 2
#sort -u $WORKFOLDERNAME/$FILENAMEALLCONFIG_INCLUDE_CUSTOM1 >> $WORKFOLDERNAME/$FILENAMERESULT_TMP3
#done

for FILENAMEALLCONFIG_EXCLUDE1 in $FILENAMEALLCONFIG_EXCLUDE; do
	touch $WORKFOLDERNAME/$FILENAMEALLCONFIG_EXCLUDE1
	LISTLINK_ALLCONFIG_DONE=$LISTLINK_ALLCONFIG/$FILENAMEALLCONFIG_EXCLUDE1
	curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMEALLCONFIG_EXCLUDE1 "$LISTLINK_ALLCONFIG_DONE" &&
#LISTSIZE="$(curl -sI --connect-timeout 15 "$LISTLINK_ALLCONFIG_DONE" | awk 'BEGIN {IGNORECASE=1;} /content-length/ {sub(/[ \t\r\n]+$/, "", $2); print $2}')"
#[[ "$LISTSIZE" != "$(stat -c '%s' $WORKFOLDERNAME/$FILENAMEALLCONFIG_EXCLUDE1)" ]] && echo "List 2 size differs ($FILENAMEALLCONFIG_EXCLUDE1)" && exit 2
sort -u $WORKFOLDERNAME/$FILENAMEALLCONFIG_EXCLUDE1 >> $WORKFOLDERNAME/$FILENAMERESULT_TMP4
done

#for FILENAMEALLCONFIG_EXCLUDE_CUSTOM1 in $FILENAMEALLCONFIG_EXCLUDE_CUSTOM; do
#	touch $WORKFOLDERNAME/$FILENAMEALLCONFIG_EXCLUDE_CUSTOM1
#	LISTLINK_ALLCONFIG_DONE=$LISTLINK_ALLCONFIG/$FILENAMEALLCONFIG_EXCLUDE_CUSTOM1
#	curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMEALLCONFIG_EXCLUDE_CUSTOM1 "$LISTLINK_ALLCONFIG_DONE" &&
#LISTSIZE="$(curl -sI --connect-timeout 15 "$LISTLINK_ALLCONFIG_DONE" | awk 'BEGIN {IGNORECASE=1;} /content-length/ {sub(/[ \t\r\n]+$/, "", $2); print $2}')"
#[[ "$LISTSIZE" != "$(stat -c '%s' $WORKFOLDERNAME/$FILENAMEALLCONFIG_EXCLUDE_CUSTOM1)" ]] && echo "List 2 size differs ($FILENAMEALLCONFIG_EXCLUDE_CUSTOM1)" && exit 2
#sort -u $WORKFOLDERNAME/$FILENAMEALLCONFIG_EXCLUDE_CUSTOM1 > $WORKFOLDERNAME/$FILENAMERESULT_TMP5
#done

# Собираем все в один файл, чтобы за один раз прогнать все записи и не плодить много парсинга
echo "Собираем все в один файл, чтобы за один раз прогнать все записи и не плодить много парсинга"
sort -u $WORKFOLDERNAME/$FILENAMERESULT_TMP1 $WORKFOLDERNAME/$FILENAMERESULT_TMP2 $WORKFOLDERNAME/$FILENAMERESULT_TMP4 > $WORKFOLDERNAME/$FILENAMERESULT

exit 0
