#!/bin/bash

# HTTPS (TLS) proxy address
#PACHTTPSHOST='proxy-ssl.zaboronahelp.pp.ua:3143'
PACHTTPSHOST='socks.zaboronahelp.pp.ua:1488'

# Usual proxy address
#PACPROXYHOST='proxy-nossl.zaboronahelp.pp.ua:29976'
PACPROXYHOST='socks.zaboronahelp.pp.ua:1488' 

# Special proxy address for ranges
#PACPROXYSPECIAL='CCAHIHA.zaboronahelp.pp.ua:3128'
PACPROXYSPECIAL='socks.zaboronahelp.pp.ua:1488'

PACFILE="result/proxy-host-ssl.pac"
PACFILE_NOSSL="result/proxy-host-nossl.pac"

# Perform DNS resolving to detect and filter non-existent domains
RESOLVE_NXDOMAIN="no"
