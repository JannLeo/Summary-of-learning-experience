#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;
void DFS(vector<vector<int>>& result, vector<int>& candidates, vector<int>& current,  int target, int pos) {
	if (target == 0) {
		result.push_back(current);
		return;
	}
	for (int i = pos; i < candidates.size() && target >= candidates[i]; i++) {
		current.push_back(candidates[i]);
		DFS(result, candidates, current, target - candidates[i], i);
		current.pop_back();
	}
}
vector<vector<int>> combinationSum(vector<int>& candidates, int target) {
	vector<vector<int>> result;
	vector<int> current;
	sort(candidates.begin(), candidates.end());
	if (candidates[0] > target)
		return result;
	DFS(result, candidates, current, target, 0);
	return result;
}
int main() {
	vector<int> candidates({ 7,3,9,6 });
	// 3 6 7 9
	int target = 6;
	vector<vector<int>> result;

	result =  combinationSum(candidates, target);
	return 0;
}