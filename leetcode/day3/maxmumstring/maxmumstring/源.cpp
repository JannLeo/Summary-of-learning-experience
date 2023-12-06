#include <iostream>
using namespace std;

void main() {
	string s,output;
	cin >> s;
	int length = 0;//length of the target string
	int slidenum = 0;
	for (int i = slidenum; i < s.length(); i++) {
		for (int j = 0; j < output.length(); j++) {
			if (output[j] == s[i]) {
				length= length > output.length() ? length : output.length();
				cout << output<<endl;
				output = "";
				slidenum++;
				i = slidenum;
				break;
			}
		}
			output += s[i];
			length = length > output.length() ? length : output.length();
	}

}