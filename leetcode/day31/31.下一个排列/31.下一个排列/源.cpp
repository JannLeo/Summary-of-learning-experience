#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;
void nextPermutation(vector<int>& nums) {
	// 5 4 1 4 3 1
	// 5 4 3 1 1 4
	int length = nums.size();
	// index  num
	pair<int, int> max_num(-1,-1);
	for (int i = length - 1; i > 0; i--) {
		if (nums[i] <= nums[i - 1]) {
			continue;
		}
		max_num.second = nums[i - 1];
		max_num.first = i - 1;
		int temp = nums[i - 1];
		for (int j = i; j < length; j++) {
			if (max_num.second == nums[i - 1] && max_num.second < nums[j]) {
				max_num.second = nums[j];
				max_num.first = j;
			}
			else if (max_num.second != nums[i - 1] && max_num.second > nums[j] && nums[j] > nums[i - 1]) {
				max_num.second = nums[j];
				max_num.first = j;
			}
		}
		nums[i - 1] = max_num.second;
		nums[max_num.first] = temp;
		sort(nums.begin() + i, nums.end());
		return;
	}
	sort(nums.begin(), nums.end());
}
void main() {
	vector<int> nums({ 1,3,2 });
	nextPermutation(nums);
}