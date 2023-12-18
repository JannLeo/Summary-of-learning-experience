#include<iostream>
#include<stdio.h>
#include<cmath>
#include<ctime>
using namespace std;
const int SIZE = 1000000;   //�㼯��Ŀ
int head[SIZE], ver[SIZE * 10], Next[SIZE * 10]; 
int subtree[SIZE],n,m,tot,num;  //
int dfn[SIZE]; // ��ʾʱ���  ��һ�α����ʵ�ʱ��˳��    ��Χ1-1000000
int low[SIZE];//׷��ֵ  ���½ڵ�ʱ�������Сֵ   
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
//��ѡһ���ڵ�������ȱ��� 
//����һ����
//����������ɭ��
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
	cout << "����������������:" << endl;
	cin >> n >> m;//nΪ������  mΪ����
	tot = 1;
	cout << "������" << m << "�������:" << endl;
	/*memset(Next, -1, sizeof(Next));
	memset(head, -1, sizeof(head));
	memset(ver, -1, sizeof(ver));*/
	clock_t start, end;
	
	for (int i = 1;i <= m;i++) {
		int x, y;
		cout << "����������:" << endl;
		cin >> x >> y;
		add(x, y), add(y, x);  //��ӱ�
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
			cout << ver[i^1]<<" "<<ver[i] << "����" << endl;
			k++;
		}
	}
	end = clock();   //����ʱ��
	cout << "�㼯��ĿΪ��" << n << endl;
	cout << "���Ѽ�����" << k << "����" << endl;
	cout << "���鼯������ʱ�䣺" << double(end - start) << "ms" << endl;
	
	return 0;
}