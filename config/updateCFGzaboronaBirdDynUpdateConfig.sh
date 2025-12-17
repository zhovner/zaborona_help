#!/bin/bash
#set -e

HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

# Файл с динамическими пирами
PEERS_FILE="/etc/bird/dynamic_peers.txt"

# Основной конфиг BIRD
#BIRD_CONF="/etc/bird/bird.conf"
BIRD_CONF="/etc/bird/dynamic_peers.conf"
#TEMP_CONF="/etc/bird/bird.conf.tmp"
TEMP_CONF="/etc/bird/dynamic_peers.conf.tmp"

# Вставляем маршруты из routes.conf
#cat /etc/bird/routes.conf >> "$TEMP_CONF"
#echo "}" >> "$TEMP_CONF"

# Динамические BGP-пиры
while read PEER_IP PEER_AS; do
    cat >> "$TEMP_CONF" <<EOL

protocol bgp dyn_$PEER_IP {
    local as 65432;
    neighbor $PEER_IP as $PEER_AS;
    multihop 100;
	#password "oH3sfT0lpE8xvP5kkC2gcM6ewU7vzR";

    import none;
    export filter EXPORT_TO_DYN_ROUTERS;

    graceful restart on;
}
EOL
done < "$PEERS_FILE"

# Перемещаем временный конфиг в основной
mv "$TEMP_CONF" "$BIRD_CONF"

# Перезагружаем конфиг BIRD
birdc configure

echo "BIRD конфиг обновлен и перезагружен."


exit 0