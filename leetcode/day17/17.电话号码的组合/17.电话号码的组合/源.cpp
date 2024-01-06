#include <iostream>
#include <vector>
#include <unordered_map>
#include <algorithm>
using namespace std;
void DFS(vector<string>& results, unordered_map<char, string>& alphabet, int index, string& digits, string& tempresult) {
	if (index >= digits.size()) {
		results.push_back(tempresult);
	}
	else {
		char alpha = digits[index];
		const string& strs = alphabet.at(alpha);
		for (const char& str : strs) {
			tempresult.push_back(str);
			DFS(results, alphabet, index + 1, digits, tempresult);
			tempresult.pop_back();
		}

	}
}
vector<string> letterCombinations(string digits) {
	vector<string> results;
	if (!digits.size())
		return results;
	unordered_map<char, string> alphabet{
		{'2',"abc"},
		{'3',"def"},
		{'4',"ghi"},
		{'5',"jkl"},
		{'6',"mno"},
		{'7',"pqrs"},
		{'8',"tuv"},
		{'9',"wxyz"}
	};
	string result;
	DFS(results, alphabet, 0, digits, result);
	return results;
}

	//// 'a' = 97  '2' = 50   'd' = 100  '3'=51
	//// 0110 0001  0011 0010  0110 0100  
	//// alphabet number started from a  special: p:112  w:119
	//int alnum = 97;
	////Start from 2
	//int mulnum = -1;
	////÷ÿ∏¥Œ Ã‚
	//vector<string> alpha;




	/*vector<vector<char>> numtoalp;*/
	//sort(digits.begin(), digits.end());
	/*for (int i = 0; i < digits.size(); i++) {
		for (int j = i + 1; j < digits.size(); j++) {
			if (digits[i] == digits[j]) {
				if (digits[i] - 49 != 7 || digits[i] - 49 != 9) {
					for (int k = 0; k < 3; k++) {
						string p = "" + (char)((digits[i]-50)*3+97+k) + (char)((digits[i] - 50) * 3 +97+k);
						alpha.push_back(p);
					}

				}
				else {
					if(digits[i] - 49 == 7)
					for (int k = 0; k < 4; k++) {
						string p = "" + (char)((digits[i] - 50) * 3 + 97 + k) + (char)((digits[i] - 50) * 3 + 97 + k);
						alpha.push_back(p);
					}
					else {
						for (int k = 0; k < 4; k++) {
							string p = "" + (char)((digits[i] - 50) * 3 +1+ 97 + k) + (char)((digits[i] - 50) * 3 +1+ 97 + k);
							alpha.push_back(p);
						}
					}
				}
			}
		}
	}
	
	for (const char& str : digits) {
		if ((int)str - 49 != 6 && str - 49 != 8) {
			vector<char> temp;
			temp = { (char)((str - 50)*3 + 97),(char)((str - 50) * 3 +97 + 1),(char)((str - 50) * 3 + 97 + 2) };
			numtoalp.push_back(temp);

		}
		else if(str - 49 ==6){
			vector<char> temp;
			temp = { (char)((str - 50) * 3 + 97),(char)((str - 50) * 3 + 97 + 1),(char)((str - 50) * 3 + 97 + 2),(char)((str - 50) * 3 + 97 + 3) };
			numtoalp.push_back(temp);
		}
		else {
			vector<char> temp;
			temp = { (char)((str - 50) * 3 +1+ 97),(char)((str - 50) * 3 + 97 +1+ 1),(char)((str - 50) * 3 + 97 + 1 + 2),(char)((str - 50) * 3 + 97 + 3+1) };
			numtoalp.push_back(temp);
		}
	}
	for (int i = 0; i < numtoalp.size(); i++) {
		for (int j = i+1; j < numtoalp.size(); j++) {
			for (int k = 0; k < numtoalp[i].size(); k++) {
				for (int l = 0; l < numtoalp[j].size(); l++) {
					string p = "";
					p+= (char)numtoalp[i][k];
					p += (char)numtoalp[j][l];
					alpha.push_back(p);
				}
			}
		}
	}
	return alpha;*/


void main() {
	string digits;
	digits = "222";
	for (const auto& num : letterCombinations(digits)) {
		cout << num << endl;
	}
}