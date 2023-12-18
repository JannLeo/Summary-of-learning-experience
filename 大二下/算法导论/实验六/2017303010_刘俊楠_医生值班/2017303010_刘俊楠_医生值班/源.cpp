
//2021��6��17�գ�����骣�2017303010
#include <iostream>
#include<windows.h>
#include<vector>
#include <queue>
using namespace std;
LARGE_INTEGER m_freq, m_doctor_nummtart, m_timeNow;
struct edge
{
    //// st:���, ed:�յ�, val:����ͨ����������, reves_num:������±� 
    int st;
    int ed;
    int val;
    int reves_num;
    edge(int a1=0, int b1=0, int c1=0, int d1=0):st(a1),ed(b1),val(c1),reves_num(d1){}
};

int n;//�ڵ���Ŀ
int e;
int src;//����±�
int dst;//�յ��±�
int day_nums, holiday_nums;//day_nums:�������ڵ���������    holiday_nums:��������
vector<vector<int>> adj;// adj[x][i]��ʾ��x�����ĵ�i�����ڱ߼����е��±� 
int*father = new int[100000];   //������
int* min_flow = new int[100000];//��С��
int* visit = new int[100000];//��ǰ��������
int* flow_findpath = new int[100000];//���ص�ǰ������·��
vector<edge> edges;//�߼���
vector<edge> edges_init;// ԭʼ���� ��Ϊÿ�α�Ҫ���������ظ�����ʱҪ��ʼ���� 

void 
set_zhuangtai() {
    for (int i = 0; i < n; i++) {
        father[i] = 0;//��ʼ����
        visit[i] = 0;//��ʼ����������
        flow_findpath[i] = -1;//��ʼ��Ѱ��·��
    }
}



bool 
BFS_huidian()      //�����������  ������㣡��
{
    set_zhuangtai();//��ʼ��״̬
    queue<int> 
        q;//  ֻ�ܷ��� queue<T> �����������ĵ�һ�������һ��Ԫ�ء�ֻ����������ĩβ�����Ԫ�أ�ֻ�ܴ�ͷ���Ƴ�Ԫ�ء�   ����һ������q  
    q.push(0);   // ��0�������
    visit[0] = 1;  //��Ǳ�����   
    while (!q.empty())//�����в�Ϊ��
    {
        int zgljflag = q.front();//���� queue �е�һ��Ԫ�ص����á���� queue �ǳ������ͷ���һ�������ã���� queue Ϊ�գ�����ֵ��δ����ġ�
        q.pop();             //ɾ�� queue �еĵ�һ��Ԫ�ء�
        for (int i = 0; i < adj[zgljflag].size(); i++)//����·���е����б߽���ѭ��
        {
            //����δ��������������0
            if (visit[edges[adj[zgljflag]
                [i]].ed] == 0 && edges[adj[zgljflag]
                [i]].val > 0)//���������·����Ӧ�ĵ�ı��±��Ӧ�ıߵ��յ�δ������������·���µ�ĳ��ıߵ���������0
            {
                q.push(edges[adj
                    [zgljflag][i]].ed);//�Ѹ�����·����ĳ��ı��±��Ӧ�ıߵ��յ�ѹ��ջ��    ˵�������������·��
                father[edges[adj[zgljflag]
                    [i]].ed] = zgljflag;//������·���Ķ�Ӧ�ĵ��Ӧ�ı��±�ı߶�Ӧ���յ���Ϊ������·������
                flow_findpath[edges[adj[zgljflag]
                    [i]].ed] = i;//���ص�ǰ·��
                visit[edges[adj[zgljflag]
                    [i]].ed] = 1;//����ѷ���Ŀ��ڵ�
                if (visit[n - 1] == 1)  //���ҵ����ʱ   ����·��Ϊ����·����
                {
                    return 1;
                }
            }
        }
    }
    return false;//��û�ҵ����
}
void 
EK_suanfa() {
    int ek_maxflow = 0;  //��¼�����
    while (1) {
        int min_flow = INT_MAX; //��С��
        bool flag = BFS_huidian();//������ǰ�Ƿ�������·��  ����1  ����0
        if (flag == 0) {   //���û�����˳�ѭ��
            break;
        }
        for (int i = n - 1; i != 0; i = father[i])//�ӻ�㿪ʼ����
        {
            min_flow = min(min_flow, edges[adj[father[i]]
                [flow_findpath[i]]].val);//Ѱ��·������С��
        }
        for (int i = n - 1; i != 0; i = father[i])//�ӻ�㿪ʼ����
        {
            edges[edges[adj[father[i]]
                [flow_findpath[i]]].reves_num].val += min_flow;//������·����ĳ���Ӧ�ı��±�ıߵ�ʣ�������������������С��
            edges[adj[father[i]]
                [flow_findpath[i]]].val -= min_flow;//������·����Ӧ��ĳ���Ӧ�ıߵ��������ڸõ��ȥ��С��
        }
        ek_maxflow += min_flow;//�������������ϸ�����·������С��
    }
    if (ek_maxflow >= (holiday_nums * day_nums))
        //������������ҽ��ֵ���׼
        cout << "�������ĿΪ:" << ek_maxflow << endl;
    //�����
    else
        cout << "solution error!" << endl;
    //��������
}

void 
edges_add(int st, int ed, int val)//val Ϊ���ż���  ҲΪ��   ������
{
    int ii = edges_init.size();  //ԭʼ����ʵ�ʸ���     ��ʼΪ0
    edges_init.push_back(edge(st, ed, val, ii + 1));  //����������������   ii+1Ϊ�±�  valΪ���ż���
    edges_init.push_back(edge(ed, st, 0, ii));//��ӳ�ʼ��  Ϊ �յ㵽��ʼ�������ߣ�
    adj[st].push_back(ii);//����Դ����±�
    adj[ed].push_back(ii + 1);//�����յ���±�
}

void 
initialize_graph(int doc_num, int hol_num, int day_num, int max_day)
{
    //  ���  �յ�
    int st, ed,doctor_numm = -1;//����
    n = 1 + doc_num + doc_num 
        * hol_num + hol_num 
        * day_num + 1; //�ڵ���=1+ҽ����Ŀ+ҽ��*������Ŀ+����*����+1��
    
    adj.resize(n);//�ı䵱ǰʹ�����ݵĴ�С��������ȵ�ǰʹ�õĴ󣬻������Ĭ��ֵ   ��¼ÿ��������·���±����������
    father = new int[n];  //   ��Ϊ������
    min_flow = new int[n];// min_flow[x]��ʾ����㵽x��·������ϸ�� ��Ϊ����·�������ϸ��
    edges_init.clear();   //��յ�ǰ����   ��ʼ��
    edges.clear();        //��ձ߼���
    src = 0, dst = n - 1;  //��ʼ���±�    �յ��±�
    cout << "�ڵ���Ϊ��" << n << endl;
    for (int i = 1; i < doc_num + 1; i++)   //ҽ���±�   ��ʼ��ͼ  ���ӵ�һ���
    {
        st = src;//��¼��ʼ��Ϊ0
        ed = i;//��¼�յ�Ϊĳҽ��
        edges_add(st, ed, max_day);//���Դ�㵽ҽ���ı�  ������ҽ�����ż�����max_day
    }
    for (int i = 0; i < doc_num; i++)   //��ҽ������
        for (int j = 0; j < hol_num; j++)  //�Լ�������      ��Ϊ�ڶ����
        {
            st = i + 1;   //   ��ʱԴ����ҽ���ĵ�
            ed = 1 + doc_num + doc_num * j + i;//�յ���ҽ�����ڵĵ�   �±����Ϊ��1+ҽ��+ҽ��*����+��ǰ����
            edges_add(st, ed, 1);//����ñ�   ������Ϊ1
        }
    for (int i = 0; i < hol_num * doc_num; i++)//����ҽ��*���ڵ�����        ������ͼ������
    {
        if (i % doc_num == 0) doctor_numm++;  //�Բ�ͬҽ��ͬһ���ڼӱߣ�
        for (int j = 0; j < day_num; j++)  //�Ե�����������    �������
        {
            st = i + 1 + doc_num;  //��Ӧҽ��ĳ�����ڵĵ�
            ed = 1 + doc_num + doc_num * hol_num + j + day_num * doctor_numm; //��Ӧĳ�����ڵ�ĳ��ĵ�
            edges_add(st, ed, 1);//������Ϊ1 �ĵ������
        }
    }
    for (int i = 0; i < hol_num * day_num; i++)//���Ĳ�ĵ�
    {
        st = 1 + doc_num + doc_num * hol_num + i;//���Ĳ����
        ed = dst;//�յ�ֱ��
        edges_add(st, ed, 1);//��ҲΪ1
    }
    e = edges_init.size();//�߳�ʼ���Ĵ�С
    edges.resize(e);      //�ı�߼���С   
}
void recover_graph() //����ͼ��
{
    for (int i = 0; i < e; i++)

        edges[i] = edges_init[i];//ͼ����ڳ�ʼ��
}
int main()
{
    system("color F0");
    //������Ӧ��ֵ
    int doc_num=0, hol_num=0, day_num=0, doc_maxday=0;
    cout << "�������ҽ������n" <<endl
        << "��������k" << endl
        << "�������ڵļ�������a" << endl
        << "����ҽ�����ֵ������c" << endl;
    cin >> doc_num >> hol_num >> day_num >> doc_maxday;
    day_nums = day_num;
    holiday_nums = hol_num;
    //ͼ��ʼ��
    initialize_graph(doc_num, hol_num, day_num, doc_maxday);
    recover_graph();//�ָ�ͼ
    QueryPerformanceFrequency(&m_freq);
    QueryPerformanceCounter(&m_doctor_nummtart);
    EK_suanfa();
    QueryPerformanceCounter(&m_timeNow);
    double elapsedTime = (double)(m_timeNow.QuadPart - m_doctor_nummtart.QuadPart) / m_freq.QuadPart;
    cout << "EK����ʱ��Ϊ��"<<elapsedTime<<" S" << endl;

    return 0;
}

