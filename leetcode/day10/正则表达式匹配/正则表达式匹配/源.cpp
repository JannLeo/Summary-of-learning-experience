#include <iostream>
#include <vector>
using namespace std;
bool isMatch(string s, string p) {
	int m = s.size();
	int n = p.size();
	if (!m || !n) {
		return 1;
	}
	vector<vector<bool>> dp(m+1, vector<bool >(n+1,0));
	dp[0][0] = 1;
	for (int i = 1; i <= n; i++) {
		if (p[i - 1] == '*') {
			dp[0][i] = dp[0][i - 2];
		}
	}
	for (int i = 1; i < m+1; i++) {
		for (int j = 1; j < n+1; j++) {
			if (p[j - 1] != '*') {
				if (s[i - 1] == p[j - 1] || p[j - 1] == '.') {
					dp[i][j] = dp[i - 1][j - 1];
				}
			}
			else {
				if (p[j - 2] != s[i - 1] && p[j - 2] != '.')
					dp[i][j] = dp[i][j - 2];
				else
					dp[i][j] = (dp[i][j - 2]) || dp[i][j - 1] || dp[i - 1][j];
				/*dp[i][j] = (dp[i][j - 2]) || (dp[i - 1][j] && (s[i] == p[j - 1] || p[j - 1] == '.'));*/
			}
		}
	}
	return dp[m][n];



	//while (num = c.find("*") != -1) {
	//	c = c.erase(num,num+1);
	//	
	//}
	//
	//while (i<s.size()||k<p.size()) {
	//	if ((s[i] == p[k] || p[k] == '.')) {
	//		p[k] = s[i];
	//		k++;
	//		
	//	}
	//	else if (p[k] == '*') {
	//		

	//		if (i > 0 && (p[k - 1] == s[i] || p[k - 1] == '.')) {
	//			i++;
	//			if (i >= s.size()) {
	//				if (p[p.size() - 1] == s[s.size() - 1])
	//					return 1;
	//			}
	//			while (i < s.size() && (p[k - 1] == s[i + 1] || p[k - 1] == '.')) {
	//				i++;
	//				if (i >= s.size()) {
	//					if (p[p.size() - 1] == s[s.size() - 1])
	//						return 1;
	//				}
	//			}
	//		}
	//		
	//		k++;
	//		continue;
	//	}
	//	else {
	//		if (i >= s.size() && c != s)
	//			return 0;
	//		k++;
	//		if (k >= p.size() && i < s.size())
	//			return 0;
	//		
	//		continue;
	//	}
	//	/*if (p[p.size() - 1] == s[s.size() - 1])
	//		return 1;*/
	//	if (k < p.size() && i >= s.size()) {
	//		return 0;
	//	}
	//	
	//	i++;
	//	
	//}
	//return 1;
}
void main() {
	string s;
	string p;
	
	s = "mississippi";
	
	s = "aaa";
	s = "aab";
	s = "aaba";
	s = "a";
	s = "aab";
	
	p = "mis*is*ip*.";
	p = "aaaa";
	p = "c*a*b";
	p = "ab*a*c*a";
	p = "ab*c*";
	
	p = ".*c";
	p = ".*..";
	p = ".*";
	p = "c*a*b";
	cout<<isMatch(s, p)<<endl;
}