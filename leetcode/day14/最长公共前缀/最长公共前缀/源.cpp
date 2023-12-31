#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;
string longestCommonPrefix(vector<string>& strs) {
	if (!strs.size()) {
		return "";
	}
	string str = "";
	sort(strs.begin(), strs.end());
	for (int i = 0; i < strs[0].size(); i++) {
		if (strs[0][i] == strs[strs.size() - 1][i]) {
			str += strs[0][i];
		}
		else
			return str;
	}

	/*int flag = 0;
	int numi = 0;
	int length = 10000;
	string str = "";
	for (int i = 0; i < strs.size(); i++) {
		if (strs.size() == 1)
			return strs[0];
		if (length > strs[i].size()) {
			length = strs[i].size();
			numi = i;
		}
	}
	if (!length)
		return "";
	for (int i = 1; i <= length; i++) {
		str = strs[numi].substr(0,i);
		for (int j = 0; j < strs.size(); j++) {
			if (j != numi) {
				if (strs[j].substr(0, i) != str) {
					flag = 1;
					break;
				}
			}
		}
		if (flag) {
			if (i == 1)
				return "";
			str = strs[numi].substr(0, i-1);
			return str;
		}
	}
	return strs[numi];*/
	
}
void main() {
	vector<string> strs(3);
	strs[0] = "a";
	strs[1] = "b";
	strs[2] = "b";
	cout<<longestCommonPrefix(strs);
}