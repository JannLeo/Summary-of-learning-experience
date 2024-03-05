#include <iostream>
#include <vector>
#include <unordered_map>
using namespace std;
void DFS(vector<int>& nums,vector<vector<int>>& result,int first,
	vector<int>& temp,vector<bool>& flag) {
	int n = nums.size();
	if (first >= n) {
		result.push_back(temp);
		return;
	}
	// 1 2 3 4
	for (int i = 0; i < n; i++) {
		if (!flag[i]) {
			temp.push_back(nums[i]);
			flag[i] = true;
			DFS(nums, result, first + 1, temp,flag);
			temp.pop_back();
			flag[i] = false;

		}
	}
}
vector<vector<int>> permute(vector<int>& nums) {
	vector<vector<int>> result;
	vector<bool> flag(nums.size(),0);
	vector<int> temp;
	DFS(nums, result, 0, temp, flag);
	return result;
}
int main() {
	vector<int> nums({ 1,2,3,4 });
	vector<vector<int>> result = permute(nums);
	return 0;
}