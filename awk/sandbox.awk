@include "mylib.awk"

{
    split($1, nums, ",")
    target = $2
    twoSum(nums, target, ans)
    print ans[1] " " ans[2]
}

function twoSum(nums, target, ans,     i, seen) {
    for (i = 1; i <= length(nums); ++i) {
        if (target-nums[i] in seen) {
            ans[1] = seen[target-nums[i]]
            ans[2] = i
            break
        }
        seen[nums[i]] = i
    }
}
