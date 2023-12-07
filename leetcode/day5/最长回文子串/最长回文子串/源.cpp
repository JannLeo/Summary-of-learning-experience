#include <iostream>
#include <vector>
using namespace std;
string s = "bbadacabd";
//
//string s = "uhrfjotnewtodhmbplsaolnpcdaohiytmfllukijouxipvqohtsgxbtfoxyfkfczkfwhzimbefiohmtimrcxbpgcxogystdkcqujvbxsgirpccdnvejtljftwkdpsqpflzwruwwdzovsbmwbcvlftkjnxqaguvtsycylqzquqkbnybnbaeahbxejhphwrpmymcemuhljwtuvxefqfzjhskuqhifydkxpnfwfxkpeexnjltfqwfvchphmtsrsyayxukvmlqodshqwbeaxhcxdbssnrdzvxtusngwqdxvluauphmmbwmgtazjwvolenegwbmjfwprfuswamyvgrgshqocnhirgyakbkkggviorawadzhjipjjgiwpelwxvtaegauerbwpalofrbghfhnublttqtcmqskcocwwwxpnckrnbepusjyohsrretrqyvgnbezuvwmzizcefxyumtdwnqjkgsktyuacfpnqocqjxcurmipjfqmjqrkdeqsfseyigqlwmzgqhivbqalcxhlzgtsfjbdbfqiedogrqasgmimifdexbjjpfusxsypxobxjtcwxnkpgkdpgskgkvezkriixpxkkattyplnpdbdifforxozfngmlgcunbnubzamgkkfbswuqfqrvzjqmlfqxeqpjaqayodtetsecmfbplscmslpqiyhhykftzkkhshxqvdwmwowokpluwyvavwvofwqtdilwqjgrprukzyhckuspyzaoe";
//
//int find_flag(int offset,int len) {
//	string sub = s.substr(offset, len);
//	int flag = 0;
////	judge the manacher
//	for (int j = 0; j < sub.length() / 2; j++) {
//		if (sub.at(j) != sub.at(sub.length() - 1 - j)) {
//			flag = 0; //not the manacher
//			break;
//		}
//		if (j == sub.length() / 2 - 1) {
//			flag = 1;
//		}
//	}
//	return flag;
//}
int judge(vector<vector<int>>P,int valx,int valy) {
	if (s[valx] != s[valy]) return 0;
	if (valy - valx < 3) {
		if (s[valx] == s[valy]) {
			return 1;
		}
	}
	if (valy - valx > 2) {
		if (P[valx + 1][valy - 1] == 1 && s[valx] == s[valy]) {
			return 1;
		}
	}
	return 0;
}
void main() {
	int len = s.length(); //length of the string
	vector<vector<int>>P(len,vector<int>(len,0));
	int maxlen = 1;
	int offset = 0;
	for (int i = 0; i < len; i++) {
		P[i][i] = 1;
	}
	// dp[i][j] = dp[i+1][j-1] && s[i] == s[j] (长度大于2的子串)
	for (int L = 2; L <= len; L++) {
		for (int i = 0; i < len ; i++) {
			int j = L + i - 1;
			if (j >= len)
				break;
			P[i][j] = judge(P, i, j);
			if (j - i + 1 > maxlen && P[i][j]) {
				maxlen = j - i + 1;
				offset = i;
			}
			
		}
	}
	cout << s.substr(offset, maxlen)<<endl;

}