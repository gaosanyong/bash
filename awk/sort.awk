# sort.awk is a light sort library in AWK.
# test with
#       awk -i math.awk 'BEGIN { split("2 5 7 4 6 2", nums); swap(nums, 2, 4); print nums }'
#       awk -i math.awk 'BEGIN { split("2 5 7 4 6 2", nums); shuffle(nums); print nums }'
#       awk -i math.awk 'BEGIN { split("2 5 7 4 6 2", nums); qksort(nums); print nums }'

function _part(nums, lo, hi) {
    # Dijkstra's partition algorithm
    i = lo+1
    j = hi
    while (i <= j) {
        if (nums[i] < nums[lo]) ++i
        else if (nums[lo] < nums[j]) --j;
        else {
            swap(nums, i, j)
            ++i
            --j
        }
    }
    return j
}

function _qksort(nums, lo, hi,      i, j) {
    # Workhorse of quick sort algorithm.
    if (lo < hi) {
        i = lo+1
        j = hi
        while (i <= j) {
            if (nums[i] < nums[lo]) ++i
            else if (nums[j] > nums[lo]) --j
            else {
                swap(nums, i, j)
                ++i
                --j
            }
        }
        swap(nums, lo, j)
        _qksort(nums, lo, j-1)
        _qksort(nums, j+1, hi)
    }
}

function qkselect(nums, k) {
    # Select kth (1-indexed) smallest element.
    shuffle(nums)
    lo = 1
    hi = length(nums)
    while (lo < hi) {
        mid = part(nums, lo, hi)
        if (mid < k) lo = mid+1
        else if (mid == k) return nums[mid]
        else hi = mid-1
    }
}

function qksort(nums) {
    # Sort an array in-place into ascending order via quick sort.
    shuffle(nums)
    _qksort(nums, 1, length(nums))
}

function shuffle(nums,      i, j) {
    # Shuffle array in-place with Knuth's shuffling.
    for (j = 1; j <= length(nums); ++j) {
        i = 1 + int(j*rand())
        if (i < j)
            swap(nums, i, j)
    }
}

function swap(nums, i, j,       temp) {
    # Swap ith and jth elements in array.
    temp = nums[i]
    nums[i] = nums[j]
    nums[j] = temp
}
