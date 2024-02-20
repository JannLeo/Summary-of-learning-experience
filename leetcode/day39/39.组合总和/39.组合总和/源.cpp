#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;
void DFS(vector<vector<int>>& result, vector<int>& candidates, int target,int pos) {
	if (pos >= candidates.size() || candidates[pos] > target)
		return;
	if (!(target % candidates[pos])) {
		result.push_back({ candidates[pos] });
	}
	int temp = target - candidates[pos];
	if (temp == 0)
		return;
	else {
		DFS(result, candidates, temp, pos + 1);
	}

}
vector<vector<int>> combinationSum(vector<int>& candidates, int target) {
	vector<vector<int>> result;
	if (candidates[0] > target)
		return result;
	DFS(result, candidates, target, 0);
}
int main() {
	vector<int> candidates({ 2,3,6,7 });
	int target = 7;
	vector<vector<int>> result;

	result =  combinationSum(candidates, target);
	return 0;
}