( $4 ~ /dnsmasq\[[0-9]+\]:/ ) {
	if ( $5 == "query[A]") {
		query[$6]++;
	} else {
		if ( $5 == "forwarded" )
			forwarded[$6]++;
		else
			if ( $5 == "cached" )
				cached[$6]++;
	}
}
END {
	queries=0;
	qforwarded=0
	qacache=0
	printf " %40s |      nb    |  forwarded |  answered from cache \n", "name";
	for (name in query) {
		printf "%s%40s | %9d  | %9d  | %9d\n", \
				( forwarded[name] > query[name] ? "*" : " "), \
				name, \
				query[name], \
				forwarded[name], \
				cached[name];
		queries += query[name];
		qforwarded += forwarded[name];
		qacache += cached[name];
	}

	print "";
	printf " %40s | %9d  | %9d  | %9d\n", "total:", queries, qforwarded, qacache;
}
