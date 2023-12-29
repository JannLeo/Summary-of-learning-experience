#include <iostream>
#include <map>
#include <algorithm>
using namespace std;
string intToRoman(int num) {
	int digit[7] = { 1,5,10,50,100,500,1000 };
	string romanStr = "IVXLCDM";
	string str = "";
	int num_dig[7] = { 0,0,0,0,0,0,0 };
	for (int i = 6; i >= 0; i--) {
		int dig = num / digit[i];
		if (dig) {
			num_dig[i] = dig;
			num -= (digit[i] * dig);
		}
	}
	for (int i = 0; i < 7; i++) {
		if (i == 4 || i == 2 || i == 0) {
			if ((num_dig[i] * digit[i] + num_dig[i + 1] * digit[i + 1]) == ( digit[i + 2] - digit[i])) {
				str += romanStr[i + 2];
				str += romanStr[i];
				
				i += 1;
				continue;
			}
			else if ((num_dig[i] * digit[i]) == (digit[i + 1] - digit[i])) {
				str += romanStr[i + 1];
				str += romanStr[i];
				
				i += 1;
				continue;
			}
			else {
				for (int j = 0; j < num_dig[i]; j++) {
					str += romanStr[i];
				}
			}
		}
		else {
			for (int j = 0; j < num_dig[i]; j++) {
				str += romanStr[i];
			}
		}
	}
	reverse(str.begin(), str.end());
	return str;
}
void main() {
	int num;
	num = 58;
	cout << intToRoman(num) << endl;
}