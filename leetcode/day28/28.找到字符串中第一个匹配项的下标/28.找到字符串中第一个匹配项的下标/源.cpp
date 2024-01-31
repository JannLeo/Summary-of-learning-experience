#include <iostream>
#include <vector>
using namespace std;
vector<int> findnext(string needle) {
	int length = needle.length();
	vector<int> next(length, 0);
	if (length <= 3) {
		return next;
	}
	int i = 1, j = 0;
	while (i < length-1) {
		if (needle[i] == needle[j]) {
			next[++i] = ++j;
		}
		else if (j == 0) {
			i++;
		}
		else {
			j = next[j];
		}
	}
	return next;
}
int strStr(string haystack, string needle) {
	int length = haystack.size();
	int length2 = needle.size();
	if (length2 > length)
		return -1;
	int j = 0, i = 0;
	vector<int> next = findnext(needle);
	while (i < length && j < length2) {
		if (haystack[i] == needle[j]) {
			i++;
			j++;
		}
		else if (j == 0) {
			i++;
		}
		else {
			j = next[j];
		}
	}
	if (j == length2) {
		return i - j;
	}
	else return -1;
}
void main() {
	string haystack = "aabaaabaaac";
	string needle = "aabaaac";
	int result=strStr(haystack,needle);
}