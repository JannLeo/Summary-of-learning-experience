#include <iostream>
#include <vector>
#include<unordered_map>
using namespace std;
void DSP(vector<int>&height,int left,int right,int& sum,int leftMax,int rightMax) {
	if (right == left - 1) {
		return;
	}
	//移动左指针
	if (leftMax <= rightMax) {
		if (leftMax > height[left]) {
			sum += leftMax - height[left];
		}
		else {
			leftMax = height[left];
		}
		DSP(height, left + 1, right, sum, leftMax, rightMax);
	}
	else {
		if (rightMax > height[right]) {
			sum += rightMax - height[right];
		}
		else {
			rightMax = height[right];	
		}
		DSP(height, left, right - 1, sum, leftMax, rightMax);
	}
}
int trap(vector<int>& height) {
	if (height.size() <= 2)
		return 0;
	int result = 0;
	DSP(height, 0, height.size() - 1, result, height[0], height[height.size()-1]);
	return result;
}
int main() {
	vector<int> height({ 5,5,1,7,1,1,5,2,7,6 });
	int result =  trap(height);
	return 0;
}