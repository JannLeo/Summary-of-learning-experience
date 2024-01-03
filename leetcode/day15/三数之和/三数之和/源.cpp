#include <iostream>
#include <vector>
#include <algorithm>
#include <unordered_map>
using namespace std;
vector<vector<int>> threeSum(vector<int>& nums) {
	vector<vector<int>> threesum;
	sort(nums.begin(), nums.end());
	vector<int>::iterator itfirst = nums.begin();
	vector<int>::iterator itsecond = ++nums.begin();
	vector<int>::iterator itthird = --nums.end();
	while (*itfirst <= 0 && itfirst < --(--nums.end())) {
		if (itfirst != nums.begin() && *itfirst == *prev(itfirst)) {
			++itfirst;
			continue;
		}
		itsecond = itfirst;
		itsecond++;
		itthird = --nums.end();
		while (*itsecond <= *itthird && itsecond < itthird) {
			// + - 0
			int num = *itsecond + *itthird+*itfirst;
			if (num == 0) {
				vector<int> num1 = { *itfirst, *itsecond, *itthird };
				threesum.push_back(num1);
				
				while (itsecond < prev(itthird)  && *next(itsecond) == *itsecond)
					++itsecond;
				while (itsecond < prev(itthird) && *prev(itthird) == *itthird)
					--itthird;
				itsecond++;
				itthird--;
			}
			else if (num > 0) {
				--itthird;
			}
			else {
				++itsecond;
			}
		}
		++itfirst;
	}
	return threesum;

}

void main() {
	/*vector<int> nums(5);
	nums = { -2,0,1,1,2 };*/
	vector<int> nums(11);
	nums = { -1,0,1,2,-1,-4,-2,-3,3,0,4 };
	/*vector<int> nums(3);
	nums = { 0,0,0 };*/

	vector<vector<int>> nums1;
	nums1 = threeSum(nums);
	for (int i = 0; i < nums1.size(); i++) {
		for (int j = 0; j < 3; j++) {
			cout << nums1[i][j] << " " << endl;
		}
		cout << endl;
	}
	
}