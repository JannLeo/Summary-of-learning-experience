#include <iostream>
#include <vector>

using namespace std;
int dividedTwoParts(vector<int>& nums,int& target,int head,int tail) {
	if (nums[head] == target)
		return head;
	if (nums[tail] == target|| tail - head <= 1)
		return tail;
	int middle = (head + tail) / 2;
	if (nums[middle] < target)
		return dividedTwoParts(nums, target, middle, tail);
	else
		return dividedTwoParts(nums, target, head, middle);

}
int searchInsert(vector<int>& nums, int target) {
	int length = nums.size();
	if (!length)
		return 0;
	else if (length == 1)
		if (nums[0] < target)
			return 1;
		else
			return 0;
	if (nums[length - 1] < target)
		return length;
	if (nums[0] > target)
		return 0;
	return dividedTwoParts(nums, target, 0, length - 1);
}
void main() {
	vector<int> nums({1,3,5,6});
	int target = 7;
	int result=searchInsert(nums, target);
}