#!/bin/bash
set -e

HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

# Интерфейс для мониторинга
IFACE="ens3"

# Файл с динамическими пирами
PEERS_FILE="/etc/bird/dynamic_peers.txt"

# Временный файл для tcpdump
TMP_FILE="/tmp/bgp_syn.tmp"

# Ловим SYN пакеты на TCP 179 (BGP)
timeout 10 tcpdump -n -i $IFACE tcp port 179 and 'tcp[tcpflags] & tcp-syn != 0' -c 50 > $TMP_FILE 2>/dev/null

# Получаем IP источника
grep "IP" $TMP_FILE | awk '{print $3}' | cut -d. -f1-4 | sed 's/\.$//' | while read SRC_IP; do
    # Проверяем, есть ли уже в списке
    if ! grep -q "^$SRC_IP" $PEERS_FILE; then
        # Если нет, добавляем
        echo "$SRC_IP 65530" >> $PEERS_FILE
        echo "Добавлен новый клиент: $SRC_IP"
    fi
done

# Удаляем временный файл
rm -f $TMP_FILE


echo "Update File OK"

exit 0