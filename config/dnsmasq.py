import re
from dateutil.parser import parse
import json

def parseline(l):
	m = re.search('(.*) dnsmasq\\[(\d*)\]\\: \query\[(.*)\] (.*) from (.*)', l)
	try:
		r = {'ts':parse(m.group(1)).strftime('%s'), 'query_type':m.group(3), 'query':m.group(4), 'source':m.group(5)}
	except:
		print (l)
		sys.exit()
	return r

f = open("/var/log/dnsmasq/log-queries.log",'r')
d = f.read()
f.close()

x = d.splitlines()

results = []
for l in x:
	if 'query[' in l:
		q = parseline(l)
		if q['query_type'] == 'A':
			results.append(q)

print (json.dumps(results))
