#include <iostream>
#include <vector>
#include <unordered_map>
using namespace std;

vector<int> findSubstring(string s, vector<string>& words) {
	int words_length = words.size();
	int str_length = s.length();
	vector <int> result;
	int word_length = words[0].size();
	if (str_length < words_length * word_length)
		return result;
	// 记录words出现次数
	unordered_map< string,int> a;
	for (string temps : words) {
		a[temps]++;
	}
	//多起点滑动窗口
	//初始话多起点窗口
	vector<unordered_map<string, int>> win(word_length);
	for (int i = 0; i < word_length && i + word_length * words_length <= str_length; i++) {
		for (int j = i; j < i + word_length * words_length; j += word_length) {
			string temp = s.substr(j, word_length);
			win[i][temp]++;
		}
		if (win[i] == a) {
			result.emplace_back(i);
		}
	}
	//多窗口移动
	for (int i = word_length; i + word_length * words_length <= str_length; i++) {
		int win_place = i % word_length;//多滑动窗口相对位置
		string front_word = s.substr(i - word_length, word_length);
		string back_word = s.substr(i + word_length * words_length - word_length, word_length);
		if (--win[win_place][front_word] == 0) win[win_place].erase(front_word);
		win[win_place][back_word] ++;
		if (win[win_place] == a)
			result.emplace_back(i);
	}
	
	return result;
}

void main() {
	string s = "barfoofoobarthefoobarman";
	vector<string> words({ "bar","foo","the" });
	findSubstring(s, words);
}