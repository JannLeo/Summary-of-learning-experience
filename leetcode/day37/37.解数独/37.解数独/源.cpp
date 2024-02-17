#include <iostream>
#include <vector>
#include<unordered_map>
using namespace std;
bool judgeSuDo(vector<vector<char>>& board,int x,int y,int num) {
    for (int i = 0; i < 9; i++) {
        if (board[x][i] == num+'0') return false;
        if (board[i][y] == num+'0') return false;
        // [0,4]  0 3
        if (board[(x / 3) * 3 + i / 3][(y / 3) * 3 + i % 3] == num + '0') return false;
    }
    return true;
}
bool DFS(vector<vector<char>>& board) {
    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
            if (board[i][j] != '.') continue;
            for (int k = 1; k <= 9; k++) {
                if (judgeSuDo(board, i, j, k)) {
                    board[i][j] = k + '0';
                    if (DFS(board)) return true;
                }
            }
            board[i][j] = '.';
            return false;
        }
    }
    return true;
}
void solveSudoku(vector<vector<char>>& board) {

    DFS(board);
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
    cout << "end" << endl;
}