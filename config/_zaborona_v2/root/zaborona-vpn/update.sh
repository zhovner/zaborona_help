#!/bin/bash
set -e

HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

### OFFICIAL LIST SITE ###
FILENAMEDOMAINS_OFFICIAL="domains.txt"
### OFFICIAL LIST SITE ###

### INCLUDE ###
FILENAMEHOSTS_INCLUDE="include-hosts-dist.txt"
#FILENAMEHOSTS_INCLUDE_CUSTOM="include-hosts-custom.txt"
FILENAMEIPS_INCLUDE="include-ips-dist.txt"
#FILENAMEIPS_INCLUDE_CUSTOM="include-ips-custom.txt"
FILENAMENXDOMAIN_INCLUDE="include-nxdomain-dist.txt"
#FILENAMENXDOMAIN_INCLUDE_CUSTOM="include-nxdomain-custom.txt"
FILENAMEBLOCKPORT_INCLUDE="include-blockport-dist.txt"
#FILENAMEBLOCKPORT_INCLUDE_CUSTOM="include-blockport-custom.txt"
FILENAMEBLOCKSTRING_INCLUDE="include-blockstring-dist.txt"
#FILENAMEBLOCKSTRING_INCLUDE_CUSTOM="include-blockstring-custom.txt"
### INCLUDE ###

### EXCLUDE ###
FILENAMEHOSTS_EXCLUDE="exclude-hosts-dist.txt"
#FILENAMEHOSTS_EXCLUDE_CUSTOM="exclude-hosts-custom.txt"
FILENAMEIPS_EXCLUDE="exclude-ips-dist.txt"
#FILENAMEIPS_EXCLUDE_CUSTOM="exclude-ips-custom.txt"
FILENAMENXDOMAIN_EXCLUDE="exclude-nxdomain-dist.txt"
#FILENAMENXDOMAIN_EXCLUDE_CUSTOM="exclude-nxdomain-custom.txt"
FILENAMEBLOCKPORT_EXCLUDE="exclude-blockport-dist.txt"
#FILENAMEBLOCKPORT_EXCLUDE_CUSTOM="exclude-blockport-custom.txt"
FILENAMEBLOCKSTRING_EXCLUDE="exclude-blockstring-dist.txt"
#FILENAMEBLOCKSTRING_EXCLUDE_CUSTOM="exclude-blockstring-custom.txt"
### EXCLUDE ###

WORKFOLDERNAME="temp"
WORKFOLDERNAME2="result"
FILENAMERESULT="list.csv"

touch $WORKFOLDERNAME/$FILENAMEDOMAINS_OFFICIAL
touch $WORKFOLDERNAME/$FILENAMEHOSTS_INCLUDE
#touch $WORKFOLDERNAME/$FILENAMEHOSTS_INCLUDE_CUSTOM
touch $WORKFOLDERNAME/$FILENAMEIPS_INCLUDE
#touch $WORKFOLDERNAME/$FILENAMEIPS_INCLUDE_CUSTOM
touch $WORKFOLDERNAME/$FILENAMENXDOMAIN_INCLUDE
#touch $WORKFOLDERNAME/$FILENAMENXDOMAIN_INCLUDE_CUSTOM
touch $WORKFOLDERNAME/$FILENAMEBLOCKPORT_INCLUDE
#touch $WORKFOLDERNAME/$FILENAMEBLOCKPORT_INCLUDE_CUSTOM
touch $WORKFOLDERNAME/$FILENAMEBLOCKSTRING_INCLUDE
#touch $WORKFOLDERNAME/$FILENAMEBLOCKSTRING_INCLUDE_CUSTOM

#touch $WORKFOLDERNAME/$FILENAMEDOMAINS_OFFICIAL
touch $WORKFOLDERNAME/$FILENAMEHOSTS_EXCLUDE
#touch $WORKFOLDERNAME/$FILENAMEHOSTS_EXCLUDE_CUSTOM
touch $WORKFOLDERNAME/$FILENAMEIPS_EXCLUDE
#touch $WORKFOLDERNAME/$FILENAMEIPS_EXCLUDE_CUSTOM
touch $WORKFOLDERNAME/$FILENAMENXDOMAIN_EXCLUDE
#touch $WORKFOLDERNAME/$FILENAMENXDOMAIN_EXCLUDE_CUSTOM
touch $WORKFOLDERNAME/$FILENAMEBLOCKPORT_EXCLUDE
#touch $WORKFOLDERNAME/$FILENAMEBLOCKPORT_EXCLUDE_CUSTOM
touch $WORKFOLDERNAME/$FILENAMEBLOCKSTRING_EXCLUDE
#touch $WORKFOLDERNAME/$FILENAMEBLOCKSTRING_EXCLUDE_CUSTOM

#
#LISTLINK='https://raw.githubusercontent.com/zapret-info/z-i/master/dump.csv'
#NXDOMAINLINK='https://raw.githubusercontent.com/zapret-info/z-i/master/nxdomain.txt'

LISTLINK='https://uablacklist.net/'$FILENAMEDOMAINS_OFFICIAL
LISTLINK_CUSTOM='https://raw.githubusercontent.com/zhovner/zaborona_help/master/config/_zaborona_v2/root/zaborona-vpn/config/'$FILENAMEDOMAINS_CUSTOM

# NXDOMAIN = Non-Existing Domain
NXDOMAINLINK='https://raw.githubusercontent.com/zhovner/zaborona_help/master/config/_zaborona_v2/root/zaborona-vpn/config/'$FILENAMENXDOMAIN
NXDOMAINLINK_CUSTOM='https://raw.githubusercontent.com/zhovner/zaborona_help/master/config/_zaborona_v2/root/zaborona-vpn/config/'$FILENAMENXDOMAIN_CUSTOM

# ferm file - Block Port
FILENAMEBLOCKPORTLINK='https://raw.githubusercontent.com/zhovner/zaborona_help/master/config/_zaborona_v2/root/zaborona-vpn/config/'$FILENAMEBLOCKPORT
#FILENAMEBLOCKPORTLINK_CUSTOM='https://raw.githubusercontent.com/zhovner/zaborona_help/master/config/_zaborona_v2/root/zaborona-vpn/config/'$FILENAMEBLOCKPORT_CUSTOM

# ferm file - Block String
FILENAMEBLOCKSTRINGLINK='https://raw.githubusercontent.com/zhovner/zaborona_help/master/config/_zaborona_v2/root/zaborona-vpn/config/'$FILENAMEBLOCKSTRING
#FILENAMEBLOCKSTRINGLINK_CUSTOM='https://raw.githubusercontent.com/zhovner/zaborona_help/master/config/_zaborona_v2/root/zaborona-vpn/config/'$FILENAMEBLOCKSTRING_CUSTOM

curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMEDOMAINS "$LISTLINK" ||
curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMEDOMAINS_CUSTOM "$LISTLINK_CUSTOM" ||
#curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMEBLOCKPORT_CUSTOM "$FILENAMEBLOCKPORTLINK_CUSTOM" ||
#curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMEBLOCKSTRING_CUSTOM "$FILENAMEBLOCKSTRINGLINK_CUSTOM" ||
curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMEBLOCKPORT "$FILENAMEBLOCKPORTLINK" ||
curl -f --fail-early --compressed --connect-timeout 15 -o $WORKFOLDERNAME/$FILENAMEBLOCKSTRING "$FILENAMEBLOCKSTRINGLINK" || exit 1

#iconv -f cp1251 -t utf8 $WORKFOLDERNAME/list_orig.csv > temp/list.csv

#curl -f --fail-early --compressed -o $WORKFOLDERNAME/$FILENAMENXDOMAIN "$NXDOMAINLINK" || exit 1
#curl -f --fail-early --compressed -o $WORKFOLDERNAME/$FILENAMENXDOMAIN_CUSTOM "$NXDOMAINLINK_CUSTOM" || exit 1

# Сверяем файл, не побился ли он при загрузке. Актуально для больших файлов
#LISTSIZE="$(curl -sI --connect-timeout 15 "$LISTLINK" | awk 'BEGIN {IGNORECASE=1;} /content-length/ {sub(/[ \t\r\n]+$/, "", $2); print $2}')"
#[[ "$LISTSIZE" != "$(stat -c '%s' $WORKFOLDERNAME/$FILENAMEDOMAINS)" ]] && echo "List 1 size differs" && exit 2

LISTSIZE="$(curl -sI --connect-timeout 15 "$LISTLINK_CUSTOM" | awk 'BEGIN {IGNORECASE=1;} /content-length/ {sub(/[ \t\r\n]+$/, "", $2); print $2}')"
[[ "$LISTSIZE" != "$(stat -c '%s' $WORKFOLDERNAME/$FILENAMEDOMAINS_CUSTOM)" ]] && echo "List 2 size differs" && exit 2

#LISTSIZE="$(curl -sI --connect-timeout 15 "$NXDOMAINLINK" | awk 'BEGIN {IGNORECASE=1;} /content-length/ {sub(/[ \t\r\n]+$/, "", $2); print $2}')"
#[[ "$LISTSIZE" != "$(stat -c '%s' $WORKFOLDERNAME/$FILENAMENXDOMAIN)" ]] && echo "List 1 size differs" && exit 2

#LISTSIZE="$(curl -sI --connect-timeout 15 "$NXDOMAINLINK" | awk 'BEGIN {IGNORECASE=1;} /content-length/ {sub(/[ \t\r\n]+$/, "", $2); print $2}')"
#[[ "$LISTSIZE" != "$(stat -c '%s' $WORKFOLDERNAME/$FILENAMENXDOMAIN_CUSTOM)" ]] && echo "List 2 size differs" && exit 2

LISTSIZE="$(curl -sI --connect-timeout 15 "$FILENAMEBLOCKPORTLINK" | awk 'BEGIN {IGNORECASE=1;} /content-length/ {sub(/[ \t\r\n]+$/, "", $2); print $2}')"
[[ "$LISTSIZE" != "$(stat -c '%s' $WORKFOLDERNAME/$FILENAMEBLOCKPORT)" ]] && echo "List 2 size differs" && exit 2

LISTSIZE="$(curl -sI --connect-timeout 15 "$FILENAMEBLOCKSTRINGLINK" | awk 'BEGIN {IGNORECASE=1;} /content-length/ {sub(/[ \t\r\n]+$/, "", $2); print $2}')"
[[ "$LISTSIZE" != "$(stat -c '%s' $WORKFOLDERNAME/$FILENAMEBLOCKSTRING)" ]] && echo "List 2 size differs" && exit 2

#LISTSIZE="$(curl -sI --connect-timeout 15 "$FILENAMEBLOCKPORTLINK_CUSTOM" | awk 'BEGIN {IGNORECASE=1;} /content-length/ {sub(/[ \t\r\n]+$/, "", $2); print $2}')"
#[[ "$LISTSIZE" != "$(stat -c '%s' $WORKFOLDERNAME/$FILENAMEBLOCKPORT_CUSTOM)" ]] && echo "List 2 size differs" && exit 2

#LISTSIZE="$(curl -sI --connect-timeout 15 "$FILENAMEBLOCKSTRINGLINK_CUSTOM" | awk 'BEGIN {IGNORECASE=1;} /content-length/ {sub(/[ \t\r\n]+$/, "", $2); print $2}')"
#[[ "$LISTSIZE" != "$(stat -c '%s' $WORKFOLDERNAME/$FILENAMEBLOCKSTRING_CUSTOM)" ]] && echo "List 2 size differs" && exit 2

# Собираем все в один файл, чтобы за один раз прогнать все записи и не плодить много парсинга
sort -u $WORKFOLDERNAME/$FILENAMEDOMAINS_INCLUDE $WORKFOLDERNAME/$FILENAMEDOMAINS_INCLUDE_CUSTOM > $WORKFOLDERNAME/$FILENAMERESULT

exit 0
