#include <iostream>
#include <vector>
#include<algorithm>
using namespace std;
void DFS(vector<int>& candidates, int target, int pos,vector<vector<int>> &result,vector<int> &temp) {
	if (target == 0) {
		result.push_back(temp);
		return;
	}
	for (int i = pos; i < candidates.size() && candidates[i] <= target; i++) {
		if (i > pos && candidates[i] == candidates[i - 1]) {
			// 跳过当前递归层次的重复元素
			// 1 1 2  target = 3
			continue;
		}
		temp.push_back(candidates[i]);
		DFS(candidates, target - candidates[i], i + 1, result, temp);
		temp.pop_back();
	}
}
vector<vector<int>> combinationSum2(vector<int>& candidates, int target) {
	sort(candidates.begin(), candidates.end());
	vector<vector<int>> result;
	if (target < candidates[0])
		return result;
	vector<int> temp;
	DFS(candidates, target, 0, result, temp);
	/*sort(result.begin(), result.end());
	result.erase(unique(result.begin(), result.end()), result.end());*/
	return result;
}
int main() {
	//[10,1,2,7,6,1,5]   1 1 2 5 6 7 10  target=8
	//[2,5,2,1,2] 1 2 2 2 5
	vector<int> candidates({ 10,1,2,7,6,1,5 });
	int target = 8;
	combinationSum2(candidates, target);
	return 0;
}