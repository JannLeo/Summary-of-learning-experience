#include <iostream>
#include <vector>
using namespace std;
int subnumber(int sub1, int sub2) {
	if (!sub2)
		return sub1;
	sub2 = ~sub2 + 1;
	// 00 00 00
	// 00 01 01
	// 01 00 01
	// 01 01 10
	//
	while (sub2) {
		int temp = sub1 & sub2;
		sub1 = sub1 ^ sub2;
		sub2 = temp << 1;
	}
	return sub1;
}
int divide(int dividend, int divisor) {
	if (!dividend || divisor == 1) {
		return dividend;
	}
	if (divisor <= -2147483647) {
		return dividend <= divisor ? 1 : 0;
	}
	int result = 0;
	bool flag = 0;
	int div2;
	if (divisor < 0) {
		div2 = -divisor;
		flag = !flag;
	}
	else
		div2 = divisor;
	int div1;
	if (dividend == -pow(2, 31)) {
		if (divisor == -1) {
			return 2147483647;
		}
		div1 = -(dividend + div2);
		flag = !flag;
		result++;
	}
	else {
		if (dividend < 0) {
			div1 = -dividend;
			flag = !flag;
		}
		else
			div1 = dividend;
	}
	if (div1 < div2)
		return 0;
	for (int i = 31; i >= 0;i--) {
		if ((div1 >> i) >= div2) {
			div1 = subnumber(div1, div2 << i);
			result += (1 << i);
		}
	}
	if (flag) {
		result = -result;
	}
	return result;
}

void main() {
	int dividend = -1010369383, divisor = -2147483648;
	int a=divide(dividend, divisor);

}