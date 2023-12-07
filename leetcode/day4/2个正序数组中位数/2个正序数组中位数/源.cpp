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
	nums1.push_back(0);
	nums1.push_back(1);
	nums1.push_back(2);
	nums1.push_back(3);
	nums1.push_back(4);
	/*nums2.push_back(1);
	nums2.push_back(3);*/

	//划分数组
	
	vector<int> nums3;
	if (m > n) {
		nums3 = nums1;
		nums1 = nums2;
		nums2 = nums3;
	}
	int m = nums1.size();
	int n = nums2.size();
	int leftMax = 0, rightMin = 0;
	int iMin = 0, iMax = m;
	while (iMin <= iMax) {
		//i+j=(m+n+1)/2
		int i = (iMin + iMax) / 2;//主动取中间值
		int j = (m + n + 1) / 2 - i;
		//普通异常情况 不满足A[i-1]<B[j+1]条件 此时i大了 调整iMax
		if (i != 0 && j != n && nums1[i - 1] > nums2[j]) {
			iMax = i - 1;
		}
		// 不满足 A[i+1]>B[j-1] 此时需要增加A[i+1]的值 所以iMin改变
		else if (i != m && j != 0 && nums1[i] < nums2[j - 1]) {
			iMin = i + 1;
		}
		else {
			//此时要么为边界情况要么满足条件
			//i=0时 B[j-1]为左边最大
			if (i == 0) {
				leftMax = nums2[j - 1];
			}
			//j=0时 A[i-1]为左边最大
			else if (j == 0) {
				leftMax = nums1[i - 1];
			}
			else {
				leftMax = max(nums1[i - 1], nums2[j - 1]);
			}
			if ((m + n) % 2 == 1) {
				cout << leftMax << endl;
				return leftMax;
			}
			//i=m时 B[j+1]为右边最小
			if (i == m) {
				rightMin = nums2[j];
			}
			//j=n时 A[i+1]为右边最小
			else if (j == n) {
				rightMin = nums1[i];
			}
			else {
				rightMin = min(nums2[j], nums1[i]);
			}
			cout << (leftMax + rightMin) / 2.0 << endl;
			return (leftMax + rightMin) / 2.0;
		}
	}

	////二分查找
	//int n = (nums1.size()+nums2.size());
	//int offset1 = 0;
	//int offset2 = 0;
	//if (n % 2 == 0){
	//	double left = find_kthnum(nums1, offset1, nums2, offset2, n / 2);
	//	double right = find_kthnum(nums1, offset1, nums2, offset2, n / 2 + 1);
	//	cout << (left + right) / 2.0;
	//	return (double)(left + right) / 2.0;
	//}
	//else {
	//	cout << find_kthnum(nums1, offset1, nums2, offset2, n / 2);
	//	return (double)find_kthnum(nums1, offset1, nums2, offset2, n / 2);
	//}
	//
	

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
