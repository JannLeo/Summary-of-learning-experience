#include<iostream>
#include<algorithm>
#include<cmath>
using namespace std;
#define MAXN 100	  //最多100个点
#define LINE 2        //两条线
int factory[LINE][MAXN][LINE];     //记录流水线上每个工作站的装配时间和转换至另一条流水线的开销
int cost[LINE][MAXN];                //记录开销动态规划时的最优子问题
int record[LINE][MAXN];     //记录选择的流水线
int result[MAXN];//记录暴力法选择赛道结果
int timee[1000000];
int add_num=0;//timee下标总数
void calculate(int *A,int n,int e1,int e2) {//计算总和
	timee[add_num] = 0;//初始化
	for (int i = 0;i < n;i++) {
		//考虑本来在这轨道  以及变换到该轨道 四种情况计算
		if (i == 0 && result[i] == 0) {
			timee[add_num] = e1;
			continue;
		}
		if (i == 0 && result[i] == 1) {
			timee[add_num] = e2;
			continue;
		}
		if((result[i]==0&&result[i-1]==0)){//如果没变轨道且在一轨道
			timee[add_num] += factory[0][i][0];
		}
		else if ((result[i] == 1&&result[i-1]==1)) {//如果没变轨道且在二轨道
			timee[add_num]+=factory[0][i][0];
		}
		else if ((result[i] == 0 && result[i - 1] == 1)) {//若果在一轨道而且变道
			timee[add_num] += factory[1][i][0] + factory[0][i - 1][1];
		}
		else if (result[i] == 1 && result[i - 1] == 0) {
			timee[add_num] += factory[0][i][0] + factory[1][i - 1][0];
		}
	}
}
void rank_all(int* A, int n,int num_zero,int e1,int e2)
{
	do {//其中列举了特定数目0的所有情况
		/*for (int i = 0;i < n;i++)cout << A[i] << " ";
		cout << endl;*/
		calculate(A, n,e1,e2);
		add_num++;
		
	} while (next_permutation(A, A + n));
	
}
int main() {
	int n, e1, e2;
	cin >> n;
	cin >> e1 >> e2;
	cout << "暴力法！" << endl;
	if (0 == n)
		return 0;
	for (int i = 0; i < LINE; i++) {

		cout << "输入流水线:" << i << "\n";//输入   本应为随机输入
		for (int j = 0; j < n; j++) {
			cin >> factory[i][j][0];          //当地开销
			cin >> factory[i][j][1];        //转换开销     i为第几号线路   j为几号工作位
		}
	}
	for (int i = 0; i < LINE; i++) {//输出
		for (int j = 0; j < n; j++)
			cout << "(本地花费时间:" << factory[i][j][0] << " 变道花费时间:" << factory[i][j][1] << ")\n";
		cout << "\n";
	}
	
	for (int i = 0;i <= n;i++) {//列举2的n次方种情况
		for (int j = 0;j < i;j++) {
			result[j] = 0;
		}
		for (int k = i ;k <= n;k++) {
			result[k] = 1;
		}
		rank_all(result, n,i,e1,e2);
	}
	for (int i = 0;i < add_num;i++) {
		cout << timee[i] << endl;
	}
	cout << add_num << "数目";
}
/*void rank_all(int* A, int n)
{
	do {
		for (int i = 0;i < n;i++)cout << A[i] << " ";
		cout << endl;
	} while (next_permutation(A, A + n));
}

int main() {
	int n = 6;
	int A[] = { 0,0,0,0,0,1 };
	rank_all(A, n);
	return 0;
}*/