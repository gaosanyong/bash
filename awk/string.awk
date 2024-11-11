
function join(array, fs,        ans, i) {
    # Join array of strings into a string with elements separated by fs.
    # Example:
    #       awk -i string.awk 'BEGIN{split("a b c", array); print join(array)}'
    ans = ""
    for (i = 1; i <= length(array); ++i) {
        if (i > 1) ans = ans fs;
        ans = ans array[i]
    }
    return ans
}

function kmp(pattern, text,     i, k, lps) {
    # Return index of first occurrence of pattern in text,
    # or 0 if not found.
    lps[1] = 1
    k = 1
    for (i = 2; i <= length(pattern); ++i) {
        while (k > 1 && substr(pattern, k, 1) != substr(pattern, i, 1)) k = lps[k-1]
        if (substr(pattern, k, 1) == substr(pattern, i, 1)) ++k
        lps[i] = k
    }
    k = 1
    for (i = 1; i <= length(text); ++i) {
        while (k > 1 && substr(pattern, k, 1) != substr(text, i, 1)) k = lps[k-1]
        if (substr(pattern, k, 1) == substr(text, i, 1)) ++k
        if (k == length(pattern)+1) return i-length(pattern)+1
    }
    return 0
}
