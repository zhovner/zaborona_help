#!/bin/bash
set -e

source config/config.sh
echo -n > "$PACFILE"

# .pac header
echo "// ProstoVPN.AntiZapret PAC-host File
// Generated on $(date)
// NOTE 1: Proxy.pac file content varies on User-Agent HTTP header.
// NOTE 2: Some badly behaving User-Agents are banned, they get empty response.
// NOTE 3: Do not request PAC file faster than once a minute, rate limiting is applied.
// NOTE 4: Do not use the proxy servers outside of this file.
" >> "$PACFILE"

awk -f scripts/generate-pac-domains.awk result/hostlist_zones.txt >> "$PACFILE"

# Collapse IP list
scripts/collapse_blockedbyip_noid2971.py

echo "// This variable now excludes IP addresses blocked by 27-31-2018/Id2971-18 (since 27.06.2019)" >> "$PACFILE"
sort -Vu temp/include-ips.txt result/iplist_blockedbyip_noid2971_collapsed.txt | \
    grep -v -F -x -f temp/exclude-ips.txt | awk -f scripts/generate-pac-ipaddrs.awk >> "$PACFILE"

SPECIAL="$(cat result/iplist_special_range.txt | xargs -n1 sipcalc | \
    awk 'BEGIN {notfirst=0} /Network address/ {n=$4} /Network mask \(bits\)/ {if (notfirst) {printf ","} printf "[\"%s\", %s]", n, $5; notfirst=1;}')"

echo "var special = [
$SPECIAL
];
var az_initialized = 0;
// CIDR to netmask, for special
function nmfc(b) {var m=[];for(var i=0;i<4;i++) {var n=Math.min(b,8); m.push(256-Math.pow(2, 8-n)); b-=n;} return m.join('.');}

function FindProxyForURL(url, host) {" >> "$PACFILE"

echo "  if (domains.length < 10) return \"DIRECT\"; // list is broken

  if (!('indexOf' in Array.prototype)) {
    Array.prototype.indexOf= function(find, i /*opt*/) {
      if (i===undefined) i= 0;
      if (i<0) i+= this.length;
      if (i<0) i= 0;
      for (var n= this.length; i<n; i++)
        if (i in this && this[i]===find)
          return i;
      return -1;
    };
  }

  if (!az_initialized) {
    var prev_ipval = 0;
    var cur_ipval = 0;
    for (var i = 0; i < d_ipaddr.length; i++) {
     cur_ipval = parseInt(d_ipaddr[i], 36) + prev_ipval;
     d_ipaddr[i] = cur_ipval;
     prev_ipval = cur_ipval;
    }

    for (var i = 0; i < special.length; i++) {
     special[i][1] = nmfc(special[i][1]);
    }

    az_initialized = 1;
  }

  var shost;
  if (/\.(ru|co|cu|com|info|net|org|gov|edu|int|mil|biz|pp|ne|msk|spb|nnov|od|in|ho|cc|dn|i|tut|v|dp|sl|ddns|dyndns|livejournal|herokuapp|azurewebsites|cloudfront|ucoz|3dn|nov|linode|amazonaws|sl-reverse|kiev|beget|kirov|akadns|scaleway|fastly)\.[^.]+$/.test(host))
    shost = host;
  else
    shost = host.replace(/(.+)\.([^.]+\.[^.]+$)/, \"\$2\");

  var curdomain = shost.match(/(.*)\\.([^.]+\$)/);
  if (!curdomain || !curdomain[2]) {return \"DIRECT\";}
  var curhost = curdomain[1];
  var curzone = curdomain[2];
  var curarr = []; // dummy empty array
  if (domains.hasOwnProperty(curzone) && domains[curzone].hasOwnProperty(curhost.length)) {
    if (typeof domains[curzone][curhost.length] === 'string') {
      var regex = new RegExp('.{' + curhost.length.toString() + '}', 'g');
      domains[curzone][curhost.length] = domains[curzone][curhost.length].match(regex);
    }
    var curarr = domains[curzone][curhost.length];
  }

  var oip = dnsResolve(host);
  var iphex = \"\";
  if (oip) {
   iphex = oip.toString().split(\".\");
   iphex = parseInt(iphex[3]) + parseInt(iphex[2])*256 + parseInt(iphex[1])*65536 + parseInt(iphex[0])*16777216;
  }
  var yip = 0;
  if (iphex && d_ipaddr.indexOf(iphex) !== -1) {yip = 1;}
  if (yip === 1 || curarr.indexOf(curhost) !== -1) {

    // WARNING! WARNING! WARNING!
    // You should NOT use these proxy servers outside of PAC file!
    // DO NOT enter it manually in any program!
    // By doing this, you harm the service!" >> "$PACFILE"

cp "$PACFILE" "$PACFILE_NOSSL"
echo "    return \"HTTPS ${PACHTTPSHOST}; PROXY ${PACPROXYHOST}; DIRECT\";" >> "$PACFILE"
echo "    return \"PROXY ${PACPROXYHOST}; DIRECT\";" >> "$PACFILE_NOSSL"

echo "  }
  for (var i = 0; i < special.length; i++) {
    if (isInNet(oip, special[i][0], special[i][1])) {return \"PROXY ${PACPROXYSPECIAL}; DIRECT\";}
  }

  return \"DIRECT\";
}" | tee -a "$PACFILE" "$PACFILE_NOSSL" >/dev/null 
