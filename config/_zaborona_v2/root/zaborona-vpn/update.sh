#!/bin/bash
set -e

HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

FILENAMEDOMAINS="domains.txt"
FILENAMEDOMAINS_CUSTOM="domains_custom.txt"
FILENAMENXDOMAIN="nxdomain.txt"
FILENAMENXDOMAIN_CUSTOM="nxdomain_custom.txt"
WORKFOLDERNAME="temp"

#LISTLINK='https://raw.githubusercontent.com/zapret-info/z-i/master/dump.csv'
#NXDOMAINLINK='https://raw.githubusercontent.com/zapret-info/z-i/master/nxdomain.txt'
LISTLINK='https://uablacklist.net/'$FILENAMEDOMAINS
LISTLINK_CUSTOM='https://raw.githubusercontent.com/zhovner/zaborona_help/master/config/_zaborona_v2/'$FILENAMEDOMAINS_CUSTOM
NXDOMAINLINK='https://uablacklist.net/'$FILENAMENXDOMAIN
NXDOMAINLINK_CUSTOM='https://raw.githubusercontent.com/zhovner/zaborona_help/master/config/_zaborona_v2/'$FILENAMENXDOMAIN_CUSTOM

#curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMEDOMAINS "$LISTLINK" ||
curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMEDOMAINS_CUSTOM "$LISTLINK_CUSTOM" || exit 1

#iconv -f cp1251 -t utf8 $WORKFOLDERNAME/list_orig.csv > temp/list.csv

#curl -f --fail-early --compressed -o $WORKFOLDERNAME/$FILENAMENXDOMAIN "$NXDOMAINLINK" || exit 1
#curl -f --fail-early --compressed -o $WORKFOLDERNAME/$FILENAMENXDOMAIN_CUSTOM "$NXDOMAINLINK_CUSTOM" || exit 1

#LISTSIZE="$(curl -sI --connect-timeout 15 "$LISTLINK" | awk 'BEGIN {IGNORECASE=1;} /content-length/ {sub(/[ \t\r\n]+$/, "", $2); print $2}')"
#[[ "$LISTSIZE" != "$(stat -c '%s' $WORKFOLDERNAME/$FILENAMEDOMAINS)" ]] && echo "List 1 size differs" && exit 2

LISTSIZE="$(curl -sI --connect-timeout 15 "$LISTLINK_CUSTOM" | awk 'BEGIN {IGNORECASE=1;} /content-length/ {sub(/[ \t\r\n]+$/, "", $2); print $2}')"
[[ "$LISTSIZE" != "$(stat -c '%s' $WORKFOLDERNAME/$FILENAMEDOMAINS_CUSTOM)" ]] && echo "List 2 size differs" && exit 2

#LISTSIZE="$(curl -sI --connect-timeout 15 "$NXDOMAINLINK" | awk 'BEGIN {IGNORECASE=1;} /content-length/ {sub(/[ \t\r\n]+$/, "", $2); print $2}')"
#[[ "$LISTSIZE" != "$(stat -c '%s' $WORKFOLDERNAME/$FILENAMENXDOMAIN)" ]] && echo "List 1 size differs" && exit 2

#LISTSIZE="$(curl -sI --connect-timeout 15 "$NXDOMAINLINK" | awk 'BEGIN {IGNORECASE=1;} /content-length/ {sub(/[ \t\r\n]+$/, "", $2); print $2}')"
#[[ "$LISTSIZE" != "$(stat -c '%s' $WORKFOLDERNAME/$FILENAMENXDOMAIN_CUSTOM)" ]] && echo "List 2 size differs" && exit 2

exit 0
