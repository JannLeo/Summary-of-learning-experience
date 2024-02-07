#include <iostream>
#include <vector>
#include <stack>
using namespace std;
int longestValidParentheses(string s) {
	stack<int> a;
	int max_num = 0;
	a.push(-1);
	for (int i = 0; i < s.size(); i++) {
		if (s[i] == '(') {
			a.push(i);
		}
		else {
			a.pop();
			if (!a.empty()) {
				max_num = max(i - a.top(), max_num);
			}
			else {
				a.push(i);
			}
		}
	}
	return max_num;
}
void main() {
	string s;
	s = "())((()))";
	longestValidParentheses(s);
}