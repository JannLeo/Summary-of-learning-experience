#include<iostream>
#include <vector>
#include <algorithm>
using namespace std;
void DFS(vector<int>& nums, vector<vector<int>>& result,
	vector<int>& temp, int first, vector<bool>&flag) {
	int n = nums.size();
	if (first >= n) {
		sort(result.begin(), result.end());
		if (result.size() != 0 && temp != result[result.size() - 1])
			result.push_back(temp);
		return;
	}
	for (int i = 0; i < n; i++) {
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
	DFS(nums, result, temp, 0, flag);
	
	//result.erase(unique(result.begin(), result.end()), result.end());
	return result;
}
int main() {
	vector<int> nums({ 1,1,2 });
	vector<vector<int>>result =permuteUnique(nums);
	return 0;
}