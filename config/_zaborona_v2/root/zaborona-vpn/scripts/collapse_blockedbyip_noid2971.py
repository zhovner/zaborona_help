#!/usr/bin/env python3
import ipaddress
addrlist = open('result/iplist_blockedbyip_noid2971.txt', 'r').read()
speciallist = open('result/iplist_special_range.txt', 'r').read()
nlist = [ipaddress.IPv4Network(addr) for addr in addrlist.split()]
slist = [ipaddress.IPv4Network(addr) for addr in speciallist.split()]
print('IP Addresses before collapsing:', len(nlist))

for i, v in enumerate(nlist):
    if any([addr.overlaps(v) for addr in slist]):
        del nlist[i]

print('IP Addresses after removing special ranges:', len(nlist))

collapsed_file_prefix = open('result/iplist_blockedbyip_noid2971_collapsed.txt', 'w')
cnt = 0
for addr in nlist:
    print(str(addr).replace('/32', ''), file=collapsed_file_prefix)
    cnt+=1
