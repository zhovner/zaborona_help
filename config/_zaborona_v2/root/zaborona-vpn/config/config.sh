#!/bin/bash

# HTTPS (TLS) proxy address
PACHTTPSHOST='proxy-ssl.zaboronahelp.pp.ua:3143'

# Usual proxy address
PACPROXYHOST='proxy-nossl.zaboronahelp.pp.ua:29976' 

# Special proxy address for ranges
PACPROXYSPECIAL='CCAHIHA.zaboronahelp.pp.ua:3128'

PACFILE="result/proxy-host-ssl.pac"
PACFILE_NOSSL="result/proxy-host-nossl.pac"

# Perform DNS resolving to detect and filter non-existent domains
RESOLVE_NXDOMAIN="no"
