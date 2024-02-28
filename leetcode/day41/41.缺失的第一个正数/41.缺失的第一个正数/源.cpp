#include <iostream>
#include <vector>
#include <algorithm>
#include <unordered_map>
using namespace std;
int firstMissingPositive(vector<int>& nums) {
	int n = nums.size();
	for (int i = 0; i < n; i++) {
		if (nums[i] <= 0) {
			nums[i] = n + 1;
		}
	}
	for (int i = 0; i < n; i++) {
		int num = abs(nums[i]);
		if (num <= n) {
			nums[num - 1] = -1 * abs(nums[num - 1]);
		}
	}
	for (int i = 0; i < n; i++) {
		if (nums[i] > 0)
			return i + 1;
	}
	return n + 1;
}
//int firstMissingPositive(vector<int>& nums) {
//	int n = nums.size();
//	unordered_map<int, bool> temp;
//	for (int i = 0; i < n; i++) {
//		if (nums[i] > 0) {
//			temp[nums[i]] = 1;
//		}
//	}
//	int temp_num = temp.size();
//
//	for (int i = 0; i < temp_num; i++) {
//		if (!temp[i + 1]) {
//			return i + 1;
//		}
//	}
//	return temp_num + 1;
//}
//int firstMissingPositive(vector<int>& nums) {
//	int n = nums.size();
//	sort(nums.begin(), nums.end());
//	// 1 1 2 2
//	//nums.erase(unique(nums.begin(), nums.end()), nums.end());
//	int num = 1;
//	for (int i = 0; i < n; i++) {
//		if (nums[i] > 0) {
//			if (i < n - 1 && nums[i + 1] == nums[i])
//				continue;
//			if (num == nums[i]) {
//				num = nums[i] + 1;
//			}
//			else
//				return num;
//		}
//	}
//	return num;
//}
int main() {
	vector<int> nums({ 1 });
	int result = firstMissingPositive(nums);

	return 0;
}