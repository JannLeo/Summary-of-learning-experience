#include <iostream>
#include <unordered_map>
#include <vector>
using namespace std;

void recursion(string& temp,int times) {

}
string countAndSay(int n) {
	string result = "1";
	unordered_map<char, int> record;
	for (int i = 0; i < 9; i++) {
		record[i + '0'] = 0;
	}
	if (n == 1)
		return result;
	recursion(result, n - 1);
	return result;
}

int main() {
	int n = 4;
	string result = countAndSay(n);
	return 0;
}
