#include <iostream>
#include <vector>
#include <unordered_map>
#include <sstream>
using namespace std;
bool isMatch(string s, string p) {
	int m = s.size();
	int n = p.size();
	vector<vector<bool>> dp(m + 1, vector<bool>(n + 1, false));
	dp[0][0] = true;
	for (int i = 1; i < n+1; i++) {
		if (p[i - 1] == '*') {
			dp[0][i] = true;
		}
		else break;
	}
	for (int i = 1; i <= m; i++) {
		for (int j = 1; j <= n; j++) {
			if (p[j - 1] == s[i - 1] || p[j - 1] == '?') {
				dp[i][j] = dp[i - 1][j - 1];
			}
			else if (p[j - 1] == '*') {
				dp[i][j] = (dp[i][j - 1] || dp[i - 1][j]);
			}
		}
	}
	return dp[m][n];
}
//unordered_map<string, bool> memo; // 使用哈希表存储已经计算过的结果
//bool isCompare(string s, string p,string temp, int s_pos,int p_pos) {
//	string key = to_string(s_pos) + "-" + to_string(p_pos); // 构造当前状态的唯一标识
//	if (memo.find(key) != memo.end()) {
//		return memo[key];
//	}
//	if (temp == s && p_pos >= p.size())
//		return true;
//	if (s_pos > s.size() && p_pos <= p.size() && p[p_pos]!='*')
//		return false;
//	if (p[p_pos] != '*') {
//		if (p[p_pos] == '?' || p[p_pos] == s[s_pos]) {
//			temp += s[s_pos];
//			return isCompare(s, p, temp, s_pos + 1, p_pos + 1);
//		}
//		else
//			return false;
//	}
//	else {
//		if (isCompare(s, p, temp, s_pos, p_pos + 1)) {
//			memo[key] = true;
//			return true;
//		}
//		p_pos++;
//		while (s_pos < s.size()) {
//			temp += s[s_pos];
//			s_pos++;
//			while (isCompare(s, p, temp, s_pos, p_pos)) {
//				memo[key] = true;
//				return true;
//			}
//		}
//		
//	}
//	memo[key] = false;
//	return false;
//}
//bool isMatch(string s, string p) {
//	if (p == "*" || (s == p))
//		return true;
//	if (s == "") {
//		int i = 0;
//		while (i<p.size()) {
//			if (p[i] != '*') {
//				return false;
//			}
//			i++;
//		}
//		return true;
//	}
//	return isCompare(s, p, "", 0, 0);
//}
int main() {
	string s = "bbaabbbbaaaabaabbbbabababaabaaaabaaabbaabaabaaabbabaabbbbbbbbbbaababbabaabbabaababbaaaabbbbaaaaaababbbbabbaababbabbabbababbbbabbbbaabaaabbaababbbaaaaababbbabbaaaaababbbaabbaabbbbbbbbbaababaababbababbabaa";
	string p = "*b****abb***bbba**b*baaa****ba*ab***a*ab**a*a***aabbabb*bb**b***bbbbab****b*ba*baa*b*aa*b*b***a*bbab*";
	bool result = isMatch(s,p);
	return 0;
}