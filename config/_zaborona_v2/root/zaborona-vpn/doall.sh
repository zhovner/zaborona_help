#!/bin/bash

set -e

HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

./iptables-custom.sh
./update.sh
./parse.sh
./process.sh
