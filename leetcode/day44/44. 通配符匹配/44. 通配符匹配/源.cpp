#include <iostream>
#include <vector>
#include <unordered_map>
using namespace std;
bool isCompare(string s, string p,string temp, int s_pos,int p_pos) {
	if (temp == s && p_pos >= p.size())
		return true;
	if (s_pos > s.size() && p_pos <= p.size() && p[p_pos]!='*')
		return false;
	if (p[p_pos] != '*') {
		if (p[p_pos] == '?' || p[p_pos] == s[s_pos]) {
			temp += s[s_pos];
			return isCompare(s, p, temp, s_pos + 1, p_pos + 1);
		}
		else
			return false;
	}
	else {
		if (isCompare(s, p, temp, s_pos, p_pos + 1))
			return true;
		p_pos++;
		while (s_pos < s.size()) {
			temp += s[s_pos];
			s_pos++;
			while (isCompare(s, p, temp, s_pos, p_pos)) return true;
		}
		
	}
	return false;
}
bool isMatch(string s, string p) {
	if (p == "*" || (s == p))
		return true;
	if (s == "") {
		int i = 0;
		while (i<p.size()) {
			if (p[i] != '*') {
				return false;
			}
			i++;
		}
		return true;
	}
	return isCompare(s, p, "", 0, 0);
}
int main() {
	string s = "babaaababaabababbbbbbaabaabbabababbaababbaaabbbaaab";
	string p = "***bba**a*bbba**aab**b";
	bool result = isMatch(s,p);
	return 0;
}