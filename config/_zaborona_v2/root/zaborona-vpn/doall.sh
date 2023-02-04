#!/bin/bash

set -e

HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

chmod +x *.sh
chmod +x ./config/*.sh
chmod +x ./scripts/*.py

# Update manually. This option is under development.
#./upgrade.sh
./iptables-custom.sh
./update.sh
./parse.sh
./process.sh
