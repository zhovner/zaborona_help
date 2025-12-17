#!/bin/bash
set -e

HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

# Файл с разрешёнными сетями
ALLOWED_NETS="/etc/bird/allowed_nets.txt"

# Сброс старых правил BGP/OSPF
iptables -F BGP_OSPF 2>/dev/null
iptables -N BGP_OSPF 2>/dev/null || true
iptables -I INPUT -j BGP_OSPF

# Заблокировать всё по умолчанию
iptables -A BGP_OSPF -p tcp --dport 179 -j DROP
iptables -A BGP_OSPF -p ospf -j DROP  # если есть модуль OSPF

# Разрешить указанные сети
while read NET; do
    iptables -I BGP_OSPF -s $NET -p tcp --dport 179 -j ACCEPT
    iptables -I BGP_OSPF -s $NET -p ospf -j ACCEPT
done < $ALLOWED_NETS

echo "Firewall для BGP/OSPF обновлён."

echo "Update File OK"

exit 0