#include <iostream>
#include <vector>
#include <stack>
#include <unordered_map>
using namespace std;
void DFS(vector<string>& result,int deepth,int& max,string& temp_result,int right,int left) {
	if (deepth == 2 * max) {
		result.push_back(temp_result);
		return;
	}
	if (left < max) {
		temp_result += "(";
		DFS(result, deepth+1, max, temp_result, right, left + 1);
		temp_result.pop_back();
	}
	if (right < left) {
		temp_result += ")";
		DFS(result, deepth + 1, max, temp_result, right+1, left);
		temp_result.pop_back();
	}
}
//不能在回溯的时候带返回type类型
vector<string> generateParenthesis(int n) {
	vector<string> result;
	string origin = "(";
	DFS(result, 1, n,origin,0,1);
	return result;
}
//["((()))","(()())","(())()","()(())","()()()"]
void main() {
	int n = 3;
	vector<string> a = generateParenthesis(n);

}
