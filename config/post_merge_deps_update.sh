#!/bin/bash

# capture info messages and any errors in a log file
#exec >> hooks-out.log 2>&1

cd /root/zaborona_help

#CHANGE="$(git diff master..origin/master)"
# git pull --dry-run | grep -q -v 'Already up-to-date.' && changed=1
CHANGE="$(git rev-list HEAD...origin/master --count)"

git fetch

if [ $CHANGE -eq 0 ]; then
	echo "Up to date"
else
	echo "Not up to date. Start git pull"
	git pull
	echo "Coy all files from /root/zaborona_help/* to /var/www/zaborona_help/"
	cp -Rv * /var/www/zaborona_help/
	echo "Updated!"
	# tg message
	/root/telegram.sh "227897154" "Information!" "Site zaborona.help updated!"
fi

#
#if [ $CHANGE  ]; then
#  echo "$(date): reinstalling deps since changed"
#else
#  echo "$(date): no changes detected"
#fi

# link is needed: ln -fv [script location] .git/hooks/ 
