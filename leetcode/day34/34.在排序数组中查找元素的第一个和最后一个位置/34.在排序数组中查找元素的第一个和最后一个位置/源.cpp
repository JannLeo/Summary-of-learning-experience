#include <iostream>
#include <vector>
using namespace std;
int dividedTwoParts(vector<int>& nums, int target, int head, int tail, bool flag) {
	if (nums[head] == target && !flag)
		return head;
	else if (nums[tail] == target && flag)
		return tail;
	if (tail - head <= 1) {
		if (nums[tail] == target)
			return tail;
		else if (nums[head] == target)
			return head;
		else
			return -1;
	}

	if (nums[head] > target || nums[tail] < target)
		return -1;
	int middle = (head + tail) / 2;
	int leftSide = dividedTwoParts(nums, target, head, middle,flag);
	int rightSide = dividedTwoParts(nums, target, middle, tail,flag);
	if (!flag)
		return leftSide != -1 ? leftSide : rightSide;
	else
		return rightSide != -1 ? rightSide : leftSide;
}
vector<int> searchRange(vector<int>& nums, int target) {
	vector<int> result({-1,-1});
	int length = nums.size();
	if (!length)
		return result;
	else if (length == 1) {
		if (target == nums[0])
			return { 0,0 };
		else
			return result;
	}
	result[0] = dividedTwoParts(nums, target, 0, length-1,0);
	result[1] = result[0];
	if (result[0] != -1) {
		int i = result[0];
		while (i < length - 1) {
			if (nums[i + 1] != target) {
				result[1] = i;
				break;
			}
			result[1] = ++i;
		}
	}
	return result;
}
void main() {
	vector <int> nums({ 3,3 });
	int target = 3;
	vector <int> result=searchRange(nums, target);
}