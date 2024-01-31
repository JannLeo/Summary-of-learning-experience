#include <iostream>
#include <vector>
using namespace std;
int removeElement(vector<int>& nums, int val) {
	if (nums.size() ==0) {
		return 0;
	}
	int i = 0;
	int length = nums.size();
	int gap = 0;
	// 0,1,2,2,3,0,4,2  val = 2
	while ( i < length) {
		if (val == nums[i]) {
			gap++;
		}
		else {
			nums[i - gap] = nums[i];
			
		}
		i++;
	}
	return i-gap;
}
void main() {
	vector<int> nums({1});
	int val = 1;
	removeElement(nums, val);
}