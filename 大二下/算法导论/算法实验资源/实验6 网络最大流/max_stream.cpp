#include <bits/stdc++.h>

using namespace std;

#define inf 1145141919

typedef struct edge
{
	int st, ed, val, pair;	// 起点, 终点, 还能通过多少流量, 反向边下标 
	edge(){}
	edge(int a, int b, int c, int d){st=a;ed=b;val=c;pair=d;}	
}edge;

int n,e,src,dst,ans;		// 顶点数, 初始边数, 源, 目, 答案 
vector<vector<int>> adj;	// adj[x][i]表示从x出发的第i条边在边集合中的下标 
vector<edge> edges;			// 边集合 
vector<edge> edges_;		// 原始数据 因为每次边要增广所以重复计算时要初始化边 
vector<int> min_flow;		// min_flow[x]表示从起点到x的路径中最细流 
vector<int> father;			// 生成树 
vector<int> level;			// 层次 
vector<int> cur_arc;		// 当前弧优化数组
vector<int> dis_cnt;		// 距离计数器 
vector<int> hyper_flow;		// 超额流量 


/* ---------------------------------------------------------------------------- */

/*
 *	@function bfs_augment : bfs找最短增广路径 
 *	@param				  : ----
 *	@return 			  : 如果找到则return true否则false 
 *	@pexlain			  : father建生成树 min_flow更新节点最细流 
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
 *	@function graph_update : 根据bfs_augment的生成树father[]更新图 
 *	@param				   : ----
 *	@return 			   : ----
 *	@explain			   : 需要在bfs_augment之后使用 
 */
void graph_update()
{
	int x, y=dst, flow=min_flow[dst], i;
	//cout<<"更新流量: "<<flow<<" 路径: ";
	ans += flow;
	vector<int> path;
	while(y!=src)	// 沿着生成树找起点并沿途更新边 
	{
		path.push_back(y);
		x = father[y];
		for(i=0; i<adj[x].size(); i++) if(edges[adj[x][i]].ed==y) break;	
		edges[adj[x][i]].val -= flow;
		edges[edges[adj[x][i]].pair].val += flow;	// 更新另一半的边 
		y = x;
	}
	/* 
	path.push_back(y);
	for(int i=path.size()-1; i>=0; i--) cout<<path[i]<<" "; cout<<endl;
	*/ 
}

/*
 *	@function EK : Edmonds-Karp算法求最大流 
 */
void EK()
{
	ans = 0;
	while(1)
	{
		if(!bfs_augment()) break;
		graph_update();
		/* 
		// 打印图信息
		for(int i=0; i<edges.size(); i++) 
			cout<<edges[i].st<<" -> "<<edges[i].ed<<" val="<<edges[i].val<<endl;
		cout<<endl;
		*/ 
	}
	//cout<<"最大流:"<<ans<<endl;
}

/* ---------------------------------------------------------------------------- */

/*
 *	@function bfs_level : 层次遍历标记节点层数 
 *	@param				: ----
 *	@return 			；如果找到终点return true 否则false 
 *	@explain			: ----
 */
bool bfs_level()
{
	for(int i=0; i<n; i++) level[i]=-1;
	level[src] = 0;	// 起始节点第0层 
	
	queue<int> q; q.push(src);
	int lv = 0;		// bfs层次数 
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
	father[x] = 1;	// father充当访问控制数组 
	for(int i=0; i<adj[x].size(); i++)
	{
		edge e = edges[adj[x][i]];
		int y = e.ed;
		if(father[y]!=-1 || e.val==0 || level[y]!=level[x]+1) continue;
		path.push_back(adj[x][i]);	// path记录经过的边的下标 
		min_flow[y] = min(e.val, min_flow[x]);
		// 找到则更新所有路径上的边 
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
 *	@function dfs_dinic1 : 普通Dinic算法 往x节点塞入flow流量 并且尝试分配下去 
 *	@param x			 : 当前节点 
 *	@param flow			 : 要向x分配多少流量（最大可用值） 
 *	@return 			 : 节点x实际向下分配了多少流量  
 *	@explain			 : 一旦找到立即返回 一次找一条 
 *						 : 使用father数组作为访问控制visit数组 
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
		if(res!=0) return res;	// 找到直接返回 
	}
	return 0;	// 没找到则返回0 
} 

/*
 *	@function Dinic1 : 普通Dinic算法求最大流 
 *	@explain		 : 用level数组做层次标记数组 层次逐渐增加 
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
			if(res==0) break;	// 找不到增广路 需要重新bfs更新层次 
			ans += res;
		}
		
		/* 
		// 打印图信息 
		for(int i=0; i<edges.size(); i++) 
			cout<<edges[i].st<<" -> "<<edges[i].ed<<" val="<<edges[i].val<<endl;
		cout<<endl;
		*/ 
	}
	//cout<<"最大流:"<<ans<<endl;
}

/*
 *	@function dfs_dinic2 : Dinic + 当前弧优化 
 *	@param x			 : 当前节点 
 *	@param flow			 : 要向x分配多少流量（最大可用值） 
 *	@return 			 : 节点x实际向下分配了多少流量  
 *	@explain			 : 一旦找到立即返回 一次找一条 
 *						 : 使用father数组作为访问控制visit数组 
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
		if(res!=0) return res;	// 找到直接返回 
	}
	return 0;	// 没找到则返回0 
} 

/*
 *	@function Dinic2 : Dinic + 当前弧优化 
 *	@explain		 : 用level数组做层次标记数组 层次逐渐增加 
 */
void Dinic2()
{
	ans = 0;
	while(bfs_level())
	{
		// 当前弧重置 
		for(int i=0; i<n; i++) cur_arc[i]=0;
		while(1)
		{
			for(int i=0; i<n; i++) father[i]=0;	// 每次dfs更新visit数组 
			int res = dfs_dinic2(src, inf);
			if(res==0) break;	// 找不到增广路 需要重新bfs更新层次 
			ans += res;
		}
		
		/* 
		// 打印图信息 
		for(int i=0; i<edges.size(); i++) 
			cout<<edges[i].st<<" -> "<<edges[i].ed<<" val="<<edges[i].val<<endl;
		cout<<endl;
		*/ 
	}
	//cout<<"最大流:"<<ans<<endl;
}

/*
 *	@function dfs_dinic1 : Dinic + 多路增广
 *	@param x			 : 当前节点 
 *	@param flow			 : 要向x分配多少流量（最大可用值） 
 *	@return 			 : 节点x实际向下分配了多少流量  
 *	@explain			 : 一次找完所有路径 
 */
int dfs_dinic3(int x, int flow)
{
	if(x==dst) return flow;
	int temp_flow = flow;	// 记录能分配的最大值 
	for(int i=0; i<adj[x].size(); i++)
	{
		edge e = edges[adj[x][i]];
		int y = e.ed;
		if(e.val==0 || level[y]!=level[x]+1) continue;
		int res = dfs_dinic3(y, min(flow, e.val));
		edges[adj[x][i]].val-=res, edges[edges[adj[x][i]].pair].val+=res;
		flow-=res;	// 更新可用流量 
		if(flow==0) return temp_flow;	// 如果分完了就结束  
	}
	return temp_flow-flow;	// 返回实际分配的  
} 

/*
 *	@function Dinic1 : Dinic算法 + 多路增广 
 *	@explain		 : 用level数组做层次标记数组 层次逐渐增加 
 */
void Dinic3()
{
	ans = 0;
	while(bfs_level())
	{
		ans += dfs_dinic3(src, inf);	// dfs层次图以更新边 
		/* 
		// 打印图信息 
		for(int i=0; i<edges.size(); i++) 
			cout<<edges[i].st<<" -> "<<edges[i].ed<<" val="<<edges[i].val<<endl;
		cout<<endl;
		*/ 
	}
	//cout<<"最大流:"<<ans<<endl;
}

/* ---------------------------------------------------------------------------- */

/*
 *	@function dfs_ISAP : 在层次图中向下分配流量 往x节点塞入flow流量 并且尝试分配下去 
 *	@param x		   : 当前节点 
 *	@param flow		   : 要向x分配多少流量（最大可用值） 
 *	@return 		   : 节点x实际向下分配了多少流量  
 *	@explain		   : 和Dinic类似 只是边bfs边更新层次 
 */
bool ISAP_flag = false;
int dfs_ISAP(int x, int flow)
{
	if(x==dst) return flow;
	int temp_flow = flow;	// temp_flow保存这个点拥有的流量	
	for(int i=0; i<adj[x].size(); i++)	
	{
		edge e = edges[adj[x][i]];
		int y = e.ed;
		if(level[x]!=level[y]+1 || e.val==0) continue;
		int res = dfs_ISAP(y, min(e.val, flow));
		edges[adj[x][i]].val-=res, edges[edges[adj[x][i]].pair].val+=res;	// 退栈时更新图 
		flow -= res;	// 分配了res流量给某个分支 
		if(flow==0) return temp_flow;	// 分配完了则返回 
	}
	dis_cnt[level[x]]--;	// 计算新距离计数 
	if(dis_cnt[level[x]]==0) ISAP_flag=true;	// 出现断层就提前结束 
	level[x]++;			// 已经分配完所子节点 不存在和刚一样长度增广路径 路径长度严格连续增加 
	dis_cnt[level[x]]++;	// 计算新距离计数 
	return temp_flow-flow;	// 返回已经分配的流量数目 
}

/*
 *	@function ISAP : ISAP 
 *	@explain	   : 用level数组做距离标记数组，距离逐渐减少 
 				   : 引入当前弧优化和gap优化 
 */
void ISAP()
{
	bfs_level();
	// 层次数组变为距离数组 
	int mlv = *max_element(level.begin(), level.end());
	for(int i=0; i<n; i++) level[i]=mlv-level[i], dis_cnt[i]=0;
	// 距离计数数组计算初始值 
	for(int i=0; i<n; i++) dis_cnt[level[i]]++;
	
	ans=0; ISAP_flag=false;
	while(level[src]<n && !ISAP_flag)
	{
		ans+=dfs_ISAP(src, inf);
		if(ISAP_flag) break;	
	} 
	
	/*
	// 打印图信息 
	for(int i=0; i<edges.size(); i++) 
		cout<<edges[i].st<<" -> "<<edges[i].ed<<" val="<<edges[i].val<<endl;
	cout<<endl;
	*/ 
	//cout<<"最大流:"<<ans<<endl;
}

/* ---------------------------------------------------------------------------- */

typedef struct hlpp_node
{
	int x, h;
	hlpp_node(int a, int b){x=a; h=b;}
	bool operator < (const hlpp_node& n2)const{return h<n2.h;}
}hlpp_node;

/*
 *	@function relabel : 重新标记高度 
 *	@param x		  : 重新标记x点的高度 高度为邻接点之中最低的+1 
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
 *	@function HLPP : 最高标号预流推进 
 *	@param		   : ----
 *	@return		   : ----
 *	@explain	   : 时间复杂度上界为 O(n^2 * sqrt(e)) 卡的比较紧 
 */
void HLPP()
{
	bfs_level();
	// 层次数组变为距离数组 
	int mlv = *max_element(level.begin(), level.end());
	for(int i=0; i<n; i++) level[i]=mlv-level[i], dis_cnt[i]=0, hyper_flow[i]=0;
	vector<int> vis(n);
	priority_queue<hlpp_node> q; q.push(hlpp_node(src, level[src]));
	hyper_flow[src] = inf;	// 源点无限流量  
	vis[src] = 1;
	while(!q.empty())
	{
		hlpp_node tp=q.top(); q.pop();
		int x=tp.x, h=tp.h;
		if(hyper_flow[x]==0) continue;	// 如果流量为0直接出队 
		for(int i=0; i<adj[x].size(); i++)
		{
			edge e = edges[adj[x][i]];
			int y = e.ed;
			if(level[x]!=level[y]+1 || e.val==0) continue;
			int flow = min(hyper_flow[x], e.val);
			hyper_flow[x]-=flow, hyper_flow[y]+=flow;	// 更新超额流量 
			edges[adj[x][i]].val-=flow, edges[edges[adj[x][i]].pair].val+=flow;	// 更新图
			if(y!=src && y!=dst && !vis[y]) q.push(hlpp_node(y, level[y])),vis[y]=1;// 不是源目点，则继续流出 
			if(hyper_flow[x]==0) break;	// 流完了则退出 
		}
		// 如果流量有剩余 则抬高 x 以便更多的流出 如果高过源点则回流 不再处理 
		if(hyper_flow[x]>0 && x!=dst && level[x]<n) 
		{
			relabel(x);	// 抬高 如果无邻居则高度设为 inf 
			q.push(hlpp_node(x, level[x]));	// 试图再次流出 
		}
	}
	
	ans = hyper_flow[dst];
	/*
	// 打印图信息 
	for(int i=0; i<edges.size(); i++) 
		cout<<edges[i].st<<" -> "<<edges[i].ed<<" val="<<edges[i].val<<endl;
	cout<<endl;
	*/
	//cout<<"最大流:"<<ans<<endl;
}

/* ---------------------------------------------------------------------------- */

/* 
 *	@function add_edge : 添加一条边及其反向边
 *	@param st		   : 正向边起点
 *	@param ed		   : 正向边终点
 *	@param val		   : 边的权值（最大允许流量 
 */
void add_edge(int st, int ed, int val)
{
	int ii=edges_.size();
	edges_.push_back(edge(st, ed, val, ii+1));
	edges_.push_back(edge(ed, st, 0, ii));
	adj[st].push_back(ii); adj[ed].push_back(ii+1);
}

/* 
 *	@function load_random_graph : 随机生成图
 *	@param doc_num				: 医生数目 doctor number
 *	@param hol_num				: 假期数目 holiday number
 *	@param day_num				: 每个假期包含的假日数目 day number
 *	@param c					: 每个医生最多值班c天 
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
				// id = k;	// 冲突测试用 
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
 *	@function re_graph : 将图恢复为默认生成的图 
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
	re_graph(); // 打印图信息 
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
		cout<<"数据生成完毕:"<<batch<<endl;
		
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
		
		//re_graph(); Dinic1();	// 普通dinic 
			
		//re_graph(); Dinic2();	// Dinic+当前弧优化 
			
		//re_graph(); Dinic3();	// Dinic+多路增广 
		
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
