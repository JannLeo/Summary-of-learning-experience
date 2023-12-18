#include<iostream>
#include<vector>
#include<Windows.h>
using namespace std;
#define INT_MIN 0x80000000;
/*struct node {//��������ṹ��
	int x; //�ڵ�ı��
	node* next;
	node(int x_) {
		this->x = x_;
		next = nullptr;
	}

};*/
int color_except[451][451];//������ɫ�ų�����
int color_flag1[451];//����ɫ��ǣ���Ϳɫ��Ϊ1��
void add_edge(int n, int m, int* edge_max,int neiber2,int neiber1) {//�ڽӵ㸳ֵΪ1 ���ӱ��� ���Ӷ���
	/*node* a = head[n][0];//�ҵ���n����ͷ
	node* b = new node(m);//�������ڽӵ�
	node* c = new node(n);
	node* d = head[m][0];
	b->next = a->next;
	a->next = b;
	c->next = d->next;
	d->next = c;//ͷ�巨����*/
	neiber1 = 1;
	neiber2 = 1;
	edge_max[n]++;
	edge_max[m]++;
}
bool ok(int point_num,int p_num,int **neiber,int *result) {//�ж���ɫ�Ƿ����
	for (int i = 1;i <= point_num;i++) {
		//�ж����ڵ�λ�Ƿ�����ͬ��ɫ
			if (neiber[p_num][i] && result[i] == result[p_num])//��������ɫ���
			{
				color_except[p_num][result[i]] = 1;//�õ���ɫ�ų�
				return false;//����false �ݹ�
			}

		
	}
	return true;
}
int findcolor(int** neiber, int* result, int p_num, int point_num, int color_num) {
	//���һ����ü�����ɫ
	int* color_flag = new int[color_num + 1];//��ɫ�Ǽ�
	for (int i = 0;i <= color_num;i++)//��ʼ����ɫ�Ǽ�
		color_flag[i] = 0;
	for (int i = 1;i <= point_num;i++) {//�ж����ڵ��Ƿ���color_num����ͬ��ɫ
		if (neiber[p_num][i]) {//���ڵ��ж�
			if (result[i] <= color_num && result[i] > 0)//�����ڵ���Ϳɫ ����
				color_flag[result[i]] = result[i];
		}
	}
	int fflag = 0;//�����ɫ������
	for (int i = 1;i <= color_num;i++) {
		if (color_flag[i] == 0) {//��ĳ��ɫû���  ��fflag��һ
			fflag = 1 + fflag;
			

		}
	}
	return fflag;

}
void okcolor(int** neiber, int* result, int p_num, int point_num, int color_num) {
	//�ж��Ƿ�����ɫ   δ�����ڽӵ���ɫ��������˵�ʱ�����ǲ�ͬ��ɫ������ڽӵ�ʱ���й�ͬ�ڽӵ�  ��������ɫ
	int* color_flag = new int[color_num+1];//��ɫ�Ǽ�
	for (int i = 0;i <= color_num;i++)//��ʼ����ɫ�Ǽ�
		color_flag[i] = 0;
	for (int i = 1;i <= point_num;i++) {//�ж����ڵ��Ƿ���color_num����ͬ��ɫ
		if (neiber[p_num][i]) {
			if (result[i] <= color_num && result[i] > 0)//�����ڵ���Ϳɫ ����
				color_flag[result[i]] = result[i];
		}
	}
	int fflag = 0;//�����ɫ������
	for (int i = 1;i <= color_num;i++) {
		if (color_flag[i] == 0) {//��ĳ��ɫû���  ��fflag��һ
			fflag = 1 + fflag;
			if (color_except[p_num][i] != 1) {//���õ�Ը���ɫ���ų�
				result[p_num] = i;//������ɫΪ����ɫ
				break;
			}

		}
		else
			color_except[p_num][i] = 1;//���ڽӵ��и���ɫ  ����ȥ����ɫ
	}
	
	if (fflag == 0||fflag==color_num)//������ɫ��ѡ  �򷵻�0
		result[p_num] = 0;
	

}
int find_point_maxedge(int* result, int* edge_max, int* color_rest, int color_num, int point_num,int **neiber, int* record_pnum)
{//�ҵ�����Ҫ��ĵ�
	int degree = INT_MIN;
	int k = 1;
	int* maxedge_point = new int[point_num + 1];
	for (int i = 1;i <= point_num;i++) {//�ҵ�������Ӧ�ĵ�
		maxedge_point[i] = 0;//������ȵĵ��ų�ʼ��
		if (result[i] != 0||color_flag1[i]==1)//����Ѿ�����ɫ  ���߼�¼��������ɫ ������
			continue;
		if (degree < edge_max[i]) {//���������  ��ֵ��degree
			degree = edge_max[i];
		}
	}
	for (int i = 1;i <= point_num;i++) {//��¼���ȶ�Ӧ��ļ���
		if (degree == edge_max[i]&&!color_flag1[i]) {//��degree����
			maxedge_point[k] = i;//��¼��ͬ������Ŀ����±�
			k++;//���鳤������һ
		}
	}
	int flag_mincolor = color_num + 1, flag_minnum = 0;
	for (int i = 1;i < k;i++) {//ѡ�����ٿ�ѡ��ɫ�ĵ�
		if (color_rest[maxedge_point[i]] < flag_mincolor) {//���ʣ����ɫС����һ�ȵ���ɫ
			flag_mincolor = color_rest[maxedge_point[i]];//��ֵĿ��������ɫ��
			flag_minnum = maxedge_point[i];//����ֵΪĿ�����
		}
	}
	delete[]maxedge_point;
	if (flag_minnum == 0) {
		cout << "error!" << endl;
		return flag_minnum;
	}
	else
		return flag_minnum;
}
//                  ��¼Ϳɫ��        ����Ŀ       ������ɫ��      ����ʣ����ɫ��     �������    �ڽӵ����   ��ǰͿɫ������   Ϳɫ���   ��ǰͿɫ��                          
void traceback(int *record_pnum,int point_num, int color_num, int* color_rest, int* edge_max, int **neiber, int flag, int* result,int p_num,int k) {
	if (flag > point_num) {//�����������
		cout << "���Գɹ������Ϊ��"<<endl;
		for (int i = 1;i <= point_num;i++) {
			cout <<  result[i] << " ";
			if (i % 10 == 0)
				cout << endl;
		}
		cout << endl;
		return;
	}
	
	p_num= find_point_maxedge(result, edge_max, color_rest, color_num, point_num, neiber,record_pnum);//�ҵ���Ӧ��
	
	if(p_num==0){
		//���Ҳ���Ŀ���
		cout << k << endl;
		record_pnum[k] = 0;//�ϸ���¼������
		//color_flag1[p_num] = 1;//����Ϳɫ
		k--;//Ŀ���ѡ���¼��1
		//result[p_num] = 0;//��ɫ���0
		p_num = record_pnum[k];//Ŀ�������
		for (int i = 1;i <= point_num;i++) {//Ŀ����ڽӵ������һ
			if (neiber[p_num][i])
				edge_max[i]++;
			int neiber_point=findcolor(neiber, result,i, point_num, color_num);//��һ��¼����ڽӵ���ڽӵ���ɫ����
			if (neiber_point < color_num-1) {//����һ��¼����ڽӵ���ڽӵ�����
				color_except[i][result[i]] = 1;
				okcolor(neiber, result, i, point_num, color_num);
			}
		}
		
		//�ݹ�
	
		traceback(record_pnum, point_num, color_num, color_rest, edge_max, neiber, flag, result, p_num,k);
	}
	
	
	if (!result[p_num]) {//��������ɫΪ0
		result[p_num]++;//��ɫ�Ӽ�
	}
	for (int i = 1;i < color_num;i++) {//�����ɫ��ͻ
		if (!ok(point_num, p_num, neiber, result)) {//����ֵ��ɫ��ͻ
			result[p_num]++;
		}
		else
			break;
	}
	if (!ok(point_num, p_num, neiber, result)) {//��ʵ��û��ɫ��ѡ
		k--;//Ŀ���ѡ���¼��1
		color_flag1[p_num] = 0;//Ϳɫ���0;
		result[p_num] = 0;//��ɫ���0
		p_num = record_pnum[k];//Ŀ�������
		for (int i = 1;i <= point_num;i++) {//Ŀ����ڽӵ������һ
			if (neiber[p_num][i] ) {//����
				edge_max[i]++;//�ȼ�һ
				color_rest[i]++;//��ɫ��һ
				color_except[i][result[p_num]] = 0;//�ڽӵ���ѡ��ɫ�ָ�
			}
		}
		flag--;//���¼��һ
		traceback(record_pnum, point_num, color_num, color_rest, edge_max, neiber, flag, result, p_num, k);
	}
	for (int i = 1;i <= point_num;i++) {//���ڶ�����һ  ���ڿ�ѡ��ɫ��һ
		if (neiber[p_num][i] ) {//����
			edge_max[i]++;//�ȼ�һ
			//color_rest[i]--;//ʣ����ɫ��һ
			color_except[i][result[p_num]] = 1;//�ڽӵ��ѡɫϵ��һ

		}
	}
	color_flag1[p_num] = 1;//����Ϳɫ
	//�����flag++;
	okcolor(neiber, result, p_num, point_num, color_num);//�ҵ��ڽӵ������ɫ������ֵ��ɫ
	flag++;
	//���ҵ�Ŀ��� ��
	record_pnum[k] = p_num;
	//okcolor(neiber, result, p_num, point_num, color_num);//�ҵ��ڽӵ������ɫ������ֵ��ɫ

	k++;//��¼����������
	traceback(record_pnum, point_num, color_num, color_rest, edge_max, neiber, flag, result, p_num,k);
}

//vector<node*>head;//���ñ�ͷ      ��ʹ���ݸ�����
int main() {
	cout << "��������ɫ���ࣺ";
	int color_num;
	cin >> color_num;
	cout << "������������";
	int point_num;
	cin >> point_num;
	cout << "������߸�����";
	int edge_num;
	cin >> edge_num;
	cout << "����������ڽӵ���:";
	int** neiber = NULL;
	neiber = new int* [point_num+1];
	for (int i = 0;i < point_num + 1;i++) {
		neiber[i] = new int[point_num + 1];
	}
	for (int i = 0;i <= point_num;i++) {
		for (int j = 0;j <= point_num;j++) {
			neiber[i][j] = 0;
			color_except[i][j] = 0;
		}
	}
	//head.resize(point_num + 1);//��ͷ��С����
	int* edge_max = new int[point_num + 1];//��¼��������� ����MRV

	for (int i = 0;i <= point_num;i++) {
		edge_max[i] = 0;
		color_flag1[i] = 0;
	}
	//for (int i = 1;i <= point_num;i++) head[i] = new node(i);
	for (int i = 1;i<=edge_num;i++) {//��¼�ڽӱ�
		int n = 0, m = 0;
		cin >> n >> m;
		//add_edge(n, m, edge_max,neiber[n][m],neiber[m][n]);//�����ڽӱ�ڵ�    ����������ڽӱ�����һ
		neiber[m][n] = 1;
		neiber[n][m] = 1;
		edge_max[n]++;
		edge_max[m]++;
	}
	int* color_rest = new int[point_num + 1];
		color_rest[0] = 0;
	for (int i = 1;i <= point_num;i++) //��¼������ɫʣ��  ��Ϳɫ��Ϊ0��
		color_rest[i] = color_num;
	int* record_pnum = new int[point_num + 1];//��¼��ɫ��ʷ
	for (int i = 0;i <= point_num;i++) {
		record_pnum[i] = 0;
	}
	int flag = 1;
	int p_num = 0;
	int* result = new int[point_num + 1];
	for (int i = 0;i <= point_num;i++)
		result[i] = 0;
	int k = 1;
	DWORD start_time = GetTickCount();
	traceback(record_pnum, point_num, color_num, color_rest, edge_max, neiber, flag, result, p_num,k);
	DWORD end_time = GetTickCount();
	cout << "��������ʱ��Ϊ��" << end_time - start_time <<"ms"<< endl;
	/*
	vector<vector<int>>pt(point_num + 1, vector<int>(point_num + 1));//����point_num+1��vector�ڽӱ�



	for(int i=1;i<=point_num;i++){//��¼�ڽӱ�
		int n = 0, m = 0;
		cin >> n >> m;
		pt[n].push_back(m);
		pt[m].push_back(n);
	}

	*/
}
