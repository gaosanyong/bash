#
# example awk script to be executed as
#     awk -f fractorize.awk

@include "math.awk"
{
    n = int($1)
    factorize(n, factors)
    ans = ""
    for (i = 0; i < length(factors); ++i) {
        if (i) ans = ans " * "
        ans = ans factors[i]
    }
    print n " = " ans
}
