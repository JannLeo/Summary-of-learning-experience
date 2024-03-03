#include <iostream>
#include <vector>
#include <unordered_map>
using namespace std;
int jump(vector<int>& nums) {
	//2,3,1,1,4
    int n = nums.size();
	int jumpLongest = 0 , jumpEnd = 0, times = 0;
	for (int i = 0; i < n - 1; i++) {
		jumpLongest = max(jumpLongest, i + nums[i]);
		if (i == jumpEnd) {
			times++;
			jumpEnd = jumpLongest;
		}
	}
	return times;
}
//int DFS(vector<int>& nums,int pos,int times) {
//	if (pos >= nums.size() - 1)
//		return times;
//	int minJump = INT_MAX;
//	for (int i = 1; i <=nums[pos]; i++) {
//		int nextJump = DFS(nums, pos + i, times + 1);
//		minJump = min(minJump, nextJump);
//	}
//	return minJump;
//}
//int jump(vector<int>& nums) {
//	int n = nums.size();
//	if (n == 1)
//		return 0;
//	int result = INT_MAX;
//	result = DFS(nums, 0, 0);
//	
//	return result;
//}
int main() {
	vector <int> nums({ 2,3,1,1,4 });
	int result = jump(nums);
	return 0;
}