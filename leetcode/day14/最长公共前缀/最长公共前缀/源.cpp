#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;
//分治法
//string combinetwoparts(string leftstr,string rightstr) {
//	if (leftstr.size() > rightstr.size()) {
//		return combinetwoparts(rightstr,leftstr);
//	}
//	string str1 = "";
//	for (int i = 0; i < leftstr.size(); i++) {
//		if (leftstr[i] == rightstr[i]) {
//			str1 += leftstr[i];
//			//break;
//		}
//		else
//			break;
//	}
//	return str1;
//}
//string dividedtwoparts(int head,int tail,vector<string>& strs) {
//	if (tail==head) {
//		return strs[head];
//	}
//	else if (tail - head == 1) {
//		return combinetwoparts(strs[head],strs[tail]);
//	}
//	else {
//		string leftstr = dividedtwoparts(head, (head + tail) / 2, strs);
//		string rightstr = dividedtwoparts((head + tail) / 2 + 1, tail, strs);
//		return combinetwoparts(leftstr,rightstr);
//	}
//}
bool findsame(vector<string>& strs, int mid) {
	string str = *min_element(strs.begin(), strs.end());
	for (int i = 0; i < strs.size(); i++) {
		for (int j = 0; j < mid; j++) {
			if (strs[i][j] != str[j]) {
				return false;
			}
		}
	}
	return true;
}
//二分法
string dividedtwoparts(int head,int tail, vector<string>& strs) {
	while (head < tail) {
		int mid = (tail - head + 1) / 2 + head;
		if (findsame(strs, mid)) {
			head = mid;
		}
		else {
			tail = mid - 1;
		}
	}
	return strs[0].substr(0, head);
}
string longestCommonPrefix(vector<string>& strs) {
	if (strs.size() == 0)
		return "";
	else if (strs.size() == 1) {
		return strs[0];
	}
	else {
		int shortestlen = (*min_element(strs.begin(), strs.end())).size();
		return  dividedtwoparts(0, shortestlen, strs);
		
	}


	////分治法
	//if (!strs.size())
	//	return "";
	//else {
	//	return dividedtwoparts(0, strs.size() - 1, strs);
	//}





	//暴力优化法
	/*if (!strs.size()) {
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
	}*/


	//暴力法
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
	vector<string> strs(2);
	strs[0] = "ab";
	strs[1] = "a";
	//strs[2] = "flight";
	//strs[2] = "b";
	cout<<longestCommonPrefix(strs);
}