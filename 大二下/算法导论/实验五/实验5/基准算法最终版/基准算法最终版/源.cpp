#include <iostream> 
#include <string.h>
#include <queue>
#include<ctime>
#define x first 
#define y second 
using namespace std;
typedef pair<int, int> PII;
const int N = 1000;
vector<PII> arcs;

int n, m;
int g[N][N];
bool visit[N];
int bg;
void dfs(int u) {
	visit[u] = true;
	for (int i = 0; i < n; i++) {
		if (g[u][i] != -1 && !visit[i]) {
			dfs(i);
		}
	}
}
int getNum() { //连通块的数量等于dfs的次数 
	int tmp = 0;
	for (int i = 0; i < n; i++) {
		if (!visit[i]) {
			dfs(i);
			tmp++;
		}
	}

	return tmp;
}
bool isLink(PII arc) {
	int a = arc.x, b = arc.y;
	memset(visit, 0, sizeof(visit));
	bool flag1 = false;
	if (g[a][b] == 1) {
		flag1 = true;
	}
	g[a][b] = g[b][a] = -1;
	int res = getNum();
	if (flag1) {
		g[a][b] = g[b][a] = 1;

	}
	if (bg < res) {
		return true;
	}
	return false;

}


int main()
{
	//freopen("D://小规模图.txt", "r", stdin);
	cout << "请输入点数与边数：" << endl;
	cin >> n >> m;
	memset(g, -1, sizeof(g));
	clock_t start, end;
	start = clock();
	for (int i = 0; i < m; i++) {
		int a, b; cin >> a >> b;
		arcs.push_back({ a,b });

		g[a][b] = g[b][a] = 1;

	}
	
	bg = getNum();
	end = clock();   //结束时间
	int k = 0;
	for (int i = 0; i < m; i++) {
		if (isLink(arcs[i])) {
			k++;
			cout << "桥为"<<arcs[i].x << ":" << arcs[i].y << endl;
		}
	}
	cout << "点集数目为：" << n << endl;
	cout << "共搜集到：" << k << "个桥" << endl;
	cout<<"基准算法所花时间："<<double(end - start) / CLOCKS_PER_SEC << "s" << endl;


}
