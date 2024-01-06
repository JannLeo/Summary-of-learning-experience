#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;
vector<vector<int>> fourSum(vector<int>& nums, int target) {
	vector<vector<int>> result;
	vector<double> tempnums;
	for (const auto& num : nums) {
		tempnums.push_back(num);
	}
	if (tempnums.size() < 4) {
		return result;
	}
	sort(tempnums.begin(), tempnums.end());
	if ((tempnums[0] > target && tempnums[0] > 0) )
		return result;
	int itfirst, itsecond, itthird, itforth;
	for (itfirst = 0; itfirst < tempnums.size() - 3; itfirst++) {
		if (itfirst != 0 && tempnums[itfirst] == tempnums[itfirst - 1]) {
			continue;
		}
		if (tempnums[itfirst] + tempnums[tempnums.size() - 1] + tempnums[tempnums.size() - 2] + tempnums[tempnums.size() - 3] < target) {
			continue;
		}
		for (itsecond = itfirst + 1; itsecond < tempnums.size() - 2; itsecond++) {
			if (itsecond != itfirst + 1 && tempnums[itsecond] == tempnums[itsecond - 1]) {
				continue;
			}
			if (tempnums[itfirst] + tempnums[tempnums.size() - 1] + tempnums[tempnums.size() - 2] + tempnums[itsecond] < target) {
				continue;
			}
			itthird = itsecond + 1;
			itforth = tempnums.size() - 1;
			while (itthird < itforth)
			{
				double num = tempnums[itfirst] + tempnums[itsecond] + tempnums[itthird] + tempnums[itforth]-target;
				if (num == 0) {
					if (result.size() != 0) {
						if (!((result[result.size() - 1][0] == tempnums[itfirst]&& result[result.size() - 1][1] == tempnums[itsecond]) && (result[result.size() - 1][2] == tempnums[itthird] && result[result.size() - 1][3] == tempnums[itforth]))) {
							result.push_back({ (int)tempnums[itfirst],(int)tempnums[itsecond] , (int)tempnums[itthird] , (int)tempnums[itforth] });
						}

					}else
						result.push_back({ (int)tempnums[itfirst],(int)tempnums[itsecond] , (int)tempnums[itthird] , (int)tempnums[itforth] });
					
					itthird++;
					itforth--;
				}
				else if (num > 0) {
					itforth--;
					while (itthird < itforth && itforth != tempnums.size() - 1 && tempnums[itforth] == tempnums[itforth + 1])
						itforth--;
				}
				else if (num < 0) {
					itthird++;
					while (itthird < itforth && itthird != itsecond + 1 && tempnums[itthird] == tempnums[itthird - 1])
						itthird++;
				}
					
			}
		}
	}
	return result;
}
void main() {
	vector<int> nums;
	int target;
	nums = { 0,0,0,1000000000,1000000000,1000000000,1000000000 };
	target = 1000000000;
	vector<vector<int>> result;
	result = fourSum(nums, target);
	for (const auto& sums : result) {
		for (const auto& sum : sums) {
			cout << sum << " ";
		}
		cout << endl;
	}
}