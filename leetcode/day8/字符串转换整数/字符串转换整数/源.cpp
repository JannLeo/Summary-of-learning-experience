#include <iostream>
using namespace std;
int myAtoi(string s) {
	int flag = 0;
	int num = 0;
	for (int i = 0; i < s.size(); i++) {
		if (flag == 0) {
			if (s[i] == ' ')
				continue;
			else if (s[i] == '-')
				flag = -1;
			else if (s[i] == '+')
				flag = 1;
			else if (s[i] >= '0' && s[i] <= '9') {
				flag = 1;
				num *= 10;
				num += (s[i] - '0');

			}
			else
				break;
		}
		else {
			if (s[i] >= '0' && s[i] <= '9') {
				num *= 10;
				num += (s[i] - '0');

			}
			else
				break;
		}
		if (flag == 1) {
			if (i + 1 < s.size())
				if (((num > 214748364 && s[i + 1] - '0' >= 0 && s[i + 1] - '0' <= 9)) || (num == 214748364 && s[i + 1] - '0' > 7 && s[i + 1] - '0' <= 9)) {
				num = 2147483647;
				break;
			}
		}
		else if (flag == -1) {
			if (i + 1 < s.size())
			if (((num > 214748364 && s[i+1] - '0' >= 0 && s[i+1] - '0' <= 9)) || (num == 214748364 && s[i+1] - '0' >= 8)) {
				num = -2147483648;
				break;
			}
		}
	}
	if(num>0)
		num *= flag;
	return num;
}
void main() {
	string s = "-2147483648";
	int num=myAtoi(s);
	cout << num << endl;
}