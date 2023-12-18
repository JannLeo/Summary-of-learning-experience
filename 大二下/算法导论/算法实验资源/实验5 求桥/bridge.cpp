#include <bits/stdc++.h>

using namespace std;

/*
 *	@edge_hash : 边哈希函数 哈希set反取边及去重用 
 */
struct edge_hash
{
	size_t operator () (const vector<int> e1) const
	{
		int aa=(e1[0]<e1[1])?(e1[0]):(e1[1]), bb=(e1[0]>e1[1])?(e1[0]):(e1[1]);
		return aa*114 + bb;
	}	
};

/*
 *	@edge_cmp : 边比较函数 哈希set反取边及去重用
 */
struct edge_cmp
{
	bool operator () (const vector<int> e1, vector<int> e2) const
	{
		if(e1[0]==e2[0] && e1[1]==e2[1]) return true;
		if(e1[1]==e2[0] && e1[0]==e2[1]) return true;
		return false;
	}
};

int n, e, cut_v1=-1, cut_v2=-1;									// 顶点数 边数 切割点1/2 
vector<vector<int>> adj;										// 邻接表
vector<vector<int>> edges;										// 边集 
vector<int> vis;												// 访问控制数组 
vector<int> father;												// 并查集 
vector<int> dfn;												// 深度优先数 
vector<int> min_ancestor;										// 最小可达祖先
vector<int> lca;												// lca[x]表示集合x的最近公共祖先 
vector<vector<int>> query;										// 要查询lca的边 query[x]存储和x有关的查询 
unordered_set<vector<int>, edge_hash, edge_cmp> cir_edges;		// 环边的边集
vector<int> tree;												// lca生成树 
vector<int> depth;

void init_all()
{
	for(int i=0; i<n; i++) vis[i]=0,father[i]=i,dfn[i]=-1,min_ancestor[i]=-1;
	lca.clear(); lca.resize(n);
	query.clear(); query.resize(n);
	cir_edges.clear();
	cut_v1=-1, cut_v2=-1;
}

/*
 *	@function load_graph : 从指定文件读取图信息 
 *	@param filepath		 : 文件路径 
 *	@return 			  : ----
 */
void load_graph(string filepath)
{
	ifstream ifs(filepath);				// 打开文件流 
	streambuf *ori_in = cin.rdbuf();	//保存原来的输入输出方式
	cin.rdbuf(ifs.rdbuf());				// 流重定向 
	
	// 读取图数据 
	cin>>n>>e; 
	// 数据初始化 
	adj.clear(); adj.resize(n);
	edges.clear(); edges.resize(e);
	vis.resize(n); father.resize(n); dfn.resize(n); min_ancestor.resize(n); tree.resize(n); depth.resize(n);
	init_all();
	// cout<<n<<" "<<e<<endl; 
	for(int i=0; i<e; i++)
	{
		int v1,v2; cin>>v1>>v2;
		adj[v1].push_back(v2),adj[v2].push_back(v1);
		edges[i].push_back(v1),edges[i].push_back(v2);
		// cout<<v1<<" "<<v2<<endl;
	}
	
	ifs.close();						// 关闭流 
	cin.rdbuf(ori_in);	
}

// 加载任意图 
void load_random_graph(int _n, int _e)
{
	n=_n, e=_e;
	//default_random_engine rd(time(NULL));
	//uniform_int_distribution<int> dist(0, n-1);
	
	unordered_set<vector<int>, edge_hash, edge_cmp> hash;
	
	// 数据初始化 
	adj.clear(); adj.resize(n);
	edges.clear(); edges.resize(e);
	vis.resize(n); father.resize(n); dfn.resize(n); min_ancestor.resize(n); tree.resize(n); depth.resize(n); 
	init_all();
 
	for(int i=0; i<e; i++)
	{
		//int v1=dist(rd), v2=dist(rd); 
		int v1=rand()%n, v2=rand()%n;
		vector<int> ne{v1,v2};
		if(hash.find(ne)==hash.end() && v1!=v2) hash.insert(ne);
		else {i--; continue;}
		adj[v1].push_back(v2),adj[v2].push_back(v1);
		edges[i].push_back(v1),edges[i].push_back(v2);
	}
	// for(int i=0; i<e; i++) cout<<edges[i][0]<<" "<<edges[i][1]<<endl;
}

// 加载稠密图 
void load_dense_graph(int _n)
{
	n=_n, e=(n*(n-1))/2;
	
	// 数据初始化 
	adj.clear(); adj.resize(n);
	edges.clear(); //edges.resize(e);
	vis.resize(n); father.resize(n); dfn.resize(n); min_ancestor.resize(n); tree.resize(n); depth.resize(n);
	init_all();
 
	for(int i=0; i<n; i++)
	{
		for(int j=i+1; j<n; j++)
		{
			int v1=i, v2=j;
			adj[v1].push_back(v2),adj[v2].push_back(v1);
			edges.push_back(vector<int>{v1,v2});
			//edges[idx].push_back(v1),edges[idx].push_back(v2);
		}
	}
	// for(int i=0; i<e; i++) cout<<edges[i][0]<<" "<<edges[i][1]<<endl;
}

/*
 *	@function dfs : dfs
 *	@param start  : 起始顶点 
 *	@return 	  : ----
 *	@explain      : 如果边等于 cut_v1 -- cut_v2 则不走这条路 表示边被移除 
 */
void dfs(int start)
{
	vis[start]=1;
	for(int i=0; i<adj[start].size(); i++)
		if(vis[adj[start][i]]==0 &&
		   !(start==cut_v1 && adj[start][i]==cut_v2) &&
		   !(start==cut_v2 && adj[start][i]==cut_v1)) dfs(adj[start][i]);
}

/*
 *	@function visit_init : 初始化访问控制数组 
 *	@param 				 : ----
 *	@return 			 : ----
 */
void visit_init()
{
	for(int j=0; j<vis.size(); j++) vis[j]=0;
}

/*
 *	@function connection_count : 计算图连通分支数目 
 *	@param					   : ----
 *	@return 				   : 连通分支数目 
 */
int connection_count()
{
	int total=0;
	visit_init();											// 清除visit数组
	for(int i=0; i<n; i++) if(vis[i]==0) dfs(i),total++;	// 计算全图连通分支数 
	return total;
}

// -----------------------------------------------------------------------------//

/*
 *	@function bridge_basic : 基准算法暴力求桥 
 */
void bridge_basic()
{
	init_all();
	int before = connection_count();	// 记录初始图连通分支数目 
	for(int i=0; i<edges.size(); i++)
	{
		cut_v1=edges[i][0], cut_v2=edges[i][1];	// 记录切断边的顶点
		int after = connection_count();
		// 如果切断后连通分支增加 说明是桥 
		/*  
		if(after>before) cout<<cut_v1<<" -- "<<cut_v2<<" 是桥"<<endl;
		*/
	}
}

// -----------------------------------------------------------------------------//

/*
 *	@function disjointSets_init : 初始化并查集 
 *	@param 					    : ----
 *	@return 					: ----
 */
void disjointSets_init()
{
	for(int i=0; i<n; i++) father[i]=i;
}

/*
 *	@function disjointSets_find : 并查集 查找 
 *	@param x					: 要查找的节点x 
 *	@return 					: x所在集合的代表节点号（最终父节点）
 *	@explain					: 路径压缩策略使得均摊查后的找复杂度为O(1) 
 */
int disjointSets_find(int x)
{
	/*
	// 两种不同的路径压缩策略，适用于递归 / 非递归 
	if(father[x]==x) return x;
	int res = disjointSets_find(father[x]);
	father[x] = res;	// 路径压缩
	return res;
	*/
	while (father[x] != x) {
        father[x] = father[father[x]];
        x = father[x];
    }
    return x;
}

/*
 *	@function bridge_disjointSets : 基准法+并查集暴力求桥 
 *	@explain 					  : 和基准法不同的是求连通分支数 不用dfs而是并查集 
 */
void bridge_disjointSets()
{
	init_all();
	int before = connection_count();	// 记录初始图连通分支数目 
	for(int t=0; t<edges.size(); t++)
	{
		disjointSets_init();			// 并查集初始化 
		int cnt = n;
		for(int i=0; i<edges.size(); i++)
		{
			if(i==t) continue;			// 删除第t条边
			int f1=disjointSets_find(edges[i][0]), f2=disjointSets_find(edges[i][1]);
			if(f1!=f2) father[f1]=f2,cnt--;	// 合并两个集合 
		}	
		/*
		if(cnt>before) cout<<edges[t][0]<<" -- "<<edges[t][1]<<" 是桥"<<endl;
		*/
	}
}

// -----------------------------------------------------------------------------//

/*
 *	@function dfs_getTree : dfs得到生成树 
 *	@param cur			  : 当前节点 
 *	@param pre			  : 前一个节点 
 *	@param t			  : 生成树边集
 *	@return 			  : ----
 *	@explain			  : 第一次调用 pre传入-1 
 *						  : 在具有多个连通分支的图，需多次调用该函数才能得到完整生成树 
 */
void dfs_getTree(int cur, int pre, vector<vector<int>>& t)
{
	if(pre!=-1) t.push_back(vector<int>{pre,cur});
	vis[cur]=1;
	for(int i=0; i<adj[cur].size(); i++)
		if(vis[adj[cur][i]]==0) dfs_getTree(adj[cur][i], cur, t);
}

/*
 *	@function bridge_basic_tree : 基准算法暴力求桥 + 生成树优化 
 */
void bridge_basic_tree()
{
	init_all();
	int before = connection_count();	// 记录初始图连通分支数目
	visit_init();
	vector<vector<int>> tree_edges;
	// 获得生成树边集 
	for(int i=0; i<n; i++) if(vis[i]==0) dfs_getTree(i, -1, tree_edges); 
	// 只删除边集中的边 
	for(int i=0; i<tree_edges.size(); i++)
	{
		cut_v1=tree_edges[i][0], cut_v2=tree_edges[i][1];	// 记录切断边的顶点
		int after = connection_count();
		// 如果切断后连通分支增加 说明是桥 
		/*
		if(after>before) cout<<cut_v1<<" -- "<<cut_v2<<" 是桥"<<endl;
		*/
	}
}

// -----------------------------------------------------------------------------//

/*
 *	判断v1v2是否是同一条边 
 */
bool vec2eq(vector<int>& v1, vector<int>& v2)
{
	if(v1[0]==v2[0] && v1[1]==v2[1]) return true;
	if(v1[1]==v2[0] && v1[0]==v2[1]) return true;
	return false;
}

/*
 *	@function bridge_disjointSets_tree : 基准法+并查集暴力求桥 + 生成树优化 
 *	@explain 					  	   : 和基准法不同的是求连通分支数 不用dfs而是并查集 
 */
void bridge_disjointSets_tree()
{
	init_all();
	int before = connection_count();	// 记录初始图连通分支数目
	visit_init();
	vector<vector<int>> tree_edges;
	// 获得生成树边集 
	for(int i=0; i<n; i++) if(vis[i]==0) dfs_getTree(i, -1, tree_edges); 
	for(int t=0; t<tree_edges.size(); t++)
	{
		disjointSets_init();			// 并查集初始化 
		int cnt = n;
		for(int i=0; i<edges.size(); i++)
		{
			if(vec2eq(tree_edges[t], edges[i])) continue;	// 删除第t条边
			int f1=disjointSets_find(edges[i][0]), f2=disjointSets_find(edges[i][1]);
			if(f1!=f2) father[f1]=f2, cnt--;	// 合并两个集合 
		}
		/*
		if(cnt>before) cout<<tree_edges[t][0]<<" -- "<<tree_edges[t][1]<<" 是桥"<<endl;
		*/
	}
}

// -----------------------------------------------------------------------------//

/*
 *	@function dfs_tarjan : 求解节点x的最小可达祖先 
 *	@param x			 : 要求解的节点x 
 *	@param direct_father : x的直接父节点 
 *	@param depth		 : 当前dfs的步数 即x节点的深度优先数dfn[x]
 *	@return 			 : ---- 
 */
void dfs_tarjan(int x, int direct_father, int depth)
{
	dfn[x] = min_ancestor[x] = depth;	// min_ancestor初始值=dfn 
	for(int i=0; i<adj[x].size(); i++)
	{
		int child = adj[x][i];
		if(dfn[child]==-1)	// child是子孙节点 问题x的答案可能来自于问题child 
		{
			dfs_tarjan(child, x, depth+1);	// 先求解 min_ancestor[child]
			min_ancestor[x] = min(min_ancestor[x], min_ancestor[child]);
		}
		else if(child!=direct_father)		// 如果child是祖先节点 尝试更新答案 
		{
			min_ancestor[x] = min(min_ancestor[x], dfn[child]);
		}
	}
}

/*
 *	@function bridge_disjointSets_tree : tarjan算法求桥 
 *	@explain 					  	   : ---- 
 */
void bridge_tarjan()
{
	init_all();

	for(int i=0; i<n; i++)
		if(dfn[i]==-1) dfs_tarjan(i, -1, 0);
		
	for(int i=0; i<n; i++)
	{
		for(int j=0; j<adj[i].size(); j++)
		{
			int child = adj[i][j];
			/*
			if(dfn[i]<min_ancestor[child]) 
				cout<<i<<" -- "<<child<<" 是桥"<<endl;
			*/
		}
	}
}

// -----------------------------------------------------------------------------//

/*
 *	@function dfs_getTree_relation : 获得dfs生成树关系数组tree 
 *	@param start				   : dfs当前起点 
 *	@param direct_father		   : start的直接父节点 
 */
void dfs_getTree_relation(int start, int direct_father)
{
	vis[start]=1; tree[start]=direct_father;
	for(int i=0; i<adj[start].size(); i++)
		if(vis[adj[start][i]]==0) dfs_getTree_relation(adj[start][i], start);
}

/*
 *	@function mark_cirEdges : 从src出发到dest 沿途标记环边 无压缩策略 
 *	@param src				: 起点 
 *	@param dest				: 终点 
 *	@explain				: 必须在 dfs_getTree_relation 建立树关系后使用该函数 
 */
void mark_cirEdges(int src, int dest)
{
	int cur=src, pre=-1;
	while(cur!=dest)
	{
		vector<int> ce{pre,cur};
		if(pre!=-1) cir_edges.insert(ce);
		pre=cur; cur=tree[cur];
	}
	if(pre!=cur && pre!=-1) cir_edges.insert(vector<int>{pre,cur});
}

/*
 *	@function dfs_lca : tarjan算法求解【start点及其所有子树】内点对的lca 
 *	@param start	  : tarjan算法以dfs为模板进行 
 *	@explain		  : vis[x]=1表示x正在计算 
 *					  : vis[x]=2表示x及其所有子树计算完毕 
 *					  : 计算中的节点x 其并查集属于x（即自成集合）
 *					  : 计算完毕节点x 其并查集归并到其父节点（通过后序递归实现）  
 */

// 边dfs边生成树边 
unordered_set<vector<int>, edge_hash, edge_cmp> tree_edges;
void dfs_lca(int start)
{
	vis[start]=1;	
	father[start] = start;
	for(int i=0; i<adj[start].size(); i++)
	{
		int child = adj[start][i];
		if(vis[child]==0)
		{
			tree_edges.insert(vector<int>{start, child});
			dfs_lca(child);
			int f2 = disjointSets_find(child);
			father[f2] = start;	// child及其所有子树计算完毕 将child绑定到start上 
		} 
	}
	// start点及其所有子树均计算完毕 开始处理与start相关的query 
	for(int i=0; i<adj[start].size(); i++)
	{
		int another = adj[start][i];
		if(vis[another]==1 && tree_edges.find(vector<int>{start, another})==tree_edges.end())
		{
			int f2 = disjointSets_find(another);
			// 沿途标记环边 -- 无压缩 暴力标记 
			mark_cirEdges(start, f2), mark_cirEdges(another, f2);
			cir_edges.insert(vector<int>{start, another});	// 本身也是环边 	
		}
	}
}

/*	-std=c++11
 *	@function bridge_bcj_lca : 并查集+求lca -> 求环边 -> 求桥 
 *	@explain 			     : ---- 
 */
void bridge_bcj_lca()
{
	init_all();
	
	// 获得生成树关系数组
	visit_init();
	for(int i=0; i<n; i++) if(vis[i]==0) dfs_getTree_relation(i, i);
	
	//cout<<1<<endl;
	// 获得生成树边集 
	visit_init();
	vector<vector<int>> tree_edges;
	for(int i=0; i<n; i++) if(vis[i]==0) dfs_getTree(i, -1, tree_edges); 
	//cout<<2<<endl;
	// 获得边集 query 即lca要查询的边
	unordered_set<vector<int>, edge_hash, edge_cmp> hash(tree_edges.begin(), tree_edges.end());	
	for(int i=0; i<e; i++)
		if(hash.find(edges[i])==hash.end()) 
			query[edges[i][0]].push_back(edges[i][1]), query[edges[i][1]].push_back(edges[i][0]);
	//cout<<3<<endl;
	
	// 计算所有query的lca 并且将重边上两点到公共祖先的路径上的边全部标记为环边 
	visit_init(); disjointSets_init();
	for(int i=0; i<n; i++) if(vis[i]==0) dfs_lca(i);
		
	// 根据环边反选桥 
	/*
	for(int i=0; i<e; i++)
		if(cir_edges.find(edges[i])==cir_edges.end())
			cout<<edges[i][0]<<" -- "<<edges[i][1]<<" 是桥"<<endl;
	*/	
}

// -----------------------------------------------------------------------------//

/* 
 *	@function dfs_getTree_relation_dep : 带深度生成的dfs 
 *	@param start					   : 当前节点 
 *	@param direct_father			   : 当前节点的直接父节点
 *	@param d						   : 当前节点深度
 *	@explain						   : 同时生成生成树 
 */
void dfs_getTree_relation_dep(int start, int direct_father, int d)
{
	vis[start]=1; tree[start]=direct_father; depth[start]=d;
	for(int i=0; i<adj[start].size(); i++)
		if(vis[adj[start][i]]==0) dfs_getTree_relation_dep(adj[start][i], start, d+1);
}

/*	
 *	@function bridge_bcj_lca : lca求环边 + 路径压缩 
 *	@explain 			     : ---- 
 */
int tcnt=0;
void bridge_bcj_lca2()
{
	init_all();
	// 生成生成树 
	for(int i=0; i<n; i++) if(vis[i]==0) dfs_getTree_relation_dep(i, i, 0); 
	visit_init();
	for(int i=0; i<n; i++) tree_edges.insert(vector<int>{tree[i],i});
	for(int i=0; i<edges.size(); i++)
	{
		if(tree_edges.find(edges[i])==tree_edges.end())
		{
			int p1=edges[i][0], p2=edges[i][1], pre,pre1,pre2;
			cir_edges.insert(vector<int>{p1, p2});	// 标记边 
			if(depth[p1]<depth[p2]) swap(p1, p2);	// 默认p1为深的点 
			while(depth[p1]>depth[p2]) 				// 同步高度 
				pre1=p1,p1=tree[p1],cir_edges.insert(vector<int>{pre1, p1});
			while(tree[p1]!=tree[p2])				// 找lca 
			{
				pre1=p1, pre2=p2;
				p1=tree[p1], p2=tree[p2];
				cir_edges.insert(vector<int>{pre1, p1});
				cir_edges.insert(vector<int>{pre2, p2});
			}
			// 压缩策略 沿途将路径上所有点挂到lca上 
			int lca = tree[p1];
			p1=edges[i][0], p2=edges[i][1];
			while(tree[p1] != lca)
			{
				int pf = tree[p1];
				tree[p1] = lca;
				depth[p1] = depth[lca] + 1;
				p1 = pf;
			}
			while(tree[p2] != lca)
			{
				int pf = tree[p2];
				tree[p2] = lca;
				depth[p2] = depth[lca] + 1;
				p2 = pf;
			}
			//tcnt++;	// 调试进度 
			// if(tcnt%100000==0) cout<<tcnt<<endl;
		}
	}
	/*
	for(int i=0; i<e; i++)
		if(cir_edges.find(edges[i])==cir_edges.end())
			cout<<edges[i][0]<<" -- "<<edges[i][1]<<" 是桥"<<endl;
	*/
}

int main()
{
	/* 所有的随机数据都是 1.无自环 2.无重边 的 */
	
	#define batch 1 
	#define v_num 300 
	int _batch = batch;
	
	double t1=0,t2=0,t3=0,t4=0,t5=0,t6=0,t7=0;
	clock_t st, ed;
	
	while(_batch--)
	{
		load_graph("largeG.txt");
		
		// load_random_graph(v_num, v_num-7);
		
		// load_dense_graph(v_num);
		
		cout<<"数据生成完毕:"<<_batch<<endl;
		
		// 基准 
		st = clock();	
		//bridge_basic();					
		ed = clock();
		t1 += (double)(ed-st)/CLOCKS_PER_SEC;
		
		// 基准+并查集
		st = clock();
		//bridge_disjointSets();			 
		ed = clock();
		t2 += (double)(ed-st)/CLOCKS_PER_SEC;
		
		// 基准+生成树优化 
		st = clock();
		//bridge_basic_tree();				
		ed = clock();
		t3 += (double)(ed-st)/CLOCKS_PER_SEC;
		
		// 基准+并查集+生成树优化 
		st = clock();
		//bridge_disjointSets_tree();		
		ed = clock();
		t4 += (double)(ed-st)/CLOCKS_PER_SEC;
		
		// tarjan算法求桥
		st = clock();
		//bridge_tarjan();					 
		ed = clock();
		t5 += (double)(ed-st)/CLOCKS_PER_SEC;
		
		// lca求环边求桥 
		st = clock();
		//bridge_bcj_lca();
		ed = clock();
		t6 += (double)(ed-st)/CLOCKS_PER_SEC;
		
		// lca求环边求桥 +压缩 
		st = clock();
		bridge_bcj_lca2();
		ed = clock();
		t7 += (double)(ed-st)/CLOCKS_PER_SEC;
	}
	
	cout<<t1/batch<<endl;
	cout<<t2/batch<<endl;
	cout<<t3/batch<<endl;
	cout<<t4/batch<<endl;
	cout<<t5/batch<<endl;
	cout<<t6/batch<<endl;
	cout<<t7/batch<<endl; 
	
	/* 如果输出结果为空则说明无桥 */
	
	return 0;
}

/*
样例输入1 
6
7
0 1
0 2
1 2
2 3
3 4
3 5
4 5

样例输出1 
2 -- 3 是桥 

样例输入2
16
15
0 1
2 3
2 6
6 7
4 8
4 9
8 9
8 13
9 10
9 13
10 11
10 14
11 15
12 13
14 15

样例输出2
0 -- 1 是桥
2 -- 3 是桥
2 -- 6 是桥
6 -- 7 是桥
9 -- 10 是桥
12 -- 13 是桥
 
10
16
6 3
9 7
4 7
2 5
3 1
9 4
5 6
1 9
4 3
4 6
7 1
7 0
4 0
6 8
1 0
8 0
*/
