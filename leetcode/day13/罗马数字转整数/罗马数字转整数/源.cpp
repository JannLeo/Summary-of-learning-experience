#include <iostream>
#include <string>
#include <map>
#include <unordered_map>
using namespace std;

int romanToInt(string s) {
	unordered_map<char, int> symbol = {
		{'I',1},
		{'V',5},
		{'X',10},
		{'L',50},
		{'C',100},
		{'D',500},
		{'M',1000}
	};
	int num = 0;
	int record = 0;
	for (int i = s.size() - 1; i >= 0; i--) {
		int value = symbol[s[i]];
		if (value >= record) {
			num += value;
		}
		else
			num -= value;
		record = value;
	}
	
	//return num;

	/*string roman[13] = { "I","IV","V","IX","X","XL","L","XC","C","CD","D","CM","M" };
	int digit[13] = { 1,4,5,9,10,40,50,90,100,400,500,900,1000 };*/
	/*for (int i = 0; i < s.size(); i++) {
		for (int j = set; j >= 0; j--) {
			if (set - j == 2) {
				set = j;
			}
			string s1(1, s[i]);
			if (roman[j] == s1) {
				num += digit[j];
				break;
			}
			else if (roman[j] == s1+s[i+1]) {
				num += digit[j];
				i++;
				break;
			}
		}
	}*/
	return num;
}
void main() {
	string s;
	s = "MCMXCIV";	
	cout<<romanToInt(s);

}