#BEGIN {PROCINFO["sorted_in"] = "@unsorted"}
BEGIN {PROCINFO["sorted_in"] = "@ind_num_asc"; qq = 0}

# Skipping empty strings
(!$1) {next}

{d_ip[qq] = $1; qq+=1;}

function iptodec(v) {
    split(v,s,".")
    return s[4] + s[3]*256 + s[2]*65536 + s[1]*16777216
}

function ipdecto36(r) {
    baselen = split("0123456789abcdefghijklmnopqrstuvwxyz", base, "")

    rr = ""
    do {
        rr = base[(r % baselen) + 1] rr
    } while (r = int(r / baselen))
    return rr
}

function printarray_hex(arrname, arr) {
    d_printed_end = 0
    previous_dec = 0
    print "var", arrname, "= \"\\"
    for (i in arr) {
        d_printed_end = 0
        printf "%s ", ipdecto36(iptodec(arr[i]) - previous_dec)
        previous_dec = iptodec(arr[i])
        if (i % 40 == 0) {
            print "\\"
            d_printed_end = 1
        }
    }
    if (d_printed_end == 0) {
        print "\\"
    }
    print "\".split(\" \");"
    print ""
}

# Final function
END {
    #asort(d_ip)

    printarray_hex("d_ipaddr", d_ip)
}
