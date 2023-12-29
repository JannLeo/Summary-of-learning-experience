#include <iostream>
#include <vector>
#include <cmath>
using namespace std;
int maxArea(vector<int>& height) {
	//双指针
	int head = 0;
	int tail = height.size() - 1;
	int maxnum = 0;
	while (head != tail) {
		int minnum = min(height[head], height[tail]) * (tail - head);
		maxnum = maxnum < minnum ? minnum: maxnum;
		if (height[head] < height[tail]) {
			head++;
		}
		else {
			tail--;
		}
	}
	return maxnum;



	//暴力解法
	/*int maxx = 0;
	int maxy = 0;*/
	//步长
	/*for (int i = height.size() - 1; i > 0; i--) {
		for (int j = 0; j + i < height.size(); j++) {
			int temp = min(height[j+i], height[j]);
			if (maxy < temp) {
				if (maxy * maxx < temp * i) {
					maxy = temp;
					maxx = i;
				}
			}
		}
	}*/
	/*return maxx * maxy;*/
}
void main() {
	int n;
	n = 10;
	vector<int> height(n, 0);
	height = { 1,8,6,2,5,4,8,3,7 };
	cout << maxArea(height) << endl;
}