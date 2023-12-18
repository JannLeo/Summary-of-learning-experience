
//2021年6月17日，刘俊楠，2017303010
#include <iostream>
#include<windows.h>
#include<vector>
#include <queue>
using namespace std;
LARGE_INTEGER m_freq, m_doctor_nummtart, m_timeNow;
struct edge
{
    //// st:起点, ed:终点, val:还能通过多少流量, reves_num:反向边下标 
    int st;
    int ed;
    int val;
    int reves_num;
    edge(int a1=0, int b1=0, int c1=0, int d1=0):st(a1),ed(b1),val(c1),reves_num(d1){}
};

int n;//节点数目
int e;
int src;//起点下标
int dst;//终点下标
int day_nums, holiday_nums;//day_nums:单个假期的日期数量    holiday_nums:假期数量
vector<vector<int>> adj;// adj[x][i]表示从x出发的第i条边在边集合中的下标 
int*father = new int[100000];   //生成树
int* min_flow = new int[100000];//最小流
int* visit = new int[100000];//当前遍历数组
int* flow_findpath = new int[100000];//记载当前的增广路径
vector<edge> edges;//边集合
vector<edge> edges_init;// 原始数据 因为每次边要增广所以重复计算时要初始化边 

void 
set_zhuangtai() {
    for (int i = 0; i < n; i++) {
        father[i] = 0;//初始化树
        visit[i] = 0;//初始化遍历数组
        flow_findpath[i] = -1;//初始化寻找路径
    }
}



bool 
BFS_huidian()      //广度优先搜索  搜索汇点！！
{
    set_zhuangtai();//初始化状态
    queue<int> 
        q;//  只能访问 queue<T> 容器适配器的第一个和最后一个元素。只能在容器的末尾添加新元素，只能从头部移除元素。   定义一个队列q  
    q.push(0);   // 把0放入队列
    visit[0] = 1;  //标记遍历点   
    while (!q.empty())//当队列不为空
    {
        int zgljflag = q.front();//返回 queue 中第一个元素的引用。如果 queue 是常量，就返回一个常引用；如果 queue 为空，返回值是未定义的。
        q.pop();             //删除 queue 中的第一个元素。
        for (int i = 0; i < adj[zgljflag].size(); i++)//增广路径中的所有边进行循环
        {
            //若边未被访问且流大于0
            if (visit[edges[adj[zgljflag]
                [i]].ed] == 0 && edges[adj[zgljflag]
                [i]].val > 0)//如果该增广路径对应的点的边下标对应的边的终点未被访问且增广路径下的某点的边的流量大于0
            {
                q.push(edges[adj
                    [zgljflag][i]].ed);//把该增广路径的某点的变下表对应的边的终点压入栈内    说明其加入了增广路径
                father[edges[adj[zgljflag]
                    [i]].ed] = zgljflag;//该增广路径的对应的点对应的边下标的边对应的终点标记为该增广路径所属
                flow_findpath[edges[adj[zgljflag]
                    [i]].ed] = i;//记载当前路径
                visit[edges[adj[zgljflag]
                    [i]].ed] = 1;//标记已访问目标节点
                if (visit[n - 1] == 1)  //当找到汇点时   返回路径为增广路径！
                {
                    return 1;
                }
            }
        }
    }
    return false;//若没找到汇点
}
void 
EK_suanfa() {
    int ek_maxflow = 0;  //记录最大流
    while (1) {
        int min_flow = INT_MAX; //最小流
        bool flag = BFS_huidian();//搜索当前是否有增广路径  有则1  无则0
        if (flag == 0) {   //如果没有则退出循环
            break;
        }
        for (int i = n - 1; i != 0; i = father[i])//从汇点开始返回
        {
            min_flow = min(min_flow, edges[adj[father[i]]
                [flow_findpath[i]]].val);//寻找路径中最小流
        }
        for (int i = n - 1; i != 0; i = father[i])//从汇点开始返回
        {
            edges[edges[adj[father[i]]
                [flow_findpath[i]]].reves_num].val += min_flow;//该增广路径的某点对应的边下表的边的剩余流量的流等于其加最小流
            edges[adj[father[i]]
                [flow_findpath[i]]].val -= min_flow;//该增广路径对应的某点对应的边的流量等于该点减去最小流
        }
        ek_maxflow += min_flow;//最大流等于其加上该增广路径的最小流
    }
    if (ek_maxflow >= (holiday_nums * day_nums))
        //如果最大流满足医生值班标准
        cout << "最大流数目为:" << ek_maxflow << endl;
    //则输出
    else
        cout << "solution error!" << endl;
    //否则不满足
}

void 
edges_add(int st, int ed, int val)//val 为最大放假数  也为流   ！！！
{
    int ii = edges_init.size();  //原始数据实际个数     初始为0
    edges_init.push_back(edge(st, ed, val, ii + 1));  //在数组最后添加数据   ii+1为下标  val为最大放假数
    edges_init.push_back(edge(ed, st, 0, ii));//添加初始边  为 终点到起始点的逆向边！
    adj[st].push_back(ii);//加入源点的下标
    adj[ed].push_back(ii + 1);//加入终点的下标
}

void 
initialize_graph(int doc_num, int hol_num, int day_num, int max_day)
{
    //  起点  终点
    int st, ed,doctor_numm = -1;//次数
    n = 1 + doc_num + doc_num 
        * hol_num + hol_num 
        * day_num + 1; //节点数=1+医生数目+医生*假期数目+假期*天数+1；
    
    adj.resize(n);//改变当前使用数据的大小，如果它比当前使用的大，或者填充默认值   记录每次找增光路径下标的总数增加
    father = new int[n];  //   此为生成树
    min_flow = new int[n];// min_flow[x]表示从起点到x的路径中最细流 即为增广路径里的最细流
    edges_init.clear();   //清空当前容器   初始化
    edges.clear();        //清空边集合
    src = 0, dst = n - 1;  //起始点下标    终点下标
    cout << "节点数为：" << n << endl;
    for (int i = 1; i < doc_num + 1; i++)   //医生下标   开始画图  增加第一层边
    {
        st = src;//记录起始点为0
        ed = i;//记录终点为某医生
        edges_add(st, ed, max_day);//标记源点到医生的边  并传入医生最大放假数的max_day
    }
    for (int i = 0; i < doc_num; i++)   //对医生数量
        for (int j = 0; j < hol_num; j++)  //对假期数量      此为第二层边
        {
            st = i + 1;   //   此时源点变成医生的点
            ed = 1 + doc_num + doc_num * j + i;//终点变成医生假期的点   下标计算为：1+医生+医生*假期+当前假期
            edges_add(st, ed, 1);//加入该边   并且流为1
        }
    for (int i = 0; i < hol_num * doc_num; i++)//对于医生*假期的数量        第三层图！！！
    {
        if (i % doc_num == 0) doctor_numm++;  //对不同医生同一假期加边！
        for (int j = 0; j < day_num; j++)  //对单个假期数量    第三层边
        {
            st = i + 1 + doc_num;  //对应医生某个假期的点
            ed = 1 + doc_num + doc_num * hol_num + j + day_num * doctor_numm; //对应某个假期的某天的点
            edges_add(st, ed, 1);//增加流为1 的第三层边
        }
    }
    for (int i = 0; i < hol_num * day_num; i++)//第四层的点
    {
        st = 1 + doc_num + doc_num * hol_num + i;//第四层起点
        ed = dst;//终点直接
        edges_add(st, ed, 1);//流也为1
    }
    e = edges_init.size();//边初始化的大小
    edges.resize(e);      //改变边集大小   
}
void recover_graph() //跟新图像
{
    for (int i = 0; i < e; i++)

        edges[i] = edges_init[i];//图像等于初始化
}
int main()
{
    system("color F0");
    //输入相应的值
    int doc_num=0, hol_num=0, day_num=0, doc_maxday=0;
    cout << "请输出流医生数量n" <<endl
        << "假期数量k" << endl
        << "单个假期的假日数量a" << endl
        << "单个医生最大值班天数c" << endl;
    cin >> doc_num >> hol_num >> day_num >> doc_maxday;
    day_nums = day_num;
    holiday_nums = hol_num;
    //图初始化
    initialize_graph(doc_num, hol_num, day_num, doc_maxday);
    recover_graph();//恢复图
    QueryPerformanceFrequency(&m_freq);
    QueryPerformanceCounter(&m_doctor_nummtart);
    EK_suanfa();
    QueryPerformanceCounter(&m_timeNow);
    double elapsedTime = (double)(m_timeNow.QuadPart - m_doctor_nummtart.QuadPart) / m_freq.QuadPart;
    cout << "EK运行时间为："<<elapsedTime<<" S" << endl;

    return 0;
}

