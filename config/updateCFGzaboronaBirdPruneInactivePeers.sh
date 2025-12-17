#!/bin/bash
set -e

HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

PEERS_FILE="/etc/bird/dynamic_peers.txt"
DAYS_LIMIT=30

# секунды
MAX_AGE=$((DAYS_LIMIT * 86400))

NOW=$(date +%s)

TMP_ACTIVE="/tmp/bird_active_peers.txt"
TMP_REMOVE="/tmp/bird_remove_peers.txt"

> "$TMP_ACTIVE"
> "$TMP_REMOVE"

# Получаем информацию о bgp-протоколах
birdc show protocols all | awk '
/^dyn_/ { proto=$1 }
/^  BGP state:/ { state=$3 }
/^  Last error:/ { }
/^  Since:/ {
    # сохраняем всё
    print proto "|" state "|" $2 " " $3
}' | while IFS='|' read PROTO STATE SINCE_DATE SINCE_TIME; do

    SINCE_TS=$(date -d "$SINCE_DATE $SINCE_TIME" +%s 2>/dev/null || echo 0)
    AGE=$((NOW - SINCE_TS))

    # извлекаем IP из имени протокола dyn_1.2.3.4
    PEER_IP=$(echo "$PROTO" | sed 's/^dyn_//')

    if [ "$STATE" = "Established" ]; then
        echo "$PEER_IP" >> "$TMP_ACTIVE"
    else
        if [ "$AGE" -gt "$MAX_AGE" ]; then
            echo "$PEER_IP" >> "$TMP_REMOVE"
        fi
    fi
done

# Удаляем старые IP из dynamic_peers.txt
if [ -s "$TMP_REMOVE" ]; then
    echo "Удаляются неактивные BGP клиенты:"
    cat "$TMP_REMOVE"

    grep -v -F -f "$TMP_REMOVE" "$PEERS_FILE" > "${PEERS_FILE}.new"
    mv "${PEERS_FILE}.new" "$PEERS_FILE"

    # применяем конфигурацию
    birdc configure
else
    echo "Неактивных клиентов для удаления нет."
fi

# cleanup
rm -f "$TMP_ACTIVE" "$TMP_REMOVE"

exit 0