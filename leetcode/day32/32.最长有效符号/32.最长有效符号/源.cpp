#include <iostream>
#include <vector>
#include <stack>
using namespace std;
//int longestValidParentheses(string s) {
//	stack<int> a;
//	int max_num = 0;
//	a.push(-1);
//	for (int i = 0; i < s.size(); i++) {
//		if (s[i] == '(') {
//			a.push(i);
//		}
//		else {
//			a.pop();
//			if (!a.empty()) {
//				max_num = max(i - a.top(), max_num);
//			}
//			else {
//				a.push(i);
//			}
//		}
//	}
//	return max_num;
//}
int longestValidParentheses(string s) {
	int length = s.size();
	vector<int> temp(length, 0);
	int max_num = 0;
	for (int i = 1; i < length; i++) {
		if (s[i] == ')') {
			if (s[i - 1] == '(') {
				// ()()
				temp[i] = i - 2 > 0 ? temp[i - 2] + 2 : 2;
			}
			else {
				if (i - temp[i - 1] - 1 >= 0) {
					// 0 1 2 3 4 5 6 7
					// ) ( ) ( ( ) ) )
					// 0 0 2 0 0 2 6 0
					if (s[i - temp[i - 1] - 1] == '(') {
						temp[i] = i - 2 - temp[i - 1] > 0 ? temp[i - 1] + 2 + temp[i - 2 - temp[i - 1]] : temp[i - 1] + 2;
					}
				}
			}
			max_num = max(temp[i], max_num);
		}
	}
	return max_num;
}
void main() {
	string s;
	s = "())((()))";
	longestValidParentheses(s);
}