#include <iostream>
#include <vector>
#include<unordered_map>
using namespace std;
bool judgeSuDo(vector<int> temp,int i,int j,int num) {
    int a = 1 << num;
    if (!(temp[i] & a) && !(temp[i + 9] & a) && !(temp[i / 3 * 3 + j / 3 + 18] & a)) {
        temp[i] += a;
        temp[i + 9] += a;
        temp[i / 3 * 3 + j / 3 + 18] += a;
        return true;
    }
    return false;
}
void DFS(vector<vector<char>>& board,int pos) {
    if (pos / 9 == 9)
        return;
    int xPos = pos / 9;
    int yPos = pos % 9;

}
void solveSudoku(vector<vector<char>>& board) {
    vector<int> temp(27, 0);
    vector<int> dot;
    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
            if (board[i][j] != '.') {
                int a = 1 << (board[i][j] - '0');
                if (!(temp[i] & a) && (!(temp[i / 3 * 3 + j / 3 + 18] & a))) {
                    temp[i] += a;
                    temp[i / 3 * 3 + j / 3 + 18] += a;
                }
            }
            else {
                dot.emplace_back(i * 9 + j + 1);
            }
            if (board[j][i] != '.') {
                int a = 1 << (board[j][i] - '0');
                if (!(temp[i + 9] & a)) {
                    temp[i + 9] += a;
                }
            }
        }
    }
    DFS(board, 0);

}
void main() {
	vector<vector<char>> board = {
        {'5', '3', '.', '.', '7', '.', '.', '.', '.'},
        {'6', '.', '.', '1', '9', '5', '.', '.', '.'},
        {'.', '9', '8', '.', '.', '.', '.', '6', '.'},
        {'8', '.', '.', '.', '6', '.', '.', '.', '3'},
        {'4', '.', '.', '8', '.', '3', '.', '.', '1'},
        {'7', '.', '.', '.', '2', '.', '.', '.', '6'},
        {'.', '6', '.', '.', '.', '.', '2', '8', '.'},
        {'.', '.', '.', '4', '1', '9', '.', '.', '5'},
        {'.', '.', '.', '.', '8', '.', '.', '7', '9'}
    };
	solveSudoku(board);
}