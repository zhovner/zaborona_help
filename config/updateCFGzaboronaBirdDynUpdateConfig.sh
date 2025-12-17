#!/bin/bash
set -e

HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

# Файл с динамическими пирами
PEERS_FILE="/etc/bird/dynamic_peers.txt"

# Основной конфиг BIRD
BIRD_CONF="/etc/bird/bird.conf"
TEMP_CONF="/etc/bird/bird.conf.tmp"

# Шаблон до секции динамических пиров
cat > "$TEMP_CONF" <<EOL
router id 203.0.113.1;

# Статические маршруты
protocol static static_routes {
EOL

# Вставляем маршруты из routes.conf
cat /etc/bird/routes.conf >> "$TEMP_CONF"
echo "}" >> "$TEMP_CONF"

# Динамические BGP-пиры
while read PEER_IP PEER_AS; do
    cat >> "$TEMP_CONF" <<EOL

protocol bgp dyn_$PEER_IP {
    local as 65001;
    neighbor $PEER_IP as $PEER_AS;
    multihop 5;

    ipv4 {
        import all;
        export all;
    };
}
EOL
done < "$PEERS_FILE"

# Перемещаем временный конфиг в основной
mv "$TEMP_CONF" "$BIRD_CONF"

# Перезагружаем конфиг BIRD
birdc configure

echo "BIRD конфиг обновлен и перезагружен."


exit 0