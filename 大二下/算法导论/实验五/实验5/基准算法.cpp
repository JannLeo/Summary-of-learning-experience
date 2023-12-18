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
void dfs(int u) {
	visit[u] = true;
	for(int i = 0; i < n; i ++) {
		if(g[u][i] != -1 && !visit[i]) {
			dfs(i);
		}
	}
}
int getNum() { //连通块的数量等于dfs的次数 
	int tmp = 0;
	for(int i = 0; i < n ; i ++) {
		if(!visit[i]) {
			dfs(i);
			tmp ++;
		}
	}

	return tmp;
}
bool isLink(PII arc) {
	int a = arc.x, b = arc.y;
	memset(visit,0,sizeof(visit));
	bool flag1 = false;
	if(g[a][b] == 1)  {
		flag1 = true;
	}
	g[a][b] = g[b][a] = -1;
	int res = getNum();
	if(flag1) {
			g[a][b] = g[b][a] = 1;

	}
	if(bg < res) {
		return true; 
	}
	return false;
	
}


int main()
{
	freopen("tpl.txt","r",stdin) ;
	cin >> n >> m;
	memset(g,-1,sizeof (g));
	
	for(int i = 0; i < m; i ++) {
		int a,b; cin >> a >> b;
		arcs.push_back({a,b});
		g[a][b] = g[b][a] = 1;
		
	}
	
	bg = getNum();

	for(int i = 0 ; i < m; i ++) {
		if(isLink(arcs[i])) {
			cout << arcs[i].x << ":" << arcs[i].y << endl;
		}
	}
	
	
}
