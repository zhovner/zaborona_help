#!/bin/bash
set -e

rm danted-update-ips-complete.txt

while read -r line
do
echo "pass {" >> danted-update-ips-complete.txt
echo "	from: 0.0.0.0/0 to: $line" >> danted-update-ips-complete.txt
echo "	command: bind connect udpassociate" >> danted-update-ips-complete.txt
echo "	log: error" >> danted-update-ips-complete.txt
echo "}" >> danted-update-ips-complete.txt
echo "" >> danted-update-ips-complete.txt
done < danted-update-ips.txt

exit 0
