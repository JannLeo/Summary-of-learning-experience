#include <iostream>
#include <math.h>
using namespace std;
int reverse(int x) {
	int num = 0;
	int flag = 0;
	if (x < 0) flag = 1;
	while (x) {
		num += (x % 10);
		x /= 10;
		if ((num == -214748364 || num == 214748364) && ((x > 7 && flag == 0) || (x < -8 && flag == 1)))
			return 0;
		if ((num > 214748364 || num < -214748364) && x % 10 != 0) {
			return 0;
		}
		if (x != 0) num *= 10;
	}
	return num;
}

void main() {
	int x;
	x = -2147483648;
	cout << reverse(x) << endl;
}