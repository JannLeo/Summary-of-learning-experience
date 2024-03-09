#include<iostream>
#include <vector>
#include <algorithm>
using namespace std;
void DFS(vector<int>& nums, vector<vector<int>>& result,
	vector<int>& temp, int first, vector<bool>&flag) {
	int n = nums.size();
	if (first >= n) {
		result.push_back(temp);
		return;
	}
	for (int i = 0; i < n; i++) {
		// 1a 1b 2   1 1 2  
		// 0 0 0
		if (flag[i] || i > 0 && nums[i] == nums[i - 1] && !flag[i - 1])
			continue;
		if (!flag[i]) {
			temp.push_back(nums[i]);
			flag[i] = true;
			DFS(nums, result, temp, first + 1, flag);
			flag[i] = false;
			temp.pop_back();
		}
	}
}
vector<vector<int>> permuteUnique(vector<int>& nums) {
	int n = nums.size();
	vector<vector<int>> result;
	vector<int> temp;
	vector<bool> flag(n);
	if (n == 1) {
		result.push_back(nums);
		return result;
	}
	sort(nums.begin(), nums.end());
	DFS(nums, result, temp, 0, flag);
	/*sort(result.begin(), result.end());
	result.erase(unique(result.begin(), result.end()), result.end());*/
	return result;
}
int main() {
	vector<int> nums({ 1,1,2 });
	vector<vector<int>>result =permuteUnique(nums);
	return 0;
}