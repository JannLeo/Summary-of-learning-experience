#include <bits/stdc++.h>

using namespace std;

#define inf 1145141919

typedef struct edge
{
	int st, ed, val, pair;	// ���, �յ�, ����ͨ����������, ������±� 
	edge(){}
	edge(int a, int b, int c, int d){st=a;ed=b;val=c;pair=d;}	
}edge;

int n,e,src,dst,ans;		// ������, ��ʼ����, Դ, Ŀ, �� 
vector<vector<int>> adj;	// adj[x][i]��ʾ��x�����ĵ�i�����ڱ߼����е��±� 
vector<edge> edges;			// �߼��� 
vector<edge> edges_;		// ԭʼ���� ��Ϊÿ�α�Ҫ���������ظ�����ʱҪ��ʼ���� 
vector<int> min_flow;		// min_flow[x]��ʾ����㵽x��·������ϸ�� 
vector<int> father;			// ������ 
vector<int> level;			// ��� 
vector<int> cur_arc;		// ��ǰ���Ż�����
vector<int> dis_cnt;		// ��������� 
vector<int> hyper_flow;		// �������� 


/* ---------------------------------------------------------------------------- */

/*
 *	@function bfs_augment : bfs���������·�� 
 *	@param				  : ----
 *	@return 			  : ����ҵ���return true����false 
 *	@pexlain			  : father�������� min_flow���½ڵ���ϸ�� 
 */
bool bfs_augment()
{
	for(int i=0; i<n; i++) father[i]=-1;
	for(int i=0; i<n; i++) min_flow[i]=inf; // inf
	father[src] = src;
	
	queue<int> q; q.push(src);
	while(!q.empty())
	{
		int x=q.front(),y; q.pop();
		if(x==dst) return true;
		for(int i=0; i<adj[x].size(); i++)
		{
			edge e = edges[adj[x][i]];
			y = e.ed;
			if(father[y]!=-1 || e.val==0) continue;
			father[y] = x;
			min_flow[y] = min(e.val, min_flow[x]);
			q.push(y);
		}
	}
	return false;
}

/*
 *	@function graph_update : ����bfs_augment��������father[]����ͼ 
 *	@param				   : ----
 *	@return 			   : ----
 *	@explain			   : ��Ҫ��bfs_augment֮��ʹ�� 
 */
void graph_update()
{
	int x, y=dst, flow=min_flow[dst], i;
	//cout<<"��������: "<<flow<<" ·��: ";
	ans += flow;
	vector<int> path;
	while(y!=src)	// ��������������㲢��;���±� 
	{
		path.push_back(y);
		x = father[y];
		for(i=0; i<adj[x].size(); i++) if(edges[adj[x][i]].ed==y) break;	
		edges[adj[x][i]].val -= flow;
		edges[edges[adj[x][i]].pair].val += flow;	// ������һ��ı� 
		y = x;
	}
	/* 
	path.push_back(y);
	for(int i=path.size()-1; i>=0; i--) cout<<path[i]<<" "; cout<<endl;
	*/ 
}

/*
 *	@function EK : Edmonds-Karp�㷨������� 
 */
void EK()
{
	ans = 0;
	while(1)
	{
		if(!bfs_augment()) break;
		graph_update();
		/* 
		// ��ӡͼ��Ϣ
		for(int i=0; i<edges.size(); i++) 
			cout<<edges[i].st<<" -> "<<edges[i].ed<<" val="<<edges[i].val<<endl;
		cout<<endl;
		*/ 
	}
	//cout<<"�����:"<<ans<<endl;
}

/* ---------------------------------------------------------------------------- */

/*
 *	@function bfs_level : ��α�����ǽڵ���� 
 *	@param				: ----
 *	@return 			������ҵ��յ�return true ����false 
 *	@explain			: ----
 */
bool bfs_level()
{
	for(int i=0; i<n; i++) level[i]=-1;
	level[src] = 0;	// ��ʼ�ڵ��0�� 
	
	queue<int> q; q.push(src);
	int lv = 0;		// bfs����� 
	while(!q.empty())
	{
		lv++;
		int qs = q.size();
		for(int sq=0; sq<qs; sq++)
		{
			int x=q.front(),y; q.pop();
			if(x==dst) return true;
			for(int i=0; i<adj[x].size(); i++)
			{
				edge e = edges[adj[x][i]];
				y = e.ed;
				if(level[y]!=-1 || e.val==0) continue;
				level[y] = lv;
				q.push(y);
			}
		}
	}
	return false;
}

/* 
void dfs_dinic(int x, list<int>& path)
{
	father[x] = 1;	// father�䵱���ʿ������� 
	for(int i=0; i<adj[x].size(); i++)
	{
		edge e = edges[adj[x][i]];
		int y = e.ed;
		if(father[y]!=-1 || e.val==0 || level[y]!=level[x]+1) continue;
		path.push_back(adj[x][i]);	// path��¼�����ıߵ��±� 
		min_flow[y] = min(e.val, min_flow[x]);
		// �ҵ����������·���ϵı� 
		if(y==dst)
		{
			for(auto it=path.begin(); it!=path.end(); it++)
				edges[*it].val-=min_flow[y], edges[edges[*it].pair].val+=min_flow[y];
			ans += min_flow[y];
		}
		dfs_dinic(y, path);
		path.pop_back();
	}
}
*/

/*
 *	@function dfs_dinic1 : ��ͨDinic�㷨 ��x�ڵ�����flow���� ���ҳ��Է�����ȥ 
 *	@param x			 : ��ǰ�ڵ� 
 *	@param flow			 : Ҫ��x�������������������ֵ�� 
 *	@return 			 : �ڵ�xʵ�����·����˶�������  
 *	@explain			 : һ���ҵ��������� һ����һ�� 
 *						 : ʹ��father������Ϊ���ʿ���visit���� 
 */
int dfs_dinic1(int x, int flow)
{
	father[x] = 1;
	if(x==dst) return flow;
	for(int i=0; i<adj[x].size(); i++)
	{
		edge e = edges[adj[x][i]];
		int y = e.ed;
		if(e.val==0 || level[y]!=level[x]+1 || father[y]==1) continue;
		int res = dfs_dinic1(y, min(flow, e.val));
		edges[adj[x][i]].val-=res, edges[edges[adj[x][i]].pair].val+=res;
		if(res!=0) return res;	// �ҵ�ֱ�ӷ��� 
	}
	return 0;	// û�ҵ��򷵻�0 
} 

/*
 *	@function Dinic1 : ��ͨDinic�㷨������� 
 *	@explain		 : ��level��������α������ ��������� 
 */
void Dinic1()
{
	ans = 0;
	while(bfs_level())
	{
		while(1)
		{
			for(int i=0; i<n; i++) father[i]=0;
			int res = dfs_dinic1(src, inf);
			if(res==0) break;	// �Ҳ�������· ��Ҫ����bfs���²�� 
			ans += res;
		}
		
		/* 
		// ��ӡͼ��Ϣ 
		for(int i=0; i<edges.size(); i++) 
			cout<<edges[i].st<<" -> "<<edges[i].ed<<" val="<<edges[i].val<<endl;
		cout<<endl;
		*/ 
	}
	//cout<<"�����:"<<ans<<endl;
}

/*
 *	@function dfs_dinic2 : Dinic + ��ǰ���Ż� 
 *	@param x			 : ��ǰ�ڵ� 
 *	@param flow			 : Ҫ��x�������������������ֵ�� 
 *	@return 			 : �ڵ�xʵ�����·����˶�������  
 *	@explain			 : һ���ҵ��������� һ����һ�� 
 *						 : ʹ��father������Ϊ���ʿ���visit���� 
 */
int dfs_dinic2(int x, int flow)
{
	father[x] = 1;
	if(x==dst) return flow;
	for(int& i=cur_arc[x]; i<adj[x].size(); i++)
	{
		edge e = edges[adj[x][i]];
		int y = e.ed;
		if(e.val==0 || level[y]!=level[x]+1 || father[y]==1) continue;
		int res = dfs_dinic2(y, min(flow, e.val));
		edges[adj[x][i]].val-=res, edges[edges[adj[x][i]].pair].val+=res;
		if(res!=0) return res;	// �ҵ�ֱ�ӷ��� 
	}
	return 0;	// û�ҵ��򷵻�0 
} 

/*
 *	@function Dinic2 : Dinic + ��ǰ���Ż� 
 *	@explain		 : ��level��������α������ ��������� 
 */
void Dinic2()
{
	ans = 0;
	while(bfs_level())
	{
		// ��ǰ������ 
		for(int i=0; i<n; i++) cur_arc[i]=0;
		while(1)
		{
			for(int i=0; i<n; i++) father[i]=0;	// ÿ��dfs����visit���� 
			int res = dfs_dinic2(src, inf);
			if(res==0) break;	// �Ҳ�������· ��Ҫ����bfs���²�� 
			ans += res;
		}
		
		/* 
		// ��ӡͼ��Ϣ 
		for(int i=0; i<edges.size(); i++) 
			cout<<edges[i].st<<" -> "<<edges[i].ed<<" val="<<edges[i].val<<endl;
		cout<<endl;
		*/ 
	}
	//cout<<"�����:"<<ans<<endl;
}

/*
 *	@function dfs_dinic1 : Dinic + ��·����
 *	@param x			 : ��ǰ�ڵ� 
 *	@param flow			 : Ҫ��x�������������������ֵ�� 
 *	@return 			 : �ڵ�xʵ�����·����˶�������  
 *	@explain			 : һ����������·�� 
 */
int dfs_dinic3(int x, int flow)
{
	if(x==dst) return flow;
	int temp_flow = flow;	// ��¼�ܷ�������ֵ 
	for(int i=0; i<adj[x].size(); i++)
	{
		edge e = edges[adj[x][i]];
		int y = e.ed;
		if(e.val==0 || level[y]!=level[x]+1) continue;
		int res = dfs_dinic3(y, min(flow, e.val));
		edges[adj[x][i]].val-=res, edges[edges[adj[x][i]].pair].val+=res;
		flow-=res;	// ���¿������� 
		if(flow==0) return temp_flow;	// ��������˾ͽ���  
	}
	return temp_flow-flow;	// ����ʵ�ʷ����  
} 

/*
 *	@function Dinic1 : Dinic�㷨 + ��·���� 
 *	@explain		 : ��level��������α������ ��������� 
 */
void Dinic3()
{
	ans = 0;
	while(bfs_level())
	{
		ans += dfs_dinic3(src, inf);	// dfs���ͼ�Ը��±� 
		/* 
		// ��ӡͼ��Ϣ 
		for(int i=0; i<edges.size(); i++) 
			cout<<edges[i].st<<" -> "<<edges[i].ed<<" val="<<edges[i].val<<endl;
		cout<<endl;
		*/ 
	}
	//cout<<"�����:"<<ans<<endl;
}

/* ---------------------------------------------------------------------------- */

/*
 *	@function dfs_ISAP : �ڲ��ͼ�����·������� ��x�ڵ�����flow���� ���ҳ��Է�����ȥ 
 *	@param x		   : ��ǰ�ڵ� 
 *	@param flow		   : Ҫ��x�������������������ֵ�� 
 *	@return 		   : �ڵ�xʵ�����·����˶�������  
 *	@explain		   : ��Dinic���� ֻ�Ǳ�bfs�߸��²�� 
 */
bool ISAP_flag = false;
int dfs_ISAP(int x, int flow)
{
	if(x==dst) return flow;
	int temp_flow = flow;	// temp_flow���������ӵ�е�����	
	for(int i=0; i<adj[x].size(); i++)	
	{
		edge e = edges[adj[x][i]];
		int y = e.ed;
		if(level[x]!=level[y]+1 || e.val==0) continue;
		int res = dfs_ISAP(y, min(e.val, flow));
		edges[adj[x][i]].val-=res, edges[edges[adj[x][i]].pair].val+=res;	// ��ջʱ����ͼ 
		flow -= res;	// ������res������ĳ����֧ 
		if(flow==0) return temp_flow;	// ���������򷵻� 
	}
	dis_cnt[level[x]]--;	// �����¾������ 
	if(dis_cnt[level[x]]==0) ISAP_flag=true;	// ���ֶϲ����ǰ���� 
	level[x]++;			// �Ѿ����������ӽڵ� �����ں͸�һ����������·�� ·�������ϸ��������� 
	dis_cnt[level[x]]++;	// �����¾������ 
	return temp_flow-flow;	// �����Ѿ������������Ŀ 
}

/*
 *	@function ISAP : ISAP 
 *	@explain	   : ��level���������������飬�����𽥼��� 
 				   : ���뵱ǰ���Ż���gap�Ż� 
 */
void ISAP()
{
	bfs_level();
	// ��������Ϊ�������� 
	int mlv = *max_element(level.begin(), level.end());
	for(int i=0; i<n; i++) level[i]=mlv-level[i], dis_cnt[i]=0;
	// ���������������ʼֵ 
	for(int i=0; i<n; i++) dis_cnt[level[i]]++;
	
	ans=0; ISAP_flag=false;
	while(level[src]<n && !ISAP_flag)
	{
		ans+=dfs_ISAP(src, inf);
		if(ISAP_flag) break;	
	} 
	
	/*
	// ��ӡͼ��Ϣ 
	for(int i=0; i<edges.size(); i++) 
		cout<<edges[i].st<<" -> "<<edges[i].ed<<" val="<<edges[i].val<<endl;
	cout<<endl;
	*/ 
	//cout<<"�����:"<<ans<<endl;
}

/* ---------------------------------------------------------------------------- */

typedef struct hlpp_node
{
	int x, h;
	hlpp_node(int a, int b){x=a; h=b;}
	bool operator < (const hlpp_node& n2)const{return h<n2.h;}
}hlpp_node;

/*
 *	@function relabel : ���±�Ǹ߶� 
 *	@param x		  : ���±��x��ĸ߶� �߶�Ϊ�ڽӵ�֮����͵�+1 
 *	@return			  : ----
 */
void relabel(int x)
{
	level[x] = inf;
	for(int i=0; i<adj[x].size(); i++)
	{
		if(edges[adj[x][i]].val==0) continue;
		level[x] = min(level[x], level[edges[adj[x][i]].ed]+1);
	} 
}

/*
 *	@function HLPP : ��߱��Ԥ���ƽ� 
 *	@param		   : ----
 *	@return		   : ----
 *	@explain	   : ʱ�临�Ӷ��Ͻ�Ϊ O(n^2 * sqrt(e)) ���ıȽϽ� 
 */
void HLPP()
{
	bfs_level();
	// ��������Ϊ�������� 
	int mlv = *max_element(level.begin(), level.end());
	for(int i=0; i<n; i++) level[i]=mlv-level[i], dis_cnt[i]=0, hyper_flow[i]=0;
	vector<int> vis(n);
	priority_queue<hlpp_node> q; q.push(hlpp_node(src, level[src]));
	hyper_flow[src] = inf;	// Դ����������  
	vis[src] = 1;
	while(!q.empty())
	{
		hlpp_node tp=q.top(); q.pop();
		int x=tp.x, h=tp.h;
		if(hyper_flow[x]==0) continue;	// �������Ϊ0ֱ�ӳ��� 
		for(int i=0; i<adj[x].size(); i++)
		{
			edge e = edges[adj[x][i]];
			int y = e.ed;
			if(level[x]!=level[y]+1 || e.val==0) continue;
			int flow = min(hyper_flow[x], e.val);
			hyper_flow[x]-=flow, hyper_flow[y]+=flow;	// ���³������� 
			edges[adj[x][i]].val-=flow, edges[edges[adj[x][i]].pair].val+=flow;	// ����ͼ
			if(y!=src && y!=dst && !vis[y]) q.push(hlpp_node(y, level[y])),vis[y]=1;// ����ԴĿ�㣬��������� 
			if(hyper_flow[x]==0) break;	// ���������˳� 
		}
		// ���������ʣ�� ��̧�� x �Ա��������� ����߹�Դ������� ���ٴ��� 
		if(hyper_flow[x]>0 && x!=dst && level[x]<n) 
		{
			relabel(x);	// ̧�� ������ھ���߶���Ϊ inf 
			q.push(hlpp_node(x, level[x]));	// ��ͼ�ٴ����� 
		}
	}
	
	ans = hyper_flow[dst];
	/*
	// ��ӡͼ��Ϣ 
	for(int i=0; i<edges.size(); i++) 
		cout<<edges[i].st<<" -> "<<edges[i].ed<<" val="<<edges[i].val<<endl;
	cout<<endl;
	*/
	//cout<<"�����:"<<ans<<endl;
}

/* ---------------------------------------------------------------------------- */

/* 
 *	@function add_edge : ���һ���߼��䷴���
 *	@param st		   : ��������
 *	@param ed		   : ������յ�
 *	@param val		   : �ߵ�Ȩֵ������������� 
 */
void add_edge(int st, int ed, int val)
{
	int ii=edges_.size();
	edges_.push_back(edge(st, ed, val, ii+1));
	edges_.push_back(edge(ed, st, 0, ii));
	adj[st].push_back(ii); adj[ed].push_back(ii+1);
}

/* 
 *	@function load_random_graph : �������ͼ
 *	@param doc_num				: ҽ����Ŀ doctor number
 *	@param hol_num				: ������Ŀ holiday number
 *	@param day_num				: ÿ�����ڰ����ļ�����Ŀ day number
 *	@param c					: ÿ��ҽ�����ֵ��c�� 
 */
void load_random_graph(int doc_num, int hol_num, int day_num, int c)
{
	int st, ed;
	n = 1 + doc_num + doc_num*hol_num + hol_num*day_num + 1;
	cout<<n<<endl;
	
	adj.resize(n);
	father.resize(n); 
	min_flow.resize(n);
	level.resize(n); 
	cur_arc.resize(n);
	dis_cnt.resize(n+1);
	hyper_flow.resize(n);
	edges_.clear();
	edges.clear();
	
	src=0, dst=n-1;
	for(int i=1; i<doc_num+1; i++)
	{
		st=src, ed=i; 
		add_edge(st, ed, c);
	}
	for(int i=1; i<doc_num+1; i++)
	{
		for(int j=0; j<hol_num; j++)
		{
			st=i, ed=1+doc_num+doc_num*j+(i-1);
			add_edge(st, ed, 1);
			st=ed;
			vector<int> select(day_num);
			for(int k=0; k<day_num/2+1; k++)
			{
				int id = rand()%day_num;
				// id = k;	// ��ͻ������ 
				if(select[id]==1){k--; continue;}
				select[id] = 1;
				ed = 1+doc_num+doc_num*hol_num+day_num*j+id;
				add_edge(st, ed, 1);
			} 
		}
	}
	for(int i=0; i<hol_num*day_num; i++)
	{
		st=1+doc_num+doc_num*hol_num+i, ed=dst;
		add_edge(st, ed, 1);
	}
	e = edges_.size();
	edges.resize(e);
}

/* 
 *	@function re_graph : ��ͼ�ָ�ΪĬ�����ɵ�ͼ 
 */
void re_graph()
{
	for(int i=0; i<e; i++) edges[i]=edges_[i];
}

void cin_graph()
{
	cin>>n>>e>>src>>dst;
	
	adj.resize(n);
	father.resize(n); 
	min_flow.resize(n);
	level.resize(n); 
	cur_arc.resize(n);
	dis_cnt.resize(n+1);
	hyper_flow.resize(n);
	
	for(int i=0; i<e; i++)
	{
		int st, ed, limit; cin>>st>>ed>>limit;
		add_edge(st, ed, limit);
	}
	e = edges_.size();
	edges.resize(e);
}

int main()
{
	//cin_graph();
	
	
	
	/*
	re_graph(); // ��ӡͼ��Ϣ 
	for(int i=0; i<edges.size(); i++) 
		cout<<edges[i].st<<" -> "<<edges[i].ed<<" val="<<edges[i].val<<endl;
	cout<<endl;
	*/
	
	double t1=0, t2=0, t3=0, t4=0, t5=0, t6=0;
	clock_t st,ed;
	
	#define BATCH 10
	#define SIZE_G 30
	int batch = BATCH;
	load_random_graph(SIZE_G, SIZE_G, SIZE_G, SIZE_G);
	while(batch--)
	{
		cout<<"�����������:"<<batch<<endl;
		
		re_graph(); 
		st = clock();
		EK();
		ed = clock();
		t1 += (double)(ed-st)/CLOCKS_PER_SEC;
		
		re_graph(); 
		st = clock();
		Dinic1();
		ed = clock();
		t2 += (double)(ed-st)/CLOCKS_PER_SEC;
		
		re_graph(); 
		st = clock();
		Dinic2();
		ed = clock();
		t3 += (double)(ed-st)/CLOCKS_PER_SEC;
		
		re_graph(); 
		st = clock();
		Dinic3();
		ed = clock();
		t4 += (double)(ed-st)/CLOCKS_PER_SEC;
		
		re_graph(); 
		st = clock();
		ISAP();
		ed = clock();
		t5 += (double)(ed-st)/CLOCKS_PER_SEC;
		
		re_graph(); 
		st = clock();
		HLPP(); 
		ed = clock();
		t6 += (double)(ed-st)/CLOCKS_PER_SEC;
		
		//re_graph(); EK();
		
		//re_graph(); Dinic1();	// ��ͨdinic 
			
		//re_graph(); Dinic2();	// Dinic+��ǰ���Ż� 
			
		//re_graph(); Dinic3();	// Dinic+��·���� 
		
		//re_graph(); ISAP();
		
		//re_graph(); HLPP();
		
		
	}
	
	cout<<t1/BATCH<<endl;
	cout<<t2/BATCH<<endl;
	cout<<t3/BATCH<<endl;
	cout<<t4/BATCH<<endl;
	cout<<t5/BATCH<<endl;
	cout<<t6/BATCH<<endl;
	
	return 0;
}

/*
6 7 0 5
0 2 2
0 1 2
1 4 1
2 4 5
2 3 2
3 5 1
4 5 2

7 11 0 6
0 1 3
0 3 3
1 2 4
2 0 3
2 3 1
2 4 2
3 4 2
3 5 6
4 1 1
4 6 1
5 6 9

*/
