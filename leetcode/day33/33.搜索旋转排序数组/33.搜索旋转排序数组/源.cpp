#include <iostream>
#include <vector>
using namespace std;
int divideTwoPart(vector<int>& nums,int target,int head,int tail) {
	if (nums[head] == target)
		return head;
	else if (nums[tail] == target)
		return tail;
	else if (head == tail - 1)
		return -1;
	int middle = (head + tail) / 2;
	int leftSide = divideTwoPart(nums, target, head, middle);
	int rightSide = divideTwoPart(nums, target, middle, tail);
	if (leftSide == -1 && rightSide == -1)
		return -1;
	else if (leftSide == -1)
		return rightSide;
	else
		return leftSide;
}
int search(vector<int>& nums, int target) {
	int length = nums.size();
	if (!length || (length == 1 && target != nums[0]))
		return -1;
	return divideTwoPart(nums, target, 0, length-1);
}

void main() {
	vector<int> nums({ 1 });
	int target = 1;
	int a=search(nums,target);

}