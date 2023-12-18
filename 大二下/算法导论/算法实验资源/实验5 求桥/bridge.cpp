#include <bits/stdc++.h>

using namespace std;

/*
 *	@edge_hash : �߹�ϣ���� ��ϣset��ȡ�߼�ȥ���� 
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
 *	@edge_cmp : �߱ȽϺ��� ��ϣset��ȡ�߼�ȥ����
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

int n, e, cut_v1=-1, cut_v2=-1;									// ������ ���� �и��1/2 
vector<vector<int>> adj;										// �ڽӱ�
vector<vector<int>> edges;										// �߼� 
vector<int> vis;												// ���ʿ������� 
vector<int> father;												// ���鼯 
vector<int> dfn;												// ��������� 
vector<int> min_ancestor;										// ��С�ɴ�����
vector<int> lca;												// lca[x]��ʾ����x������������� 
vector<vector<int>> query;										// Ҫ��ѯlca�ı� query[x]�洢��x�йصĲ�ѯ 
unordered_set<vector<int>, edge_hash, edge_cmp> cir_edges;		// ���ߵı߼�
vector<int> tree;												// lca������ 
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
 *	@function load_graph : ��ָ���ļ���ȡͼ��Ϣ 
 *	@param filepath		 : �ļ�·�� 
 *	@return 			  : ----
 */
void load_graph(string filepath)
{
	ifstream ifs(filepath);				// ���ļ��� 
	streambuf *ori_in = cin.rdbuf();	//����ԭ�������������ʽ
	cin.rdbuf(ifs.rdbuf());				// ���ض��� 
	
	// ��ȡͼ���� 
	cin>>n>>e; 
	// ���ݳ�ʼ�� 
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
	
	ifs.close();						// �ر��� 
	cin.rdbuf(ori_in);	
}

// ��������ͼ 
void load_random_graph(int _n, int _e)
{
	n=_n, e=_e;
	//default_random_engine rd(time(NULL));
	//uniform_int_distribution<int> dist(0, n-1);
	
	unordered_set<vector<int>, edge_hash, edge_cmp> hash;
	
	// ���ݳ�ʼ�� 
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

// ���س���ͼ 
void load_dense_graph(int _n)
{
	n=_n, e=(n*(n-1))/2;
	
	// ���ݳ�ʼ�� 
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
 *	@param start  : ��ʼ���� 
 *	@return 	  : ----
 *	@explain      : ����ߵ��� cut_v1 -- cut_v2 ��������· ��ʾ�߱��Ƴ� 
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
 *	@function visit_init : ��ʼ�����ʿ������� 
 *	@param 				 : ----
 *	@return 			 : ----
 */
void visit_init()
{
	for(int j=0; j<vis.size(); j++) vis[j]=0;
}

/*
 *	@function connection_count : ����ͼ��ͨ��֧��Ŀ 
 *	@param					   : ----
 *	@return 				   : ��ͨ��֧��Ŀ 
 */
int connection_count()
{
	int total=0;
	visit_init();											// ���visit����
	for(int i=0; i<n; i++) if(vis[i]==0) dfs(i),total++;	// ����ȫͼ��ͨ��֧�� 
	return total;
}

// -----------------------------------------------------------------------------//

/*
 *	@function bridge_basic : ��׼�㷨�������� 
 */
void bridge_basic()
{
	init_all();
	int before = connection_count();	// ��¼��ʼͼ��ͨ��֧��Ŀ 
	for(int i=0; i<edges.size(); i++)
	{
		cut_v1=edges[i][0], cut_v2=edges[i][1];	// ��¼�жϱߵĶ���
		int after = connection_count();
		// ����жϺ���ͨ��֧���� ˵������ 
		/*  
		if(after>before) cout<<cut_v1<<" -- "<<cut_v2<<" ����"<<endl;
		*/
	}
}

// -----------------------------------------------------------------------------//

/*
 *	@function disjointSets_init : ��ʼ�����鼯 
 *	@param 					    : ----
 *	@return 					: ----
 */
void disjointSets_init()
{
	for(int i=0; i<n; i++) father[i]=i;
}

/*
 *	@function disjointSets_find : ���鼯 ���� 
 *	@param x					: Ҫ���ҵĽڵ�x 
 *	@return 					: x���ڼ��ϵĴ���ڵ�ţ����ո��ڵ㣩
 *	@explain					: ·��ѹ������ʹ�þ�̯�����Ҹ��Ӷ�ΪO(1) 
 */
int disjointSets_find(int x)
{
	/*
	// ���ֲ�ͬ��·��ѹ�����ԣ������ڵݹ� / �ǵݹ� 
	if(father[x]==x) return x;
	int res = disjointSets_find(father[x]);
	father[x] = res;	// ·��ѹ��
	return res;
	*/
	while (father[x] != x) {
        father[x] = father[father[x]];
        x = father[x];
    }
    return x;
}

/*
 *	@function bridge_disjointSets : ��׼��+���鼯�������� 
 *	@explain 					  : �ͻ�׼����ͬ��������ͨ��֧�� ����dfs���ǲ��鼯 
 */
void bridge_disjointSets()
{
	init_all();
	int before = connection_count();	// ��¼��ʼͼ��ͨ��֧��Ŀ 
	for(int t=0; t<edges.size(); t++)
	{
		disjointSets_init();			// ���鼯��ʼ�� 
		int cnt = n;
		for(int i=0; i<edges.size(); i++)
		{
			if(i==t) continue;			// ɾ����t����
			int f1=disjointSets_find(edges[i][0]), f2=disjointSets_find(edges[i][1]);
			if(f1!=f2) father[f1]=f2,cnt--;	// �ϲ��������� 
		}	
		/*
		if(cnt>before) cout<<edges[t][0]<<" -- "<<edges[t][1]<<" ����"<<endl;
		*/
	}
}

// -----------------------------------------------------------------------------//

/*
 *	@function dfs_getTree : dfs�õ������� 
 *	@param cur			  : ��ǰ�ڵ� 
 *	@param pre			  : ǰһ���ڵ� 
 *	@param t			  : �������߼�
 *	@return 			  : ----
 *	@explain			  : ��һ�ε��� pre����-1 
 *						  : �ھ��ж����ͨ��֧��ͼ�����ε��øú������ܵõ����������� 
 */
void dfs_getTree(int cur, int pre, vector<vector<int>>& t)
{
	if(pre!=-1) t.push_back(vector<int>{pre,cur});
	vis[cur]=1;
	for(int i=0; i<adj[cur].size(); i++)
		if(vis[adj[cur][i]]==0) dfs_getTree(adj[cur][i], cur, t);
}

/*
 *	@function bridge_basic_tree : ��׼�㷨�������� + �������Ż� 
 */
void bridge_basic_tree()
{
	init_all();
	int before = connection_count();	// ��¼��ʼͼ��ͨ��֧��Ŀ
	visit_init();
	vector<vector<int>> tree_edges;
	// ����������߼� 
	for(int i=0; i<n; i++) if(vis[i]==0) dfs_getTree(i, -1, tree_edges); 
	// ֻɾ���߼��еı� 
	for(int i=0; i<tree_edges.size(); i++)
	{
		cut_v1=tree_edges[i][0], cut_v2=tree_edges[i][1];	// ��¼�жϱߵĶ���
		int after = connection_count();
		// ����жϺ���ͨ��֧���� ˵������ 
		/*
		if(after>before) cout<<cut_v1<<" -- "<<cut_v2<<" ����"<<endl;
		*/
	}
}

// -----------------------------------------------------------------------------//

/*
 *	�ж�v1v2�Ƿ���ͬһ���� 
 */
bool vec2eq(vector<int>& v1, vector<int>& v2)
{
	if(v1[0]==v2[0] && v1[1]==v2[1]) return true;
	if(v1[1]==v2[0] && v1[0]==v2[1]) return true;
	return false;
}

/*
 *	@function bridge_disjointSets_tree : ��׼��+���鼯�������� + �������Ż� 
 *	@explain 					  	   : �ͻ�׼����ͬ��������ͨ��֧�� ����dfs���ǲ��鼯 
 */
void bridge_disjointSets_tree()
{
	init_all();
	int before = connection_count();	// ��¼��ʼͼ��ͨ��֧��Ŀ
	visit_init();
	vector<vector<int>> tree_edges;
	// ����������߼� 
	for(int i=0; i<n; i++) if(vis[i]==0) dfs_getTree(i, -1, tree_edges); 
	for(int t=0; t<tree_edges.size(); t++)
	{
		disjointSets_init();			// ���鼯��ʼ�� 
		int cnt = n;
		for(int i=0; i<edges.size(); i++)
		{
			if(vec2eq(tree_edges[t], edges[i])) continue;	// ɾ����t����
			int f1=disjointSets_find(edges[i][0]), f2=disjointSets_find(edges[i][1]);
			if(f1!=f2) father[f1]=f2, cnt--;	// �ϲ��������� 
		}
		/*
		if(cnt>before) cout<<tree_edges[t][0]<<" -- "<<tree_edges[t][1]<<" ����"<<endl;
		*/
	}
}

// -----------------------------------------------------------------------------//

/*
 *	@function dfs_tarjan : ���ڵ�x����С�ɴ����� 
 *	@param x			 : Ҫ���Ľڵ�x 
 *	@param direct_father : x��ֱ�Ӹ��ڵ� 
 *	@param depth		 : ��ǰdfs�Ĳ��� ��x�ڵ�����������dfn[x]
 *	@return 			 : ---- 
 */
void dfs_tarjan(int x, int direct_father, int depth)
{
	dfn[x] = min_ancestor[x] = depth;	// min_ancestor��ʼֵ=dfn 
	for(int i=0; i<adj[x].size(); i++)
	{
		int child = adj[x][i];
		if(dfn[child]==-1)	// child������ڵ� ����x�Ĵ𰸿�������������child 
		{
			dfs_tarjan(child, x, depth+1);	// ����� min_ancestor[child]
			min_ancestor[x] = min(min_ancestor[x], min_ancestor[child]);
		}
		else if(child!=direct_father)		// ���child�����Ƚڵ� ���Ը��´� 
		{
			min_ancestor[x] = min(min_ancestor[x], dfn[child]);
		}
	}
}

/*
 *	@function bridge_disjointSets_tree : tarjan�㷨���� 
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
				cout<<i<<" -- "<<child<<" ����"<<endl;
			*/
		}
	}
}

// -----------------------------------------------------------------------------//

/*
 *	@function dfs_getTree_relation : ���dfs��������ϵ����tree 
 *	@param start				   : dfs��ǰ��� 
 *	@param direct_father		   : start��ֱ�Ӹ��ڵ� 
 */
void dfs_getTree_relation(int start, int direct_father)
{
	vis[start]=1; tree[start]=direct_father;
	for(int i=0; i<adj[start].size(); i++)
		if(vis[adj[start][i]]==0) dfs_getTree_relation(adj[start][i], start);
}

/*
 *	@function mark_cirEdges : ��src������dest ��;��ǻ��� ��ѹ������ 
 *	@param src				: ��� 
 *	@param dest				: �յ� 
 *	@explain				: ������ dfs_getTree_relation ��������ϵ��ʹ�øú��� 
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
 *	@function dfs_lca : tarjan�㷨��⡾start�㼰�������������ڵ�Ե�lca 
 *	@param start	  : tarjan�㷨��dfsΪģ����� 
 *	@explain		  : vis[x]=1��ʾx���ڼ��� 
 *					  : vis[x]=2��ʾx������������������� 
 *					  : �����еĽڵ�x �䲢�鼯����x�����Գɼ��ϣ�
 *					  : ������Ͻڵ�x �䲢�鼯�鲢���丸�ڵ㣨ͨ������ݹ�ʵ�֣�  
 */

// ��dfs���������� 
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
			father[f2] = start;	// child������������������� ��child�󶨵�start�� 
		} 
	}
	// start�㼰������������������� ��ʼ������start��ص�query 
	for(int i=0; i<adj[start].size(); i++)
	{
		int another = adj[start][i];
		if(vis[another]==1 && tree_edges.find(vector<int>{start, another})==tree_edges.end())
		{
			int f2 = disjointSets_find(another);
			// ��;��ǻ��� -- ��ѹ�� ������� 
			mark_cirEdges(start, f2), mark_cirEdges(another, f2);
			cir_edges.insert(vector<int>{start, another});	// ����Ҳ�ǻ��� 	
		}
	}
}

/*	-std=c++11
 *	@function bridge_bcj_lca : ���鼯+��lca -> �󻷱� -> ���� 
 *	@explain 			     : ---- 
 */
void bridge_bcj_lca()
{
	init_all();
	
	// �����������ϵ����
	visit_init();
	for(int i=0; i<n; i++) if(vis[i]==0) dfs_getTree_relation(i, i);
	
	//cout<<1<<endl;
	// ����������߼� 
	visit_init();
	vector<vector<int>> tree_edges;
	for(int i=0; i<n; i++) if(vis[i]==0) dfs_getTree(i, -1, tree_edges); 
	//cout<<2<<endl;
	// ��ñ߼� query ��lcaҪ��ѯ�ı�
	unordered_set<vector<int>, edge_hash, edge_cmp> hash(tree_edges.begin(), tree_edges.end());	
	for(int i=0; i<e; i++)
		if(hash.find(edges[i])==hash.end()) 
			query[edges[i][0]].push_back(edges[i][1]), query[edges[i][1]].push_back(edges[i][0]);
	//cout<<3<<endl;
	
	// ��������query��lca ���ҽ��ر������㵽�������ȵ�·���ϵı�ȫ�����Ϊ���� 
	visit_init(); disjointSets_init();
	for(int i=0; i<n; i++) if(vis[i]==0) dfs_lca(i);
		
	// ���ݻ��߷�ѡ�� 
	/*
	for(int i=0; i<e; i++)
		if(cir_edges.find(edges[i])==cir_edges.end())
			cout<<edges[i][0]<<" -- "<<edges[i][1]<<" ����"<<endl;
	*/	
}

// -----------------------------------------------------------------------------//

/* 
 *	@function dfs_getTree_relation_dep : ��������ɵ�dfs 
 *	@param start					   : ��ǰ�ڵ� 
 *	@param direct_father			   : ��ǰ�ڵ��ֱ�Ӹ��ڵ�
 *	@param d						   : ��ǰ�ڵ����
 *	@explain						   : ͬʱ���������� 
 */
void dfs_getTree_relation_dep(int start, int direct_father, int d)
{
	vis[start]=1; tree[start]=direct_father; depth[start]=d;
	for(int i=0; i<adj[start].size(); i++)
		if(vis[adj[start][i]]==0) dfs_getTree_relation_dep(adj[start][i], start, d+1);
}

/*	
 *	@function bridge_bcj_lca : lca�󻷱� + ·��ѹ�� 
 *	@explain 			     : ---- 
 */
int tcnt=0;
void bridge_bcj_lca2()
{
	init_all();
	// ���������� 
	for(int i=0; i<n; i++) if(vis[i]==0) dfs_getTree_relation_dep(i, i, 0); 
	visit_init();
	for(int i=0; i<n; i++) tree_edges.insert(vector<int>{tree[i],i});
	for(int i=0; i<edges.size(); i++)
	{
		if(tree_edges.find(edges[i])==tree_edges.end())
		{
			int p1=edges[i][0], p2=edges[i][1], pre,pre1,pre2;
			cir_edges.insert(vector<int>{p1, p2});	// ��Ǳ� 
			if(depth[p1]<depth[p2]) swap(p1, p2);	// Ĭ��p1Ϊ��ĵ� 
			while(depth[p1]>depth[p2]) 				// ͬ���߶� 
				pre1=p1,p1=tree[p1],cir_edges.insert(vector<int>{pre1, p1});
			while(tree[p1]!=tree[p2])				// ��lca 
			{
				pre1=p1, pre2=p2;
				p1=tree[p1], p2=tree[p2];
				cir_edges.insert(vector<int>{pre1, p1});
				cir_edges.insert(vector<int>{pre2, p2});
			}
			// ѹ������ ��;��·�������е�ҵ�lca�� 
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
			//tcnt++;	// ���Խ��� 
			// if(tcnt%100000==0) cout<<tcnt<<endl;
		}
	}
	/*
	for(int i=0; i<e; i++)
		if(cir_edges.find(edges[i])==cir_edges.end())
			cout<<edges[i][0]<<" -- "<<edges[i][1]<<" ����"<<endl;
	*/
}

int main()
{
	/* ���е�������ݶ��� 1.���Ի� 2.���ر� �� */
	
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
		
		cout<<"�����������:"<<_batch<<endl;
		
		// ��׼ 
		st = clock();	
		//bridge_basic();					
		ed = clock();
		t1 += (double)(ed-st)/CLOCKS_PER_SEC;
		
		// ��׼+���鼯
		st = clock();
		//bridge_disjointSets();			 
		ed = clock();
		t2 += (double)(ed-st)/CLOCKS_PER_SEC;
		
		// ��׼+�������Ż� 
		st = clock();
		//bridge_basic_tree();				
		ed = clock();
		t3 += (double)(ed-st)/CLOCKS_PER_SEC;
		
		// ��׼+���鼯+�������Ż� 
		st = clock();
		//bridge_disjointSets_tree();		
		ed = clock();
		t4 += (double)(ed-st)/CLOCKS_PER_SEC;
		
		// tarjan�㷨����
		st = clock();
		//bridge_tarjan();					 
		ed = clock();
		t5 += (double)(ed-st)/CLOCKS_PER_SEC;
		
		// lca�󻷱����� 
		st = clock();
		//bridge_bcj_lca();
		ed = clock();
		t6 += (double)(ed-st)/CLOCKS_PER_SEC;
		
		// lca�󻷱����� +ѹ�� 
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
	
	/* ���������Ϊ����˵������ */
	
	return 0;
}

/*
��������1 
6
7
0 1
0 2
1 2
2 3
3 4
3 5
4 5

�������1 
2 -- 3 ���� 

��������2
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

�������2
0 -- 1 ����
2 -- 3 ����
2 -- 6 ����
6 -- 7 ����
9 -- 10 ����
12 -- 13 ����
 
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
