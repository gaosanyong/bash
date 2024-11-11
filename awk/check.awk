# example awk script to be executed as
#     md5sum /bin/* | awk -f check.awk

{
    data[$1][length(data[$1])+1] = $0
}
END {
    for (k in data) {
        if (length(data[k]) > 1) {
            for (v in data[k])
                print data[k][v]
            print ""
        }
    }
}
