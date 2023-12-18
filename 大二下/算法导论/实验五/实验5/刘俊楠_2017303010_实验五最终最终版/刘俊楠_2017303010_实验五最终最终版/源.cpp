#include<iostream>
#include<fstream>
#include<windows.h>
using namespace std;
const int MAXN = 100;
// ------------------------基准算法-------------------------------
// --------------------------------------------------------------
int* vis = new int[1000005];

// 边节点
typedef struct edge_node
{
    int adjvex;
    int ifdelete = 0;
    struct edge_node* next;
} edge_node;

// 顶点表节点
typedef struct vertex_node
{
    int data;
    edge_node* first_edge;
} vertex_node;

// 图
typedef struct graph
{
    vertex_node* vertexlist = new vertex_node[1000005];
    int num_vertex, num_edge;
} graph;


void create_graph(graph* G)
{
    int i, k;
    int numv, nume, u, v;
    edge_node* enode, * root;
    ifstream fin("mediumDG.txt");
    // ifstream fin("largeG.txt");
    // ifstream fin("liantong.txt");
    fin >> numv >> nume;
    G->num_edge = nume;
    G->num_vertex = numv;
    for (i = 0; i < numv; i++)
    {
        G->vertexlist[i].data = i;
        G->vertexlist[i].first_edge = NULL;
    }
    //输入边
    for (k = 0; k < nume; k++)
    {
        fin >> u >> v;
        enode = new edge_node;
        enode->adjvex = v;
        enode->next = NULL;
        if (G->vertexlist[u].first_edge == NULL)
        {
            G->vertexlist[u].first_edge = enode;
        }
        else
        {
            root = G->vertexlist[u].first_edge;
            while (root->next != NULL)
            {
                root = root->next;
            }
            root->next = enode;
        }


        enode = new edge_node;
        enode->adjvex = u;
        enode->next = NULL;
        if (G->vertexlist[v].first_edge == NULL)
        {
            G->vertexlist[v].first_edge = enode;
        }
        else
        {
            root = G->vertexlist[v].first_edge;
            while (root->next != NULL)
            {
                root = root->next;
            }
            root->next = enode;
        }
    }
    fin.close();
}

void set_vis(graph* G)
{
    for (int i = 0; i < G->num_vertex; ++i)
    {
        vis[i] = 0;
    }
}

void DFS(graph* G, int u)
{
    vis[u] = 1;
    edge_node* p;
    p = G->vertexlist[u].first_edge;
    // cout << G->vertexlist[u].data<<" ";

    while (p)
    {
        if (vis[p->adjvex] == 0 && p->ifdelete != 1)
        {
            DFS(G, p->adjvex);
        }
        p = p->next;
    }
}

int DFS_T(graph* G)
{
    int i, count = 0;
    set_vis(G);
    for (i = 0; i < G->num_vertex; ++i)
    {
        if (!vis[i])
        {
            DFS(G, i);
            count++;
        }
    }
    return count;
}

void delete_edge(graph* G, int u, int v)
{
    // 标记删除边u->v标记位为1
    edge_node* eroot = G->vertexlist[u].first_edge;
    while (eroot->adjvex != v && eroot != NULL)
    {
        eroot = eroot->next;
    }
    if (eroot == NULL) {
        cout << "-----删除边错误-----" << endl;
        return;
    }
    eroot->ifdelete = 1;
    // 标记删除边v->u标记位为1
    eroot = G->vertexlist[v].first_edge;
    while (eroot->adjvex != u && eroot != NULL)
    {
        eroot = eroot->next;
    }
    if (eroot == NULL)
    {
        cout << "-----删除边错误-----" << endl;
        return;
    }
    eroot->ifdelete = 1;
}

void add_edge(graph* G, int u, int v)
{
    // 标记添加边u->v标记位为0
    edge_node* eroot = G->vertexlist[u].first_edge;
    while (eroot->adjvex != v && eroot != NULL)
    {
        eroot = eroot->next;
    }
    if (eroot == NULL)
    {
        cout << "-----添加边错误-----" << endl;
        return;
    }
    eroot->ifdelete = 0;
    // 标记添加边v->u标记位为0
    eroot = G->vertexlist[v].first_edge;
    while (eroot->adjvex != u && eroot != NULL)
    {
        eroot = eroot->next;
    }
    if (eroot == NULL)
    {
        cout << "-----添加边错误-----" << endl;
        return;
    }
    eroot->ifdelete = 0;
}

int get_bridge_num(graph* G) {
    int num_bridge = 0;
    int conps = DFS_T(G);   // 连通分量
    int i;
    for (i = 0; i < G->num_vertex; ++i)
    {
        edge_node* p = G->vertexlist[i].first_edge;
        while (p != NULL)
        {
            delete_edge(G, i, p->adjvex);
            // delete_edge(G, p->adjvex, i);
            int new_conps = DFS_T(G);
            if (new_conps > conps) {
                cout << i << "--" << p->adjvex << endl;
                num_bridge++;
            }
            add_edge(G, i, p->adjvex);
            // add_edge(G, p->adjvex, i);
            p = p->next;
        }
    }
    return num_bridge;
}

// ------------------以下为并查集+路径压缩部分---------------------
// --------------------------------------------------------------
int* pre = new int[1000005];
int* isRoot = new int[1000005];
void USet(graph* G)
{
    int i;
    for (i = 0; i < G->num_vertex; ++i)
    {
        pre[i] = i;
    }
    for (i = 0; i < G->num_vertex; ++i)
    {
        isRoot[i] = 0;
    }
}

int Find(int x)
{
    int r = x, j;
    while (pre[x] != x)
    {
        x = pre[x];
    }
    while (r != pre[r])    // 路径压缩
    {
        j = r;
        r = pre[r];
        pre[j] = x;
    }
    return x;
}

void Union(int a, int b)
{
    int preA = Find(a);
    int preB = Find(b);
    if (preA != preB)
        pre[preA] = preB;
}

int get_block_num(graph* G)
{
    int num_block = 0;
    int i;
    for (i = 0; i < G->num_vertex; ++i)
        isRoot[Find(i)] = 1;
    for (i = 0; i < G->num_vertex; ++i)
        num_block += isRoot[i];

    return num_block;
}

int usf_get_bridge_num(graph* G)
{
    USet(G);
    int i, k, num_bridge = 0, num_block, new_num_block;
    edge_node* p, * p_edge;
    for (i = 0; i < G->num_vertex; ++i)
    {
        p = G->vertexlist[i].first_edge;
        while (p != NULL)
        {
            Union(i, p->adjvex);
            p = p->next;
        }
    }
    num_block = get_block_num(G);
    for (k = 0; k < G->num_vertex; ++k) {
        p_edge = G->vertexlist[k].first_edge;
        while (p_edge != NULL)
        {
            delete_edge(G, k, p_edge->adjvex);
            USet(G);
            for (i = 0; i < G->num_vertex; ++i)
            {
                p = G->vertexlist[i].first_edge;
                while (p != NULL)
                {
                    if (p->ifdelete != 1)
                    {
                        Union(i, p->adjvex);
                    }
                    p = p->next;
                }
            }
            new_num_block = get_block_num(G);

            if (new_num_block > num_block)
                num_bridge++;
            add_edge(G, k, p_edge->adjvex);
            p_edge = p_edge->next;
        }
    }
    return num_bridge;
}


int main() {
    LARGE_INTEGER freq;
    LARGE_INTEGER start_t, end_t;
    QueryPerformanceFrequency(&freq);
    QueryPerformanceCounter(&start_t);
    graph G;
    create_graph(&G);
    int num_bridge;
    int temp = DFS_T(&G);
    cout << endl;
    cout << "连通分量的数量：" << temp << endl;


    num_bridge = get_bridge_num(&G);
    cout << "桥的数量：" << num_bridge << endl;
    QueryPerformanceCounter(&end_t);
    double time_0 = (double)(1e3 * (end_t.QuadPart - start_t.QuadPart) / freq.QuadPart);
    cout << "花费的时间为：" << time_0 << "ms" << endl;

    QueryPerformanceCounter(&start_t);
    num_bridge = usf_get_bridge_num(&G);
    cout << "桥的数量：" << num_bridge << endl;
    QueryPerformanceCounter(&end_t);
    double time_2 = (double)(1e3 * (end_t.QuadPart - start_t.QuadPart) / freq.QuadPart);
    cout << "花费的时间为：" << time_2 << "ms" << endl;
    int i;
    cin >> i;
    return 0;
}