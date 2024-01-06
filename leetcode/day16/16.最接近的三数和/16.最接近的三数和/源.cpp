#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

int threeSumClosest(vector<int>& nums, int target) {
	//排序
	sort(nums.begin(), nums.end());
	
	int result = nums[nums.size()-1]+ nums[nums.size() - 2] + nums[nums.size() - 3];
	int num = INT32_MAX;
	//固定第一个数字考虑
	for (int itfirst = 0; itfirst < nums.size()-2; itfirst++) {
		int itsecond = itfirst + 1;
		int itthird = nums.size() - 1;
		if (itfirst > 0 && nums[itfirst] == nums[itfirst - 1]) {
			continue;
		}
		// 1 2 3 4 5 6 7 target : 0
		if (nums[itfirst] + nums[itfirst + 1] + nums[itfirst + 2] > target) {

			if (abs(nums[itfirst] + nums[itfirst + 1] + nums[itfirst + 2] - target) < abs(result - target))
				result = nums[itfirst] + nums[itfirst + 1] + nums[itfirst + 2];
			break;
		}
		// -4 -3 -2 -1 0 1 2 3   target: 100
		else if (nums[itfirst] + nums[nums.size() - 2] + nums[nums.size() - 1] < target) {
			if (abs(nums[itfirst] + nums[nums.size() - 2] + nums[nums.size() - 1] - target) < abs(result - target))
				result = nums[itfirst] + nums[nums.size() - 2] + nums[nums.size() - 1];
			continue;
		}
		while (itsecond < itthird) {
			num = nums[itfirst] + nums[itsecond] + nums[itthird];
			if (abs(result - target) > abs(num - target)) {
				result = num;
				
			}
			if (num == target)
				return target;
			//itsecond 偏小了
			if (num < target) {
				itsecond++;
				// -4 -3 -2 -1 0 1 2 3 4
				while (itsecond < itthird && nums[itsecond] == nums[itsecond - 1])
					++itsecond;

			}
			else {
				itthird--;
				while (itsecond < itthird && nums[itthird] == nums[itthird + 1])
					--itthird;
			}
		}
	}
	return result;
}


void main() {
	vector <int> nums;
	int target;
	/*nums = { -1, 2, 1, -4 };*/
	nums = { 0,0,0 };
	/*nums = { -100,-98,-2,-1 };
	nums = { 1,1,1,0 };
	nums = { 833,736,953,-584,-448,207,128,-445,126,248,871,860,333,-899,463,488,-50,-331,903,575,265,162,-733,648,678,549,579,-172,-897,562,-503,-508,858,259,-347,-162,-505,-694,300,-40,-147,383,-221,-28,-699,36,-229,960,317,-585,879,406,2,409,-393,-934,67,71,-312,787,161,514,865,60,555,843,-725,-966,-352,862,821,803,-835,-635,476,-704,-78,393,212,767,-833,543,923,-993,274,-839,389,447,741,999,-87,599,-349,-515,-553,-14,-421,-294,-204,-713,497,168,337,-345,-948,145,625,901,34,-306,-546,-536,332,-467,-729,229,-170,-915,407,450,159,-385,163,-420,58,869,308,-494,367,-33,205,-823,-869,478,-238,-375,352,113,-741,-970,-990,802,-173,-977,464,-801,-408,-77,694,-58,-796,-599,-918,643,-651,-555,864,-274,534,211,-910,815,-102,24,-461,-146 };
	nums = { 2,3,8,9,10 };*/
	nums = { -1000,-5,-5,-5,-5,-5,-5,-1,-1,-1 };
	target = -14;
	cout << threeSumClosest(nums, target) << endl;

}