
@include "sort.awk"
@include "string.awk"
BEGIN {
    split("1 5 4 3 2 6 2 2 7", nums)
    asort(nums)
    print join(nums, " ")
}
