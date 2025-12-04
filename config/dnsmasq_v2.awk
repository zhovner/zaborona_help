# ! /usr/bin/gawk -f

#Simple script to parse log file and create list of dnsmasq domains
( $4 ~ /dnsmasq\[[0-9]+\]:/ ) {
	if ( $5 == "query[A]") {
		query[$6]++;
	}
}
END {
	for (name in query) {

		#Simple script to filter main domain
		split(name, parts, "."); 
		n = length(parts);
#		if (n >= 2) {
#		if (n >= 2 && parts[n] == "ru") {
		#Simple script for parsing domains by DNS zone
		if (n >= 2 && (parts[n] == "ru" || parts[n] == "su" || parts[n] == "by")) {
			print parts[n-1] "." parts[n];
		}

		#printf "%s \n", name;
		
	}
}
