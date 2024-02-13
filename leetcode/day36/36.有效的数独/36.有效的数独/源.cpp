#include <iostream>
#include <vector>
#include <unordered_map>
using namespace std;
bool isValidSudoku(vector<vector<char>>& board) {
    vector<unordered_map<char, int>> a(27);
    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
            //按行区别
            if (board[i][j] != '.') {
                if (!a[i][board[i][j]] && !a[(i / 3) * 3 + j / 3 + 18][board[i][j]]) {
                    a[i][board[i][j]]++;
                    a[(i / 3) * 3 + j / 3 +18][board[i][j]]++;

                }
                else 
                    return false;
            }
            if (board[j][i] != '.') {
                if (a[i + 9][board[j][i]] == 0) {
                    a[i + 9][board[j][i]]++;
                }
                else return false;
            }
        }
    }
    
    return true;
}
void main() {
    vector<vector<char>> board = {
    {'.','.','.','.','5','.','.','1','.'},
    {'.','4','.','3','.','.','.','.','.'},
    {'.','.','.','.','.','3','.','.','1'},
    {'8','.','.','.','.','.','.','2','.'},
    {'.','.','2','.','7','.','.','.','.'},
    {'.','1','5','.','.','.','.','.','.'},
    {'.','.','.','.','.','2','.','.','.'},
    {'.','2','.','9','.','.','.','.','.'},
    {'.','.','4','.','.','.','.','.','.'}
    };
    bool result =  isValidSudoku(board);
}