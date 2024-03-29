Ukraine PAC file generator, light version
=========================================

Генератор PAC-файла сервиса [Заборона.хелп](https://zaborona.help/).

Данный набор скриптов создаёт файл [автоконфигурации прокси](https://en.wikipedia.org/wiki/Proxy_auto-config) со списком сайтов, заблокированных на территории Украины и другими государственными органами, который можно использовать в браузерах, для автоматического проксирования заблокированных ресурсов.

Помимо основного назнчения скрипта (генерации PAC-файла), он также умеет создавать:

* Файл клиентской конфигурации (client-config, CCD) с заблокированными диапазонами IP-адресов для OpenVPN;
* Файл с заблокированными доменными зонами для Squid;
* Файл с заблокированными доменными зонами в LUA-переменной, для использования с DNS-резолвером knot-resolver либо dnsmasq.

### Зависимости

* Bash
* cURL
* GNU coreutils
* GNU AWK (gawk)
* sipcalc
* idn
* Python 3.4+

### Конфигурационные файлы

* **{in,ex}clude-{hosts,ips}-dist** — конфигурация дистрибутива, предназначена для изменения автором репозитория;
* **{in,ex}clude-{hosts,ips}-custom** — пользовательская конфигурация, предназначена для изменения конечным пользователем скрипта;
* **exclude-regexp-dist.awk** — файл с различным заблокированным «мусором», раздувающим PAC-файл: зеркалами сайтов, неработающими сайтами, и т.д.
* **config.sh** — файл с адресами прокси.

### Установка и запуск

Склонируйте git-репозиторий, отредактируйте **doall.sh** и **process.sh** под собственные нужды, запустите **doall.sh**.
