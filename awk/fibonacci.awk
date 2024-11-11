# example awk script to be executed as
#     awk -v n=5 -f fibonacci.awk
#     awk -v n=10 -f fibonacci.awk

BEGIN {
    fibonacci(n, seq)
    for (i = 1; i <= n; ++i) {
        if (length(ans)) ans = ans " "
        ans = ans " " seq[i]
    }
    print(ans)
}

function fibonacci(n, seq) {
    seq[1] = 0
    if (n >= 2) {
        seq[2] = 1
        for (i = 3; i <= n; ++i)
            seq[i] = seq[i-2] + seq[i-1]
    }
}
