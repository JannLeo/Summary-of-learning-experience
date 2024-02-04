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
	// ��¼words���ִ���
	unordered_map< string,int> a;
	for (string temps : words) {
		a[temps]++;
	}
	//����㻬������
	//��ʼ������㴰��
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
	//�ര���ƶ�
	for (int i = word_length; i + word_length * words_length <= str_length; i++) {
		int win_place = i % word_length;//�໬���������λ��
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