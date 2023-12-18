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
int getNum() { //��ͨ�����������dfs�Ĵ��� 
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
	//freopen("D://С��ģͼ.txt", "r", stdin);
	cout << "����������������" << endl;
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
	end = clock();   //����ʱ��
	int k = 0;
	for (int i = 0; i < m; i++) {
		if (isLink(arcs[i])) {
			k++;
			cout << "��Ϊ"<<arcs[i].x << ":" << arcs[i].y << endl;
		}
	}
	cout << "�㼯��ĿΪ��" << n << endl;
	cout << "���Ѽ�����" << k << "����" << endl;
	cout<<"��׼�㷨����ʱ�䣺"<<double(end - start) / CLOCKS_PER_SEC << "s" << endl;


}
