#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;
void nextPermutation(vector<int>& nums) {
	// 1 3 1 2 1
	int flag = 0;
	int length = nums.size();
	int max_index = length - 1;
	for (int i = length - 1; i >= 1; i--) {
		if (nums[max_index] > nums[i - 1]) {
			nums.insert(nums.begin()+i, nums[max_index]);
			flag = 1;
			break;
		}
	}
	if (!flag) {
		sort(nums.begin(), nums.end());
	}
}
void main() {
	vector<int> nums({ 3,2,1 });
	nextPermutation(nums);
}