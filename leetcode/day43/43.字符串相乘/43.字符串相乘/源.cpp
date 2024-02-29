#include <iostream>

#include <vector>
#include <unordered_map>
using namespace std;
string multiply(string num1, string num2) {
	if (num1 == "0" || num2 == "0")
		return "0";
	int length1 = num1.length();
	int length2 = num2.length();
	string result = "";
	vector<int> temp(length1 + length2, 0);
	// 1 2 3
	for (int i = length1 - 1; i >= 0; i--) {
		int x = num1[i] - '0';
		for (int j = length2 - 1; j >= 0; j--) {
			int y = num2[j] - '0';
			temp[i + j + 1] += x * y;
		}
	}
	// 0 1 2 3
	for (int i = length1 + length2 - 1; i > 0; i--) {
		temp[i - 1] += temp[i] / 10;
		temp[i] %= 10;
	}
	int i = 0;
	if (temp[0] == 0) {
		i++;
	}
	for (; i < length1+length2; i++) {
		result += (temp[i]+'0');

	}
	return result;
}
int main() {
	string num1 = "123";
	string num2 = "456";
	multiply(num1,num2);
	return 0;
}