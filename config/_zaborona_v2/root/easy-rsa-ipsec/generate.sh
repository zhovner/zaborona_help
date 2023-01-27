#!/bin/bash
set -e
HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE/easyrsa3"

# 36500 days = 100 years
export EASYRSA_CERT_EXPIRE=36500

set +e

SERVER=""
for i in 1 2 3 4 5;
do
    SERVER="$(curl -s -4 icanhazip.com)"
    [[ "$?" == "0" ]] && break
    sleep 2
done
[[ ! "$SERVER" ]] && echo "Can't determine global IP address!" && exit 8

set -e


render() {
    local IFS=''
    local File="$1"
    while read -r line ; do
        while [[ "$line" =~ (\$\{[a-zA-Z_][a-zA-Z_0-9]*\}) ]] ; do
        local LHS=${BASH_REMATCH[1]}
        local RHS="$(eval echo "\"$LHS\"")"
        line=${line//$LHS/$RHS}
        done
        echo "$line"
    done < $File
}

load_key() {
    CA_CERT=$(grep -A 999 'BEGIN CERTIFICATE' -- "pki/ca.crt")
    CLIENT_CERT=$(grep -A 999 'BEGIN CERTIFICATE' -- "pki/issued/zaborona-vpn-client.crt")
    CLIENT_KEY=$(cat -- "pki/private/zaborona-vpn-client.key")
    if [ ! "$CA_CERT" ] || [ ! "$CLIENT_CERT" ] || [ ! "$CLIENT_KEY" ]
    then
            echo "Can't load client keys!"
            exit 7
    fi
}

build_pki() {
    ./easyrsa init-pki
    EASYRSA_BATCH=1 EASYRSA_REQ_CN="Zaborona.help" ./easyrsa build-ca nopass
    EASYRSA_BATCH=1 ./easyrsa build-server-full "zaborona-vpn-server" nopass nodatetime
    EASYRSA_BATCH=1 ./easyrsa build-client-full "zaborona-vpn-client" nopass nodatetime
#    EASYRSA_BATCH=1 ./easyrsa gen-dh
    openssl dhparam -out ./pki/dh2048.pem 2048
}

copy_keys() {
    cp ./pki/ca.crt /etc/openvpn/server/keys/zaborona-vpn-ca.crt
    cp ./pki/issued/zaborona-vpn-server.crt /etc/openvpn/server/keys/zaborona-vpn-server.crt
    cp ./pki/private/zaborona-vpn-server.key /etc/openvpn/server/keys/zaborona-vpn-server.key
    cp ./pki/dh2048.pem /etc/openvpn/server/keys/dh2048.pem
}

if [[ ! -f ./pki/ca.crt ]]
then
    build_pki
fi

if [[ ! -f "/etc/openvpn/server/keys/zaborona-vpn-ca.crt" ]] && \
   [[ ! -f "/etc/openvpn/server/keys/zaborona-vpn-server.crt" ]] && \
   [[ ! -f "/etc/openvpn/server/keys/zaborona-vpn-server.key" ]] && \
   [[ ! -f "/etc/openvpn/server/keys/dh2048.pem" ]] 
then
    copy_keys

    load_key

    cd ../

    render "templates/openvpn-udp-unified.conf" > "CLIENT_KEY/zaborona-vpn-client-udp.ovpn"
    render "templates/openvpn-tcp-unified.conf" > "CLIENT_KEY/zaborona-vpn-client-tcp.ovpn"
fi
