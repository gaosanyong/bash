# math.awk is a light math library in AWK.
# test with
#       awk -i math.awk 'BEGIN { print abs(-5) }'
#       awk -i math.awk 'BEGIN { print max(10, 7) }'
#       awk -i math.awk 'BEGIN { print min(10, 7) }'
#       awk -i math.awk 'BEGIN { print gcd(24, 18) }'
#       awk -i math.awk 'BEGIN { print lcm(24, 18) }'
#       awk -i math.awk 'BEGIN { print pow(2, 98, 100000) }'

# return absolute value.
function abs(x) {
    return x > 0 ? x : -x;
}

# return maximum value of two numbers.
function max(x, y) {
    return x > y ? x : y
}

# return minimum value of two numbers.
function min(x, y) {
    return x < y ? x : y
}

# return greatest common divisor of two numbers
function gcd(x, y,      tmp) {
    while (y) {
        tmp = x
        x = y
        y = tmp % y
    }
    return x
}

# return least common multiple of two numbers.
function lcm(x, y) {
    if (x == 0 || y == 0) return 0
    return x*y / gcd(x, y)
}

# return x**p % m.
# Integer in AWK goes up to 2**53. To avoid overflow, try using m <= 10**7.
function pow(x, p, m,       ans) {
    ans = 1
    while (p) {
        if (and(p, 1)) ans = ans * x % m
        x = x * x % m
        p = rshift(p, 1)
    }
    return ans
}

# return prime factorization.
function factorize(n, factors,      i, x) {
    delete factors
    i = 0
    for (x = 2; x^2 <= n; ++x)
        while (n % x == 0) {
            n /= x
            factors[i++] = x
        }
    if (n > 1)
        factors[i] = n
}
