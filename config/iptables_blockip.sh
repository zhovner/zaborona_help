#!/bin/bash

# We have detected a network attack from an IP from your network,
# a computer connected to it is probably infected and being part of a botnet
iptables -I FORWARD -s 0/0 -d 5.145.172.0/24 -j DROP
iptables -I FORWARD -s 5.145.172.0/24 -d 0/0 -j DROP
iptables -I FORWARD -s 0/0 -d 178.162.192.0/18 -j DROP
iptables -I INPUT -s 5.145.172.0/24 -j DROP
iptables -I OUTPUT -d 5.145.172.0/24 -j DROP
iptables -I OUTPUT -d 178.162.192.0/18 -j DROP
 
exit 0
