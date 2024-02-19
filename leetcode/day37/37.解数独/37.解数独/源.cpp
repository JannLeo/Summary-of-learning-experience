#include <iostream>
#include <vector>
#include<unordered_map>
#include <bitset>
using namespace std;
//bool judgeSuDo(vector<vector<char>>& board,int x,int y,int num) {
//    for (int i = 0; i < 9; i++) {
//        if (board[x][i] == num+'0') return false;
//        if (board[i][y] == num+'0') return false;
//        // [0,4]  0 3
//        if (board[(x / 3) * 3 + i / 3][(y / 3) * 3 + i % 3] == num + '0') return false;
//    }
//    return true;
//}
//bool judgeSuDo(vector<bitset<9>>& temp,pair<int,int> point, int num) {
//    int x = point.first;
//    int y = point.second;
//    if (temp[x][num - 1]) return false;
//    if (temp[y + 9][num - 1]) return false;
//    if (temp[x / 3 * 3 + y/3 + 18][num - 1]) return false;
//    
//    return true;
//}
bool judgeSuDo(vector<bitset<9>>& temp, pair<int, int>& point, int num) {
    int x = point.first;
    int y = point.second;
    return !(temp[x][num] || temp[y + 9][num] || temp[x / 3 * 3 + y / 3 + 18][num]);
}

bool DFS(vector<vector<char>>& board,vector<bitset<9>>& temp,vector<pair<int,int>>& point,int pos) {
    auto length = point.size();
    for (int i = pos; i < length; i++) {
        int x = point[i].first;
        int y = point[i].second;
        int a = board[x][y] - '0';
        if (a > 0) continue;
        for (int j = 1; j <= 9; j++) {
            if (judgeSuDo(temp, point[i], j-1)) {
                board[x][y] = j + '0';
                temp[x][j - 1] = 1;
                temp[y + 9][j - 1] = 1;
                temp[x / 3 * 3 + y/3 + 18][j - 1] = 1;
                if (DFS(board, temp, point, pos + 1)) return true;
                temp[x][j - 1] = 0;
                temp[y + 9][j - 1] = 0;
                temp[x / 3 * 3 + y/3 + 18][j - 1] = 0;
                board[x][y] = '.';
            }
        }
        return false;
    }
    return true;
    /*for (int i = 0; i < 9; i++) {
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
    return true;*/
}
void solveSudoku(vector<vector<char>>& board) {
    vector<bitset<9>> temp(27);
    vector<pair<int, int>> point;
    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
            if (board[i][j] != '.') {
                int a = board[i][j] - '1';
                temp[i][a] = 1;
                temp[i / 3 * 3 + j / 3 + 18][a] = 1;
                temp[j + 9][a] = 1;
            }
            else {
                point.emplace_back(make_pair(i, j));
            }
            /*if (board[i][j] != '.') {
                int a = board[i][j] - '0';
                temp[i][a - 1] = 1;
                temp[i / 3 * 3 + j / 3 + 18][a - 1] = 1;
            }
            else {
                point.emplace_back(make_pair(i, j));
            }
            if (board[j][i] != '.') {
                int a = board[j][i] - '0';
                temp[i + 9][a - 1] = 1;
            }*/
        }
    }
    DFS(board,temp,point,0);
}
int main() {
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
    return 0;
}