#!/usr/bin/env python3
import ipaddress
import sys
addrlist = open(sys.argv[1], 'r').read()
#nlist = [ipaddress.IPv4Network(addr.replace(' ', '/')) for addr in addrlist.split("\n")]
nlist = [ipaddress.IPv4Network(addr) for addr in addrlist.split()]
#nlist = [ipaddress.IPv6Network(addr) for addr in addrlist.split()]
print('IP Addresses before collapsing:', len(nlist))
#collapsed_file_prefix = open('iplist_collapsed_prefix.txt', 'w')
#collapsed_file_mask = open('iplist_collapsed_mask.txt', 'w')
collapsed = ipaddress.collapse_addresses(nlist)
cnt = 0
for addr in collapsed:
    print(addr)
    #print(addr.with_netmask.replace('/', ' '))
    cnt+=1
print('IP Addresses after collapsing:', cnt)
