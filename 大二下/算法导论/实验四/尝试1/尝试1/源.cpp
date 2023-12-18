#include <iostream>
#include<algorithm>
#include<cmath>
#include<ctime>
using namespace std;

#define MAXN 10000000
#define LINE 2  

int factory[LINE][MAXN][LINE];     //��¼��ˮ����ÿ������վ��װ��ʱ���ת������һ����ˮ�ߵĿ���
int cost[LINE][MAXN];                //��¼������̬�滮ʱ������������
int record[LINE][MAXN];     //��¼ѡ�����ˮ��
int result[MAXN];//��¼������ѡ���������
int timee[100000000];
int add_num = 0;//timee�±�����
void calculate(int* A, int n, int e1, int e2) {//�����ܺ�
    timee[add_num] = 0;//��ʼ��
   /* for (int i = 0;i < n;i++)
        cout << A[i] << " ";*/
    //cout << endl;
    for (int i = 0;i < n;i++) {
        //���Ǳ���������  �Լ��任���ù�� �����������
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
        if ((result[i] == 0 && result[i - 1] == 0)) {//���û��������һ���
            timee[add_num] += factory[0][i][0];
        }
        else if ((result[i] == 1 && result[i - 1] == 1)) {//���û�������ڶ����
            timee[add_num] += factory[1][i][0];
        }
        else if ((result[i] == 0 && result[i - 1] == 1)) {//������һ������ұ��
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
    cout << "����Ϊ" << n<<endl;
    cout << "��ʼ��·0:" << e1<<endl;
    cout << "��ʼ��·1:" << e2<<endl;
    
    if (0 == n)
        return 0;
    for (int i = 0; i < LINE; i++) {
        for (int j = 0; j < n; j++) {
           factory[i][j][0]= rand() % 100;          //���ؿ���
           factory[i][j][1]= rand() % 100;        //ת������     iΪ�ڼ�����·   jΪ���Ź���λ
            //cin >> factory[i][j][0] >> factory[i][j][1];
        }
    }
    for (int i = 0; i < LINE; i++) {//���
        cout << "������· " << i << endl;
        for (int j = 0; j < n; j++)
            cout << "(���ػ���ʱ��:" << factory[i][j][0] << " �������ʱ��:" << factory[i][j][1] << ")\n";
        cout << "\n";
    }
    //��������
    cout << "��������" << endl;

    
    startTime = clock();//��ʱ��ʼ
    int **stolee = new int*[pow(2,n)];//�洢���н����·��
    for (int i = 0;i <pow(2,n);i++)
        stolee[i] = new int[n];
    for(int i=0;i<n;i++)
    for (int l = 0;l < n;l++) {
            stolee[i][l] = 3;
        }
    for (int i = 0;i <= n;i++) {//�о�2��n�η������
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
        cout <<"��ǰ��Ϊ��"<<i <<" "<<"��������ѡ��·��" << stolee[recorrrd][i]<<endl;
    }
    endTime = clock();//��ʱ����
    cout << "��������̹���ʱ��Ϊ��" << mintimee << endl;
    cout << "����������ʱ��: " << (double)(endTime - startTime) / CLOCKS_PER_SEC << "s" << endl;
    cout << "����������" << endl;
    cout << endl;
    cout << "��̬�滮����" << endl;
    startTime1 = clock();//��ʱ��ʼ
    cost[0][0] = factory[0][0][0] + e1;
    cost[1][0] = factory[1][0][0] + e2;
    record[0][0] = 0;//��¼ѡ�����ˮ��
    record[1][0] = 1;

    for (int i = 1; i < n; i++) {
        if (cost[0][i - 1] <= cost[1][i - 1] + factory[1][i - 1][1]) {//����·һ��ʱ���ת������·��ʱ����
            cost[0][i] = cost[0][i - 1] + factory[0][i][0];//����·һ����
            record[0][i] = 0;
        }
        else {
            cost[0][i] = cost[1][i - 1] + factory[0][i][0] + factory[1][i - 1][1];//ת������·1
            record[0][i] = 1;
        }

        if (cost[1][i - 1] <= cost[0][i - 1] + factory[0][i - 1][1]) {//����·2ʱ�����·1ʱ����
            cost[1][i] = cost[1][i - 1] + factory[1][i][0];//����·2����
            record[1][i] = 1;
        }
        else {
            cost[1][i] = cost[0][i - 1] + factory[1][i][0] + factory[0][i - 1][1];//ת������·2
            record[1][i] = 0;
        }
    }
    int line = (cost[0][n - 1]  <= cost[1][n - 1] ) ?0 : 1;//��ʾ������· 
    endTime1 = clock();//��ʱ����
    for (int i = n-1; i >=0; i--) {
        cout << "��ѡ�㣺" << i << " "<<"������ˮ�ߣ�" << line << "\n";
        line = record[line][i];
        
    }

    int mint;
        if (cost[1][n - 1] > cost[0][n - 1]) {
        mint = cost[0][n - 1];

    }
    else {
        mint = cost[1][n - 1];

    }
    endTime1 = clock();//��ʱ����
    cout << "��̬�滮����̹���ʱ�䣺"<<mint<< endl;
    
    cout << "��̬�滮����ʱ��: " << ((double)(endTime1 - startTime1) / CLOCKS_PER_SEC)*1000 << "ms" << endl;
    cout << "��̬�滮����" << endl;
    return 0;
}