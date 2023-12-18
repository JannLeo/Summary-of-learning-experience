#include<iostream>
#include<algorithm>
#include<cmath>
using namespace std;
#define MAXN 100	  //���100����
#define LINE 2        //������
int factory[LINE][MAXN][LINE];     //��¼��ˮ����ÿ������վ��װ��ʱ���ת������һ����ˮ�ߵĿ���
int cost[LINE][MAXN];                //��¼������̬�滮ʱ������������
int record[LINE][MAXN];     //��¼ѡ�����ˮ��
int result[MAXN];//��¼������ѡ���������
int timee[1000000];
int add_num=0;//timee�±�����
void calculate(int *A,int n,int e1,int e2) {//�����ܺ�
	timee[add_num] = 0;//��ʼ��
	for (int i = 0;i < n;i++) {
		//���Ǳ���������  �Լ��任���ù�� �����������
		if (i == 0 && result[i] == 0) {
			timee[add_num] = e1;
			continue;
		}
		if (i == 0 && result[i] == 1) {
			timee[add_num] = e2;
			continue;
		}
		if((result[i]==0&&result[i-1]==0)){//���û��������һ���
			timee[add_num] += factory[0][i][0];
		}
		else if ((result[i] == 1&&result[i-1]==1)) {//���û�������ڶ����
			timee[add_num]+=factory[0][i][0];
		}
		else if ((result[i] == 0 && result[i - 1] == 1)) {//������һ������ұ��
			timee[add_num] += factory[1][i][0] + factory[0][i - 1][1];
		}
		else if (result[i] == 1 && result[i - 1] == 0) {
			timee[add_num] += factory[0][i][0] + factory[1][i - 1][0];
		}
	}
}
void rank_all(int* A, int n,int num_zero,int e1,int e2)
{
	do {//�����о����ض���Ŀ0���������
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
	cout << "��������" << endl;
	if (0 == n)
		return 0;
	for (int i = 0; i < LINE; i++) {

		cout << "������ˮ��:" << i << "\n";//����   ��ӦΪ�������
		for (int j = 0; j < n; j++) {
			cin >> factory[i][j][0];          //���ؿ���
			cin >> factory[i][j][1];        //ת������     iΪ�ڼ�����·   jΪ���Ź���λ
		}
	}
	for (int i = 0; i < LINE; i++) {//���
		for (int j = 0; j < n; j++)
			cout << "(���ػ���ʱ��:" << factory[i][j][0] << " �������ʱ��:" << factory[i][j][1] << ")\n";
		cout << "\n";
	}
	
	for (int i = 0;i <= n;i++) {//�о�2��n�η������
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
	cout << add_num << "��Ŀ";
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