#include <iostream>
#include<algorithm>
#include<cmath>
#include<ctime>
using namespace std;

#define MAXN 10000000
#define LINE 2  

int factory[LINE][MAXN][LINE];     //记录流水线上每个工作站的装配时间和转换至另一条流水线的开销
int cost[LINE][MAXN];                //记录开销动态规划时的最优子问题
int record[LINE][MAXN];     //记录选择的流水线
int result[MAXN];//记录暴力法选择赛道结果
int timee[100000000];
int add_num = 0;//timee下标总数
void calculate(int* A, int n, int e1, int e2) {//计算总和
    timee[add_num] = 0;//初始化
   /* for (int i = 0;i < n;i++)
        cout << A[i] << " ";*/
    //cout << endl;
    for (int i = 0;i < n;i++) {
        //考虑本来在这轨道  以及变换到该轨道 四种情况计算
        if (i == 0 && result[i] == 0) {
            timee[add_num] = e1+factory[0][0][0];
            //cout << timee[add_num] << " ";
            continue;
        }
        if (i == 0 && result[i] == 1) {
            timee[add_num] = e2+factory[1][0][0];
            //cout << timee[add_num] << " ";
            continue;
        }
        if ((result[i] == 0 && result[i - 1] == 0)) {//如果没变轨道且在一轨道
            timee[add_num] += factory[0][i][0];
        }
        else if ((result[i] == 1 && result[i - 1] == 1)) {//如果没变轨道且在二轨道
            timee[add_num] += factory[1][i][0];
        }
        else if ((result[i] == 0 && result[i - 1] == 1)) {//若果在一轨道而且变道
            timee[add_num] += factory[0][i][0] + factory[1][i - 1][1];
        }
        else if (result[i] == 1 && result[i - 1] == 0) {
            timee[add_num] += factory[1][i][0] + factory[0][i - 1][1];
        }
        //cout << timee[add_num] << " ";
    }
    //cout << timee[add_num]<<" "<<add_num << endl;
}
void rank_all(int* A, int n, int num_zero, int e1, int e2,int **stolee)
{
    
    do {
        for(int i=0;i<n;i++)
        stolee[add_num][i] = A[i];
        calculate(A, n, e1, e2);
        add_num++;
        
        
    } while (next_permutation(A, A + n));

}
int main()
{
    clock_t startTime, endTime,startTime1,endTime1;
    srand((int)time(0));
    int n, e1, e2;
    n= 25;
    e1 = rand() % 100;
    e2 = rand() % 100;
    //cin >> e1 >> e2;
    cout << "点数为" << n<<endl;
    cout << "初始线路0:" << e1<<endl;
    cout << "初始线路1:" << e2<<endl;
    
    if (0 == n)
        return 0;
    for (int i = 0; i < LINE; i++) {
        for (int j = 0; j < n; j++) {
           factory[i][j][0]= rand() % 100;          //当地开销
           factory[i][j][1]= rand() % 100;        //转换开销     i为第几号线路   j为几号工作位
            //cin >> factory[i][j][0] >> factory[i][j][1];
        }
    }
    for (int i = 0; i < LINE; i++) {//输出
        cout << "对于线路 " << i << endl;
        for (int j = 0; j < n; j++)
            cout << "(本地花费时间:" << factory[i][j][0] << " 变道花费时间:" << factory[i][j][1] << ")\n";
        cout << "\n";
    }
    //暴力法！
    cout << "暴力法：" << endl;

    
    startTime = clock();//计时开始
    int **stolee = new int*[pow(2,n)];//存储所有结果的路线
    for (int i = 0;i <pow(2,n);i++)
        stolee[i] = new int[n];
    for(int i=0;i<n;i++)
    for (int l = 0;l < n;l++) {
            stolee[i][l] = 3;
        }
    for (int i = 0;i <= n;i++) {//列举2的n次方种情况
        for (int j = 0;j < i;j++) {
            result[j] = 0;
        }
        
        for (int k = i;k <= n;k++) {
            result[k] = 1;
        }
        rank_all(result, n, i, e1, e2,stolee);
    }
    int mintimee = INT_MAX;
    int recorrrd = 0;
    for (int i = 0;i < add_num;i++) {
        if (timee[i] < mintimee) {
            mintimee = timee[i];
            recorrrd = i;
        }
    }
    cout << recorrrd << endl;
    for (int i = 0;i < n;i++) {
        cout <<"当前点为："<<i <<" "<<"暴力法所选线路：" << stolee[recorrrd][i]<<endl;
    }
    endTime = clock();//计时结束
    cout << "暴力法最短工序时间为：" << mintimee << endl;
    cout << "暴力法运行时间: " << (double)(endTime - startTime) / CLOCKS_PER_SEC << "s" << endl;
    cout << "暴力法结束" << endl;
    cout << endl;
    cout << "动态规划法：" << endl;
    startTime1 = clock();//计时开始
    cost[0][0] = factory[0][0][0] + e1;
    cost[1][0] = factory[1][0][0] + e2;
    record[0][0] = 0;//记录选择的流水线
    record[1][0] = 1;

    for (int i = 1; i < n; i++) {
        if (cost[0][i - 1] <= cost[1][i - 1] + factory[1][i - 1][1]) {//若线路一的时间比转换到线路二时间少
            cost[0][i] = cost[0][i - 1] + factory[0][i][0];//在线路一不动
            record[0][i] = 0;
        }
        else {
            cost[0][i] = cost[1][i - 1] + factory[0][i][0] + factory[1][i - 1][1];//转换到线路1
            record[0][i] = 1;
        }

        if (cost[1][i - 1] <= cost[0][i - 1] + factory[0][i - 1][1]) {//若线路2时间比线路1时间少
            cost[1][i] = cost[1][i - 1] + factory[1][i][0];//在线路2不动
            record[1][i] = 1;
        }
        else {
            cost[1][i] = cost[0][i - 1] + factory[1][i][0] + factory[0][i - 1][1];//转换到线路2
            record[1][i] = 0;
        }
    }
    int line = (cost[0][n - 1]  <= cost[1][n - 1] ) ?0 : 1;//显示最优线路 
    endTime1 = clock();//计时结束
    for (int i = n-1; i >=0; i--) {
        cout << "所选点：" << i << " "<<"所在流水线：" << line << "\n";
        line = record[line][i];
        
    }

    int mint;
        if (cost[1][n - 1] > cost[0][n - 1]) {
        mint = cost[0][n - 1];

    }
    else {
        mint = cost[1][n - 1];

    }
    endTime1 = clock();//计时结束
    cout << "动态规划法最短工序时间："<<mint<< endl;
    
    cout << "动态规划运行时间: " << ((double)(endTime1 - startTime1) / CLOCKS_PER_SEC)*1000 << "ms" << endl;
    cout << "动态规划结束" << endl;
    return 0;
}