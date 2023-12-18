#include<iostream>
#include<stdio.h>
#include<cmath>
#include<ctime>
using namespace std;
const int SIZE = 1000000;   //点集数目
int head[SIZE], ver[SIZE * 10], Next[SIZE * 10]; 
int subtree[SIZE],n,m,tot,num;  //
int dfn[SIZE]; // 表示时间戳  第一次被访问的时间顺序    范围1-1000000
int low[SIZE];//追溯值  以下节点时间戳的最小值   
bool bridge[SIZE * 2];
int bcj1[SIZE];

void set_bcj() {
	for (int i = 1;i <= tot;i++) {
		int p = head[i];
		if (p == -1) {
			bcj1[i] = i;
		}
		else {
			while (p != -1) {
				p = Next[p];

			}
			bcj1[i] = ver[p];
		}
	}
}
void add(int x, int y) {
	//create points picture
	ver[++tot] = y, Next[tot] = head[x], head[x] = tot;
}
//任选一个节点深度优先遍历 
//构成一棵树
//所有树构成森林
void bcj(int x,int in_edge) {
	dfn[x] = low[x] = ++num;
	for (int i = head[x];i;i = Next[i]) {
		int y = ver[i];
		if (!dfn[y]) {
			bcj(y,i);
			low[x] = min(low[x], low[y]);
			if (low[y] > dfn[x]) {
				bridge[i]=bridge[i^1]= true;
			}
		}
		else if(i!=(in_edge^1))
			low[x] = min(low[x], dfn[y]);
	}
}

int main() {
	cout << "请输入点数量与边数:" << endl;
	cin >> n >> m;//n为点数量  m为边数
	tot = 1;
	cout << "请输入" << m << "个点与边:" << endl;
	/*memset(Next, -1, sizeof(Next));
	memset(head, -1, sizeof(head));
	memset(ver, -1, sizeof(ver));*/
	clock_t start, end;
	
	for (int i = 1;i <= m;i++) {
		int x, y;
		cout << "请输入点与边:" << endl;
		cin >> x >> y;
		add(x, y), add(y, x);  //添加边
	}
	start = clock();
	//set_bcj();
	for (int i = 1;i <= n;i++) {
		if (dfn[i] == 0) { 
			bcj(i,0); 
		}
	}
	int k = 0;
	for (int i = 2;i < tot;i += 2) {
		if (bridge[i]) {
			cout << ver[i^1]<<" "<<ver[i] << "是桥" << endl;
			k++;
		}
	}
	end = clock();   //结束时间
	cout << "点集数目为：" << n << endl;
	cout << "共搜集到：" << k << "个桥" << endl;
	cout << "并查集法所花时间：" << double(end - start) << "ms" << endl;
	
	return 0;
}