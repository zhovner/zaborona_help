#!/bin/bash

set -e

HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

chmod +x *.sh
chmod +x ./config/*.sh
chmod +x ./scripts/*.py

# Update the Zaborona VPN software manually. This option is under development.
#./upgrade.sh

# Проверяем, существует ли файл конфига ferm
if [ -f /etc/ferm/ferm.conf ]
then
	$iptablesCTRL="ferm"
else
	./iptables-custom.sh
fi

./update.sh
./parse.sh
./process.sh
