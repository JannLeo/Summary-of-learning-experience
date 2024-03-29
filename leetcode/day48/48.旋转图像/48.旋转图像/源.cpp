#include <iostream>
#include <vector>
using namespace std;
void rotate(vector<vector<int>>& matrix) {
	int size_m = matrix.size();

}
int main() {
	vector<vector<int>> matrix({ {5, 1, 9, 11 }, { 2, 4, 8, 10 }, { 13, 3, 6, 7 }, { 15, 14, 12, 16 }});
	rotate(matrix);
	return 0;
}