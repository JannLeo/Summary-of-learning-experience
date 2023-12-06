#include <iostream>
#include <vector>
using namespace std;
int find_kthnum(vector<int>nums1,int offset1,vector<int>nums2,int offset2,int k) {
	if (nums1.size() - offset1 > nums2.size() - offset2) {
		return find_kthnum(nums2, offset2, nums1, offset1, k);
	}

	if (nums1.size() == offset1) {
		if(k)
			return nums2.at(offset2 + k - 1);
		else
			return nums2.at(offset2 + k);
	}

	if (k == 1) return min(nums1.at(offset1), nums2.at(offset2));

	int idx1 = min((int)nums1.size(), k / 2+offset1);
	int idx2 = offset2 + k - k / 2;
	if(idx1-1>0&&idx2-1>0)
	if (nums1.at(idx1 - 1) <= nums2.at(idx2 - 1)) {
		return find_kthnum(nums1, idx1, nums2, offset2, k-(idx1-offset1));
	}
	else {
		return find_kthnum(nums1, offset1, nums2, idx2, k - (idx2 - offset2));
	}
}
int main() {
	vector<int> nums1, nums2;
	nums1.push_back(2);
	/*nums1.push_back(0);
	nums2.push_back(0);
	nums2.push_back(0);*/

	//二分查找
	int n = (nums1.size()+nums2.size());
	int offset1 = 0;
	int offset2 = 0;
	if (n % 2 == 0){
		double left = find_kthnum(nums1, offset1, nums2, offset2, n / 2);
		double right = find_kthnum(nums1, offset1, nums2, offset2, n / 2 + 1);
		cout << (left + right) / 2.0;
		return (double)(left + right) / 2.0;
	}
	else {
		cout << find_kthnum(nums1, offset1, nums2, offset2, n / 2);
		return (double)find_kthnum(nums1, offset1, nums2, offset2, n / 2);
	}
	
	

	//暴力法
	/*int size = nums1.size() + nums2.size();
	int flag = 0;
	if (size % 2 == 0) {
	//	flag =1;
	//	size /= 2;
	//}
	//else {
	//	size = (size+1) / 2;
	//}
	//
	int num = 0;
	int j = 0;
	int target_num1 = 0, target_num2 = 0;
	for (int i = 0; num < size+1;) {
		if (i < nums1.size()&&j<nums2.size()) {
			if (nums1.at(i) > nums2.at(j)) {
				if (num == size - 1) {
					target_num1 = nums2.at(j);
				}
				else if (num == size) {
					target_num2 = nums2.at(j);
				}
				j++;
			}
			else {
				if (num == size - 1) {
					target_num1 = nums1.at(i);
				}
				else if (num == size) {
					target_num2 = nums1.at(i);
				}
				i++;
			}
		}
		else if (i >= nums1.size() && j >= nums2.size()) {
			break;
		}
		else if(i>=nums1.size()){
			if (num == size - 1) {
				target_num1 = nums2.at(j);
				if(nums2.size()>j+1)
					target_num2 = nums2.at(j+1);
			}
			else if (num == size) {
				target_num2 = nums2.at(j);
			}
			j++;
		}
		else if (j >= nums2.size()) {
			if (num == size - 1) {
				target_num1 = nums1.at(i);
				if (nums1.size() > i + 1)
					target_num2 = nums1.at(i+1);
			}
			else if (num == size) {
				target_num2 = nums1.at(i);
			}
			i++;
		}
		num++;
	}
	float target = 0;
	if (flag == 1) {
		target = target_num1 + target_num2;
		target /= 2;
	}
	else
		target = target_num1;
	cout << target << endl;*/
}
