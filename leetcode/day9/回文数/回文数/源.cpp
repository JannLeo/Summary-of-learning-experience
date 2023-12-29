#include <iostream>
using namespace std;

bool isPalindrome(int x) {
	if (x < 0)
		return 0;
	int bit = 0;
	int first = x;
	int last = x;
	int y = x;
	while (y) {
		y /= 10;
		bit++;
	}
	while (first&&last) {
		int a = (first % 10);
		int b = (last / pow(10, bit - 1));
		if (a != b)
			return 0;
		first /= 10;
		last = last % (int)pow(10, bit - 1);
		bit--;
	}
	return 1;
	
}
void main() {
	int x = 121;
	cout << isPalindrome(x) << endl;
}