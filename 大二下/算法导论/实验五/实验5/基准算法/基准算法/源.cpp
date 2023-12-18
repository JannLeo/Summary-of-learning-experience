#include<iostream>
#include<ctime>
using namespace std;
const int SIZE = 1000000;
int h[SIZE],vtx[10*SIZE],nxt[10*SIZE];//  head�±�Ϊ��num  ��ֵΪ���±�    vtx�洢�ߵ�num   nxt�洢��һ����vtx�±�
int ltflag[SIZE],ltfl=0;//��ͨ����flag�Լ���ͨ����
int flag[10*SIZE];
int idx = 0;//  idxΪ���ڽڵ��ڼ�¼��λ�ã�
			//�߱�ڵ�Ĵ���
int flag_delete = 0;
int delete_ifflag = 0;

//�ӱ�
void addEdge(int a, int b) {
	nxt[idx] = h[a]; h[a] = idx;vtx[idx] = b;idx++;
}
void DFS(int a,int n) { //a=����   edge=���±�
	if (a == -1)
		return;
	ltflag[a] = 1;   //��ͨ���
	//int p = vtx[h[a]];//p=�ߵ�
	//int q = h[a];//q=���±�
	int p = h[a];//��һ�����±�
	while (p != -1) {
		if (ltflag[vtx[p]] == 0 && flag[p] != 1) {//�ñ�δ��������δ��ɾ��
			DFS(vtx[p],n);//DFS����ͬ����
			p = nxt[p];
		}
		//else if (flag[p] == 1) {
		//	/*
		//	�����Ѿ�ɾ���ı�,������Ҫɾ��������֮��ļ�¼   ����A-B��B-A
		//	���Ҷ���ɾ���ı���صĵ㣬������Ҫ�������е��ҵ�������ص���ͨ��  ���������ţ���������
		//	*/
		//	//�����ɾ��
		////�Ӳ���flag_delete
		//		//return;
		//	p = h[flag_delete];//p=Ӧɾ���ĵ��Ӧ�ĵ�һ����;
		//	while (p != -1) {//��p��Ӧ�ı߻���ʱ
		//		if (ltflag[nxt[h[flag_delete]]] != 0) {//Ѱ��p���ڽӵ����Ѿ�����ǵĵ�,���ɾ�����Ӧ�ıߵ���ͨ����������0ʱ
		//			DFS(nxt[h[flag_delete]], n);		 //ɾ����Ķ�Ӧ�߿�ʼ�ݹ�
		//			p = nxt[p];							//Ѱ��ɾ������һ���߶�Ӧ�±�
		//		}
		//		else {
		//			break;   //����Ӧ��δ����ǣ��������һ���߲鿴

		//		}
		//	}
		//}
		else {
			break;
		}

			
	}
}
int  liantong(int n) {//n=������Ŀ
	for (int i = 0;i < n;i++) {
		if (ltflag[i] == 0) {
			ltfl++;
			DFS(i,n);//��

		}
	}
	
	
	cout << "��" << ltfl << "����ͨ����" << endl;
	return ltfl;
}
void Bridge(int n,int m) {
	int b_num = 0;
	int lt1 = liantong(n);
	ltfl = 0;
	int p = -1;
	int k = 1;
	for (int i = 0;i < n;i++) {//i����������±�
		p = h[i];
		while (p != -1) {
			flag[p] = 1;
			flag_delete =p;//ɾ�����±�
			nxt[flag_delete] = -1;
			//Ӧ����ôɾ��
			//cout << "���ڱ�" << i << " " << vtx[p] << endl;
			memset(ltflag, 0, sizeof(ltflag));
			int new_liantong = liantong(n);
			if (lt1 != new_liantong) {
				cout << "��Ϊ" << i << " " << vtx[p] << endl;
			}
			memset(flag, 0, sizeof(flag));
			p = nxt[p];
			ltfl = 0;
		}
	}
}

int main() {
	cout << "���������Ŀ�����Ŀ:" << endl;
	int n, m,x,y;
	cin >> n >> m;
	memset(h, -1, sizeof(h));
	memset(ltflag, 0, sizeof(ltflag));
	memset(flag, 0, sizeof(flag));
	/*for (int i = 0;i < SIZE;i++) {
		h[i] = -1;
		ltflag[i] = 0;
	}
	for (int i = 0;i < 10 * SIZE;i++) {
		flag[i] = 0;
	}*/
	clock_t start, end;
	for (int i = 0;i < m;i++) {
		cout << "������ߣ�" << endl;
		cin >> x >> y;
		addEdge(x, y);
		addEdge(y, x);
	}
	start = clock();
	Bridge(n,m);
	end = clock();   //����ʱ��
	/*int p = -1;
	for (int i = 0;i < n;i++) {
		p = h[i];
		cout << i << ":";
		while (p != -1) {
			cout << " " << vtx[p];
			p = nxt[p];

		}
		cout << endl;
	}*/
	cout << "��׼�㷨����ʱ�䣺" << double(end - start) << "ms" << endl;



}
/*
5 4
0 1
0 2
1 2
3 4

3 4
*/