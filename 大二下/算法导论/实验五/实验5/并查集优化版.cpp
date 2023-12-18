#include <iostream> 
#include <string.h>
#include <queue>
#define x first 
#define y second 
using namespace std;
typedef pair<int,int> PII;
const int N = 1000;
vector<PII> arcs;

int n,m;
int g[N][N];
bool visit[N];
int bg;
int p[N];// 并查集 
int find(int x)
{
    if (p[x] != x) p[x] = find(p[x]);
    return p[x];
//	while(p[x] != x) x = p[x];
//	return x;
}
void dfs(int u) {
	visit[u] = true;
	for(int i = 0; i < n; i ++) {
		if(g[u][i] != -1 && !visit[i]) {
			dfs(i);
		}
	}
}
bool getNum(int u) { //连通块的数量等于dfs的次数 	
	dfs(u);
	for(int i = 0; i < n; i ++) if(!visit[i]) return false;
	return true;
}
bool isLink(PII arc) {
	int a = arc.x, b = arc.y;
	memset(visit,0,sizeof(visit));
	//并查集优化
	int fa = find(a);
	for(int i = 0 ;i < n; i ++) {
		if(find(i) != fa) visit[i] = true;
	}
	
	//---------------------
	
	
	bool flag = false;
	if(g[a][b] == 1)  flag = true;
	g[a][b] = g[b][a] = -1;
	bool res = getNum(a);
	if(flag)  g[a][b] = g[b][a] = 1;
	if(res) return true; 
	return false;
	
}


int main()
{
	freopen("tpl.txt","r",stdin) ;
	cin >> n >> m;
	memset(g,-1,sizeof (g));
	for(int i = 0; i < n; i ++) p[i] = i; //初始化并查集
	for(int i = 0; i < m; i ++) {
		int a,b; cin >> a >> b;
	
		//构建并查集，如果a和b已经在同一个集合，则不用merge

		if(find(a) != find(b)) {
			
			p[find(a)] = find(b);
		}
		arcs.push_back({a,b});
		g[a][b] = g[b][a] = 1;
	}


	for(int i = 0 ; i < m; i ++) {
		if(!isLink(arcs[i])) {
			cout << arcs[i].x << ":" << arcs[i].y << endl;
		}
	}

	
	
}
