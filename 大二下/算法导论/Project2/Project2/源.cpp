#include"iostream"
using namespace std;
bool Judge(int k, int** neiber, int* color_result) {   //判断是否冲突
    for (int i = 0;i < k;i++) {
        if (neiber[k][i] && color_result[i] == color_result[k])
            return false;
    }
    return true;
}
void traceback(int pointnum, int** neiber, int colornum, int* color_result) {
    int flag = 0;
    while (flag >= 0) {
        color_result[flag]++;
        while (color_result[flag] <= colornum) {
            if (Judge(flag, neiber, color_result))
                break;
            else
                color_result[flag]++;
        }
        if (color_result[flag] == colornum && flag <= pointnum) {
            for (int i = 0;i < pointnum;i++)
                cout << color_result[i] << " ";
            cout << endl;
            return;
        }
        else
        {
            if (color_result[flag] <= pointnum && flag < pointnum)
                flag++;
            else {
                color_result[flag] = 0;
                flag--;
            }

        }
    }
}
int main() {
    cout << "请输入颜色种类：";
    int colornum;
    cin >> colornum;
    int* color = new int[colornum]; //颜色种类
    for (int i = 0;i <= colornum;i++) {
        color[i] = i;
    }
    cout << "请输入点的数目：";
    int pointnum;
    cin >> pointnum;
    int** neiber = NULL;
    neiber = new int* [pointnum];
    for (int i = 0;i < pointnum + 1;i++) {
        neiber[i] = new int[pointnum + 1];
    }
    for (int i = 0;i < pointnum;i++)
        for (int j = 0;j <= pointnum;j++)
            neiber[i][j] = 0;
    cout << "请输入邻接点：";
    int p = 1, pn, pc = 0, flag;
    flag = p;
    while (1) {
        cin >> p >> pn;
        if (p == 1000 && pn == 1000)
            break;
        neiber[p - 1][pn + 1] = 1;
        pc++;
        if (flag != p) {
            flag = p;
            neiber[p - 2][0] = pc;
            pc = 0;
        }


    }
    int* color_result = new int[pointnum];
    for (int i = 0;i < pointnum;i++) {
        color_result[i] = 0;
    }
    traceback(pointnum, neiber, colornum, color_result);

}
