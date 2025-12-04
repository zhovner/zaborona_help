#!/bin/bash
set -e

HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

# Получаем список доменов с определенной зоной из лога dnsmasq и пишем в файл. Для использования gawk, его нужно сначала установить: apt install gawk
# gawk -f /root/dnsmasq_v2.awk /var/log/dnsmasq/log-queries.log > /root/dnsmasq-log-queries.txt
awk -f /root/dnsmasq_v2.awk /var/log/dnsmasq/log-queries.log > /root/dnsmasq-log-queries.txt

##sort -u /root/dnsmasq-log-queries.txt > /root/domainsdb-automatic_filling-sorted.txt
#awk 'FNR==NR {exclude[$0]; next} !($0 in exclude)' /root/dnsmasq-log-queries.txt /root/domainsdb-automatic_filling.txt > /root/domainsdb-automatic_filling-sorted.txt

# Считыывем ДНС-имена из файла и пишем в общий файл базы
cat /root/dnsmasq-log-queries.txt >> /root/domainsdb-automatic_filling.txt
# Копируем/считываем общий файл базы и записываем все во временный файл
cat /root/domainsdb-automatic_filling.txt > /root/domainsdb-automatic_filling-sorted.txt
# Сортируем файл и удаляем дубликаты во временном файле и после этого выгружаем отфильтрованный список назад в общий файл базы
sort -u /root/domainsdb-automatic_filling-sorted.txt > /root/domainsdb-automatic_filling.txt

exit 0
