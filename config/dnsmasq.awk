# ! /usr/bin/awk -f

BEGIN {
	OFS = ",";
}

$7 == "query[A]" {
	time = mktime(sprintf("%04d %02d %02d %s\n", strftime("%Y", systime()), (match("JanFebMarAprMayJunJulAugSepOctNovDec",$1)+2)/3, $2, gensub(":", " ", "g", $3)));
	query = $8;
	host = $10;
	print time, host, query;
}
