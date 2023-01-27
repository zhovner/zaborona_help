{
    domainzone = gensub(/(.*)\.([^.]+$)/, "\\2", 1)
    domainname = gensub(/(.*)\.([^.]+$)/, "\\1", 1)
    domainlength = length(domainname)
    domainarray[domainzone][domainlength][domainname] = domainname
    #print "adding", $0, ":", domainzone, domainlength, domainname
}


function printarray(arrname, arr) {
    firsttime_1 = 1
    firsttime_2 = 1

    print arrname, "= {"

    for (domainzone in arr) {
        if (firsttime_1 == 0) {printf ",\n"} firsttime_1 = 0;

        print "\"" domainzone "\":{"

        for (domainlength in arr[domainzone]) {
            if (firsttime_2 == 0) {printf ",\n"} firsttime_2 = 0;

            printf " %s", "" domainlength ":\""
            for (domainname in arr[domainzone][domainlength]) {
                printf "%s", domainname
            }
            printf "\""
        }

        firsttime_2 = 1;
        printf "\n}"
    }
    print "};"
}

# Final function
END {
    printarray("domains", domainarray)
}
