#include <iostream>
#include <vector>
#include <unordered_map>
using namespace std;
bool isValidSudoku(vector<vector<char>>& board) {
    vector<int> temp(27, 0);
    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
            if (board[i][j] !='.') {
                int a = 1<<(board[i][j] - '0');
                if (!(a & temp[i]) && !(a & temp[(i / 3) * 3 + j / 3 + 18])) {
                    temp[i] += a;
                    temp[(i / 3) * 3 + j / 3 + 18] += a;
                }
                else
                    return false;
            }
            if (board[j][i] != '.') {
                int a = 1 << (board[j][i] - '0');
                if (!(a & temp[i + 9])) {
                    temp[i + 9] += a;
                }
                else
                    return false;
            }
        }
    }
    return true;
}
//bool isValidSudoku(vector<vector<char>>& board) {
//    vector<unordered_map<char, int>> a(27);
//    for (int i = 0; i < 9; i++) {
//        for (int j = 0; j < 9; j++) {
//            //按行区别
//            if (board[i][j] != '.') {
//                if (!a[i][board[i][j]] && !a[(i / 3) * 3 + j / 3 + 18][board[i][j]]) {
//                    a[i][board[i][j]]++;
//                    a[(i / 3) * 3 + j / 3 +18][board[i][j]]++;
//                }
//                else 
//                    return false;
//            }
//            if (board[j][i] != '.') {
//                if (a[i + 9][board[j][i]] == 0) {
//                    a[i + 9][board[j][i]]++;
//                }
//                else return false;
//            }
//        }
//    } 
//    return true;
//}
void main() {
    // 1,3
    // 2,5
    // j/3+ (i/3)*3
    vector<vector<char>> board = {
    {'5', '3', '.', '3', '7', '.', '.', '.', '.'},
    {'6', '.', '.', '1', '9', '5', '.', '.', '.'},
    {'.', '9', '8', '.', '.', '.', '.', '6', '.'},
    {'8', '.', '.', '.', '6', '.', '.', '.', '3'},
    {'4', '.', '.', '8', '.', '3', '.', '.', '1'},
    {'7', '.', '.', '.', '2', '.', '.', '.', '6'},
    {'.', '6', '.', '.', '.', '.', '2', '8', '.'},
    {'.', '.', '.', '4', '1', '9', '.', '.', '5'},
    {'.', '.', '.', '.', '8', '.', '.', '8', '9'}
    };
    bool result =  isValidSudoku(board);
}