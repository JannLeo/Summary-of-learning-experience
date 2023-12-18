#include <iostream>
#include <queue>
#define MAXN 15
#define LIMIT_A 3
#define LIMIT_B 10

const int source = 0, sink = 15;
int vis[MAXN];
int last_vex[MAXN];
int vertex_flow[MAXN];
int val[MAXN][MAXN];
int rest[MAXN][MAXN];   // 这个矩阵没使用，但是删了不知道为什么队列会报错
using namespace std;

int BFS_T()
{
    int i, temp;
    queue<int> que;
    for (i = 0; i < MAXN; ++i)
    {
        vis[i] = 0;
        last_vex[i] = 0;
        vertex_flow[i] = 0;
    }
    vis[source] = 1;
    vertex_flow[source] = 9999;
    que.push(source);
    while(!que.empty())
    {
        temp = que.front();
        que.pop();
        if(temp == sink)
            break;
        for (i = source; i <= sink; i++)
        {
            if (!vis[i] && val[temp][i] > 0)
            {
                vis[i] = 1;
                last_vex[i] = temp;
                if (vertex_flow[temp] > val[temp][i])
                    vertex_flow[i] = val[temp][i];
                else
                    vertex_flow[i] = vertex_flow[temp];
                que.push(i);
            }
        }
    }
    if(vertex_flow[sink-1]==0)
        return 0;
    else
        return vertex_flow[sink-1];
}

void create_m()
{
    int i, j;
    for (i = 0; i <= MAXN; ++i)
    {
        for (j = 0; j <= MAXN; ++j)
            val[i][j] = 0;
    }

    for (i = 1; i <= 10; ++i)
    {
        val[source][i] = LIMIT_A;
    }

    for (i = 1; i <= 10; ++i)
    {
        for (j = 11; j <= 13; ++j)
        {
            val[i][j] = 1;
        }
    }
    for (j = 11; j <= 13; ++j)
    {
        val[j][sink - 1] = LIMIT_B;
    }
}

int get_maxvertex_flow()
{
    int i, temp, maxvertex_flow = 0;
    while(BFS_T()){
        i = sink;
        while(i != source)
        {
            temp = last_vex[i];
            val[temp][i] -= vertex_flow[sink-1];
            val[i][temp] += vertex_flow[sink-1];
            i = temp;
        }
        maxvertex_flow += vertex_flow[sink];
    }
    maxvertex_flow += vertex_flow[sink-1];
    return maxvertex_flow;
}

int main(){
    create_m();
    int result = get_maxvertex_flow();
    printf("当a=%d，b=%d时,最大流为： ", LIMIT_A, LIMIT_B);
    cout << result << endl;
    int cut;
    cin >> cut;
    return 0;
}