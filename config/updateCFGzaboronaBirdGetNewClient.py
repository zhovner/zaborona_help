#!/usr/bin/env python3
# ↑ shebang: указывает системе запускать скрипт через python3

import subprocess
# subprocess — нужен для запуска внешней программы tcpdump

import re
# re — модуль регулярных выражений, используется для извлечения IP из строки tcpdump

from datetime import datetime
# datetime — для записи времени обнаружения нового клиента в лог

OUT = "/etc/bird/dynamic_peers.txt"
# Файл, в котором хранятся IP-адреса клиентов, уже замеченных на BGP (TCP 179)

LOG = "/var/log/bgp-sniffer.log"
# Лог-файл для записи событий (когда обнаружен новый IP)

ip_re = re.compile(r'(\d+\.\d+\.\d+\.\d+)\.\d+ >')
# Регулярное выражение для извлечения IPv4-адреса источника
# Пример строки tcpdump:
# 1.2.3.4.54321 > 5.6.7.8.179:
# ↑ нас интересует только 1.2.3.4 (без порта)

def load_known():
    # Функция загружает уже известные IP-адреса из файла OUT

    try:
        # Пытаемся открыть файл со списком известных IP
        with open(OUT) as f:
            # Читаем все строки, убираем \n и складываем в set (множество)
            return set(line.strip() for line in f)
    except FileNotFoundError:
        # Если файла ещё нет — возвращаем пустой список
        return set()

known = load_known()
# Загружаем список уже известных IP при старте скрипта

proc = subprocess.Popen(
    # Запускаем tcpdump как подпроцесс
    ["tcpdump", "-nn", "-l", "tcp", "port", "179"],
    # -nn  → не резолвить имена (только IP)
    # -l   → построчный вывод (важно для real-time обработки)
    # tcp port 179 → фильтр только BGP-трафика

    stdout=subprocess.PIPE,
    # Перенаправляем stdout tcpdump в Python

    stderr=subprocess.DEVNULL,
    # stderr глушим, чтобы не засорять вывод

    text=True
    # text=True → строки, а не байты
)

for line in proc.stdout:
    # Читаем вывод tcpdump построчно в бесконечном цикле

    m = ip_re.search(line)
    # Применяем регулярное выражение к строке

    if not m:
        # Если IP не найден — пропускаем строку
        continue

    ip = m.group(1)
    # Извлекаем IPv4-адрес источника (без порта)

    if ip not in known:
        # Если этот IP ещё не был зафиксирован ранее

        known.add(ip)
        # Добавляем IP в оперативный список (в памяти)

        with open(OUT, "a") as f:
            # Открываем файл со списком клиентов на дозапись
            f.write(ip + "\n")
            # Записываем новый IP в файл

        with open(LOG, "a") as f:
            # Открываем лог-файл
            f.write(f"{datetime.now()} NEW BGP PEER {ip}\n")
            # Пишем событие с временной меткой
