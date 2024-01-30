#include <iostream>
#include <vector>
using namespace std;
int removeDuplicates(vector<int>& nums) {
	int k = nums.size();
	if (!k || k==1)
		return k;
	//指针1  表示需要比对的数字
	int num=nums[0];
	//指针2
	k = 1;
	//  0,0,1,1,1,2,2,3,3,4
	for (int i = 1; i < nums.size(); i++) {
		if (num != nums[i]) {
			num = nums[i];
			if(i!=k)
				nums[k] = nums[i];
			k++;
		}
	}
	return k;
}

void main() {
	vector <int> nums({0,0,1,1,1,2,2,3,3,4});
	removeDuplicates(nums);
}