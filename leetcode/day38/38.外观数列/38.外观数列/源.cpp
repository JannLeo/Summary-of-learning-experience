#include <iostream>
#include <stack>
#include <vector>
using namespace std;

string recursion(string& temp,int times) {
	if (times == 0)
		return temp;
	int num = 0;
	int length = temp.size();
	char base = temp[0];
	string result = "";
	for (int i = 0; i < length; i++) {
		if (base == temp[i]) {
			num++;
		}
		else{
			result += (num + '0');
			result += base;
			base = temp[i];
			num = 1;
		}
		if (i == length - 1) {
			result += (num + '0');
			result += base;
		}
	}
	return recursion(result, times - 1);
}
string countAndSay(int n) {
	string result = "1";
	if (n == 1)
		return result;
	result = recursion(result, n - 1);
	return result;
}

int main() {
	int n = 4;
	string result = countAndSay(n);
	return 0;
}
