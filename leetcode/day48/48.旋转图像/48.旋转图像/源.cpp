#include <iostream>
#include <vector>
#include <unordered_map>
using namespace std;
void rotate(vector<vector<int>>& matrix) {
	int size_m = matrix.size();
	if (size_m == 1)
		return;
	for (int i = 0; i <= (size_m - 2); i++) {
		for (int j = i+1; j <= size_m - 1 ; j++) {
			swap(matrix[i][j], matrix[j][i]);
		}
	}
	double line = (size_m - 1) / 2.0;
	for (int i = 0; i < size_m; i++) {
		for (int j = 0; line - j > 0; j++) {
			swap(matrix[i][j], matrix[i][j + (line - j) * 2]);
		}
	}
	return;
}
int main() {
	vector<vector<int>> matrix({ {1,2,3,4,5},{6,7,8,9,10},{11,12,13,14,15},{16,17,18,19,20},{21,22,23,24,25}});
	//vector<vector<int>> matrix({ {5, 1, 9, 11 }, { 2, 4, 8, 10 }, { 13, 3, 6, 7 }, { 15, 14, 12, 16 }});
	rotate(matrix);
	return 0;
}