#include <iostream>
#include <vector>
#include<unordered_map>
using namespace std;
//void DSP(vector<int>&height,int left,int right,int& sum,int leftMax,int rightMax) {
//	if (right == left - 1) {
//		return;
//	}
//	//移动左指针
//	if (leftMax <= rightMax) {
//		if (leftMax > height[left]) {
//			sum += leftMax - height[left];
//		}
//		else {
//			leftMax = height[left];
//		}
//		DSP(height, left + 1, right, sum, leftMax, rightMax);
//	}
//	else {
//		if (rightMax > height[right]) {
//			sum += rightMax - height[right];
//		}
//		else {
//			rightMax = height[right];	
//		}
//		DSP(height, left, right - 1, sum, leftMax, rightMax);
//	}
//}


int trap(vector<int>& height) {
	if (height.size() <= 2)
		return 0;
	int result = 0;
	int size = height.size();
	vector<int> leftMax(size,0);
	vector<int> rightMax(size, 0);
	leftMax[0] = height[0];
	rightMax[size - 1] = height[size - 1];
	for (int i = 1 ; i < size; i++) {
		leftMax[i] = max(leftMax[i - 1], height[i]);
		rightMax[size - i - 1] = max(rightMax[size - i], height[size - i - 1]);
	}
	for (int i = 0; i < size; i++) {
		result += min(leftMax[i]-height[i], rightMax[i]-height[i]);
	}
	//DSP(height, 0, height.size() - 1, result, height[0], height[height.size()-1]);
	return result;
}
int main() {
	vector<int> height({ 0,1,0,2,1,0,1,3,2,1,2,1 });
	int result =  trap(height);
	return 0;
}