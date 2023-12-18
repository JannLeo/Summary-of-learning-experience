#include<iostream>
#include <ctime>
#include <float.h>
using namespace std;

const int X = 9;
const int M = 7;
const int N = 7;
const int K = 4;
int _max_score = 0;
int horizontal_purning_sum[15] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
int horizontal_purning_depth_num[15] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
const float parameter = 2.1;

void check_illegal(int chess_board[M][N])
{
    int illegal_flag = 0;
    int i, j;
    for (i = 0; i < M; i++)
    {
        for (j = 0; j < N - 2; j++)
        {
            if (chess_board[i][j] == chess_board[i][j + 1] && chess_board[i][j] == chess_board[i][j + 2])
            {
                chess_board[i][j] = rand() % K + 1;
                illegal_flag = 1;
            }
        }
    }
    for (i = 0; i < M - 2; i++)
    {
        for (j = 0; j < N; j++)
        {
            if ((chess_board[i][j] == chess_board[i + 1][j] && chess_board[i][j] == chess_board[i + 2][j]))
            {
                chess_board[i][j] = rand() % K + 1;
                illegal_flag = 1;
            }
        }
    }
    if (illegal_flag)
        check_illegal(chess_board);
}

void create_chessboard(int chess_board[M][N])
{
    int i, j;
    for (i = 0; i < M; i++)
    {
        for (j = 0; j < N; j++)
            chess_board[i][j] = rand() % K + 1;
    }
    // //-------------------------------------
    // cout << "random generated chessboard: " << endl;
    // for (i = 0; i < M; i++)
    // {
    //     for (j = 0; j < N; j++)
    //         cout << chess_board[i][j] << " ";
    //     cout << endl;
    // }
    // cout << endl;

    check_illegal(chess_board);
}



// 交换符合条件的点
int if_swap_point(int chessB[M][N], int x1,int y1,int x2,int y2)
{
    if(x1>=M || x1<0 || x2>=M || x2<0)
        return 0;
    if(y1>=N || y1<0 || y2>=N || y2<0)
        return 0;
    if (chessB[x1][y1] == chessB[x2][y2])
        return 0;
    if (chessB[x1][y1]==0 || chessB[x2][y2]==0)
        return 0;
    return 1;
}

void flag_point(int chessB[M][N],int flagB[M][N])
{
    int i, j;
    for (i = M - 1; i >= 0; --i){
        for (j = 0; j <= N - 1; ++j){
            if (flagB[i][j] == 1 || flagB[i][j] == 3)
                continue;
            if (chessB[i][j] != 0 && chessB[i][j] == chessB[i][j + 1] && j < N - 2 && chessB[i][j] == chessB[i][j + 2])
            {
                flagB[i][j] += 1;
                flagB[i][j+1] += 1;
                flagB[i][j+2] += 1;
                if (j < N - 3 && chessB[i][j + 3] == chessB[i][j])
                {
                    flagB[i][j + 3] += 1;
                    if (j < N - 4 && chessB[i][j + 4] == chessB[i][j])
                        flagB[i][j + 4] += 1;
                }
            }
        }
    }
    for (i = 0; i <= N - 1; ++i){
        for (j = M - 1; j >= 0; --j){
            if (flagB[j][i] == 2 || flagB[j][i] == 3)
                continue;
            if (chessB[j][i] != 0 && j >= 2 && chessB[j][i] == chessB[j - 1][i] && chessB[j][i] == chessB[j - 2][i])
            {
                flagB[j][i] += 2;
                flagB[j-1][i] += 2;
                flagB[j-2][i] += 2;
                if (j >= 3 && chessB[j - 3][i] == chessB[j][i])
                {
                    flagB[j - 3][i] += 2;
                    if (j >= 4 && chessB[j - 4][i] == chessB[j][i])
                        flagB[j - 4][i] += 2;
                }
            }
        }
    }
}

int get_score(int counts){
    if (counts<3)
        return 0;
    if(counts==3)
        return 1;
    if(counts==4)
        return 4;
    if(counts==5)
        return 10; 
}

void update_chessboard(int chessB[M][N])
{
    int i, j, k;
    for (i = 1; i < M; ++i)
    {
        for (j = 0; j < N; ++j)
        {
            if(chessB[i][j]==0)
            {
                k = i;
                while(k>0){
                    swap(chessB[k - 1][j], chessB[k][j]);
                    k--;
                }
            }
            
        }
    }

}

int delete_points_and_count_score(int chessB[M][N], int flagB[M][N])
{
    int i,j;
    int counts, score = 0;
    for (i = M - 1; i >= 0; --i){
        counts = 0;
        for(j = 0; j <= N - 1; ++j){
            if (flagB[i][j] == 1 || flagB[i][j] == 3){
                counts++;
                flagB[i][j] -= 1;
                chessB[i][j] = 0;
            }
        }
        score += get_score(counts);
    }
    for(i= 0; i <= N-1;++i){
        counts = 0;
        for (j = M - 1; j >= 0; --j){
            if (flagB[j][i] == 2 || flagB[j][i] == 3){
                counts++;
                flagB[j][i] -= 2;
                chessB[j][i] = 0;
            }
        }
        score += get_score(counts);
    }

    return score;
}

int check_flag_board_zero(int chessB[M][N]){
    for (int p = 0; p <= M - 1; ++p)
    {
        for (int q = 0; q <= N - 1; ++q)
        {
            if (chessB[p][q])
            {
                return 0;
            }
        }
    }
    return 1;
}

int check_max_score(int temp_board[M][N], int x1, int y1, int x2, int y2)
{
    if (!if_swap_point(temp_board, x1, y1, x2, y2))
        return 0;
    int score = 0;
    int flag_board[M][N] = {0};
    swap(temp_board[x2][y2], temp_board[x1][y1]);

    while (true)
    {
        for (int i = 0; i < M;++i){
            for (int j = 0; j < N;++j)
                flag_board[i][j] = 0;
        }
        
        flag_point(temp_board, flag_board);
        if (check_flag_board_zero(flag_board))
            break;

        score += delete_points_and_count_score(temp_board, flag_board);
        update_chessboard(temp_board);
    }
    if (score == 0)
        swap(temp_board[x2][y2], temp_board[x1][y1]);
    return score;
}

int swap_one_step(int chessB[M][N])
{
    int i, j;
    int max_score = 0;
    for(i = M - 1; i >= 0; --i){
        for(j= 0; j <= N - 1; ++j){
            int temp_board[M][N];
            memcpy(temp_board, chessB, sizeof(temp_board));
            int swap_up_point_score = check_max_score(temp_board, i, j, i - 1, j);
            int swap_right_point_score = check_max_score(temp_board, i, j, i, j + 1);
            if(max_score < swap_up_point_score)
                max_score = swap_up_point_score;

            if (max_score < swap_right_point_score)
                max_score = swap_right_point_score;
        }
    }
    cout << "最大得分为：  " << max_score<<endl;

    return max_score;
}

void update_max_score(int score){
    if(score>_max_score)
        _max_score = score;
}

void swap_x_step_backtrack(int chess_board[M][N], int depth, int max_score)
{
    int score = max_score;
    update_max_score(score);
    depth += 1;
    if(depth > X)
        return;
    int i, j;
    int temp_board[M][N];

    memcpy(temp_board, chess_board, sizeof(temp_board));
    for (i = M - 1; i >= 0; --i)
    {
        for (j = 0; j <= N - 1; ++j)
        {
            int swap_up_point_score = check_max_score(temp_board, i, j, i - 1, j);
            if (swap_up_point_score != 0){
                score = max_score;
                score += swap_up_point_score;
                swap_x_step_backtrack(temp_board, depth, score);
                memcpy(temp_board, chess_board, sizeof(temp_board));
            }

            score = max_score;
            int swap_right_point_score = check_max_score(temp_board, i, j, i, j + 1);
            if (swap_right_point_score != 0){
                score += swap_right_point_score;
                swap_x_step_backtrack(temp_board, depth, score);
                memcpy(temp_board, chess_board, sizeof(temp_board));
            }
        }
    }
    return;
}

void swap_x_step_backtrack_horizontal_pruning(int chess_board[M][N], int depth, int max_score)
{
    int score = max_score;
    update_max_score(score);
    depth += 1;
    if (depth > X)
        return;
    int i, j;
    int temp_board[M][N];
    float temp_score;
    float avg_score;

    memcpy(temp_board, chess_board, sizeof(temp_board));
    for (i = M - 1; i >= 0; --i)
    {
        for (j = 0; j <= N - 1; ++j)
        {
            int swap_up_point_score = check_max_score(temp_board, i, j, i - 1, j);
            if (swap_up_point_score != 0)
            {
                temp_score = float(swap_up_point_score) * parameter;
                avg_score = float(horizontal_purning_sum[depth]) / float(horizontal_purning_depth_num[depth]);
                if(temp_score>avg_score){
                    horizontal_purning_depth_num[depth] += 1;
                    horizontal_purning_sum[depth] += swap_up_point_score;
                    score = max_score;
                    score += swap_up_point_score;
                    swap_x_step_backtrack(temp_board, depth, score);
                    memcpy(temp_board, chess_board, sizeof(temp_board));
                }
            }

            score = max_score;
            int swap_right_point_score = check_max_score(temp_board, i, j, i, j + 1);
            if (swap_right_point_score != 0)
            {
                temp_score = float(swap_right_point_score) * parameter;
                avg_score = float(horizontal_purning_sum[depth]) / float(horizontal_purning_depth_num[depth]);
                if (temp_score > avg_score)
                {
                    horizontal_purning_depth_num[depth] += 1;
                    horizontal_purning_sum[depth] += swap_right_point_score;
                    score = max_score;
                    score += swap_right_point_score;
                    swap_x_step_backtrack(temp_board, depth, score);
                    memcpy(temp_board, chess_board, sizeof(temp_board));
                }
            }
        }
    }
    return;
}

int main(){
    // int chess_board[8][4] = {
    //     {3, 3, 4, 3},
    //     {3, 2, 3, 3},
    //     {2, 4, 3, 4},
    //     {1, 3, 4, 3},
    //     {3, 3, 1, 1},
    //     {3, 4, 3, 3},
    //     {1, 4, 4, 3},
    //     {1, 2, 3, 2}
    // };
    clock_t TimeInit[2], TimeFinal[2];
    int chess_board[M][N] = {0};
    create_chessboard(chess_board);
    check_illegal(chess_board);

    int i, j;
    //swap_one_step(chess_board);
    cout << "M:" << M << " N:" << N << " K:" << K << " X:" << X << endl;
    TimeInit[0] = clock();
    cout << "无剪枝回溯：" << endl;
    swap_x_step_backtrack(chess_board, 0, 0);
    cout << "最大分数： ";
    cout << _max_score << endl;
    TimeFinal[0] = clock();
    double time_1 = (double)(TimeFinal[0] - TimeInit[0]) / (double)CLOCKS_PER_SEC * 1000;
    cout << "无剪枝回溯耗时：" << time_1 <<"ms"<< endl;


    cout << "-------打印棋盘-------" << endl;
    for (i = 0; i < M; ++i)
    {
        for (j = 0; j < N; ++j)
            cout << chess_board[i][j] << " ";
        cout << endl;
    }

    _max_score = 0;
    TimeInit[1] = clock();
    cout << "横向剪枝回溯：" << endl;
    swap_x_step_backtrack_horizontal_pruning(chess_board, 0, 0);
    cout << "最大分数： ";
    cout << _max_score << endl;
    TimeFinal[1] = clock();
    double time_2 = (double)(TimeFinal[1] - TimeInit[1]) / (double)CLOCKS_PER_SEC * 1000;
    cout << "横向剪枝回溯耗时：" << time_2 <<"ms"<< endl;

    cin >> i;
    return 0;
}