#include <bits/stdc++.h>

using namespace std;

#define inf 1145141919

int n=0, e=0;
unordered_map<int, int> hashmap;	// �������ֵ��±��ӳ�� 
unordered_map<int, int> hashmap_rev;
vector<vector<int>> adj;			// �ڽӱ� 
vector<vector<int>> adj_rev;		// ���ڽӱ� 
vector<vector<int>> dis;			// dis[x][i]��ʾ��x���㵽��i����ѯ�ʻ����̾��� 
vector<unordered_set<int>> words;	// words[x]��ʾx�ڵ�����дʻ�ļ��� 
//unordered_set<int> word_set;
vector<int> vis;					// ���ʿ������� 
vector<unordered_map<int, int>> word_dis;	// x�㵽���дʻ�ľ���map 
vector<int> indegree;				// ��� 

void load_data(string edge_set_path, string key_set_path)
{
	//string filepath = "datasheets/Yago_test/edge.txt";
	string filepath = edge_set_path;
	list<string> lines;
	cout<<"��ȡ���ݲ�����ӳ��"<<endl;
	
	ifstream ifs(filepath);				// ���ļ��� 
	streambuf *ori_in = cin.rdbuf();	//����ԭ�������������ʽ
	cin.rdbuf(ifs.rdbuf());				// ���ض��� 
	while(getline(cin,filepath)) 		// ��ȡ�ļ���
	{
		if(filepath.length()==0) break;
		lines.push_back(filepath);
		/*
		int sum=0, i=0;
		while(filepath[i]!=':') sum*=10,sum+=(filepath[i++]-'0');
		// cout<<sum<<endl;
		hashmap[sum] = n++;
		hashmap_rev[n-1] = sum;
		if(n%1000000==0) cout<<n<<endl;
		*/
	} 
	ifs.close();						// �ر��� 
	cin.rdbuf(ori_in);					//�ص�����̨�ı�׼�������
	
	unordered_set<int> hash;
	for(auto it=lines.begin(); it!=lines.end(); it++)
	{
		int v1=0, v2=0, i=0, len=(*it).length();
		while((*it)[i]!=':') v1*=10,v1+=((*it)[i++]-'0');
		i += 2;
		hash.insert(v1); 
		while(i<len)
		{
			v2=0;
			while((*it)[i]!=',') v2*=10,v2+=((*it)[i++]-'0');
			hash.insert(v2);
			i++;
		}
	}
	
	for(auto it=hash.begin(); it!=hash.end(); it++)
	{
		hashmap[*it] = n++;
		hashmap_rev[n-1] = *it;
	}
	cout<<n<<endl;
	
	// ����size��ʼ�� 
	adj.resize(n); 
	adj_rev.resize(n);
	dis.resize(n);
	words.resize(n);
	vis.resize(n);
	word_dis.resize(n);
	indegree.resize(n);
	
	//cout<<n<<endl;
	
	cout<<"�����ڽӱ�"<<endl;
	for(auto it=lines.begin(); it!=lines.end(); it++)
	{
		int v1=0, v2=0, i=0, len=(*it).length();
		while((*it)[i]!=':') v1*=10,v1+=((*it)[i++]-'0');
		i += 2;
		while(i<len)
		{
			v2=0;
			while((*it)[i]!=',') v2*=10,v2+=((*it)[i++]-'0');
			if(hashmap.find(v2)!=hashmap.end())
			{
				adj[hashmap[v1]].push_back(hashmap[v2]);
				adj_rev[hashmap[v2]].push_back(hashmap[v1]);
			}	
			// if(hashmap.find(v2)==hashmap.end()) cout<<"not found"<<endl;
			indegree[hashmap[v2]]++;
			i++;
		}
	}
	
	//cout<<bar<<endl;
	cout<<"���ض���ʻ�"<<endl;
	
	//filepath = "datasheets/Yago_test/node_keywords.txt";
	filepath = key_set_path;
	ifstream ifs1(filepath);				
	streambuf *ori_in1 = cin.rdbuf();	
	cin.rdbuf(ifs1.rdbuf());				
	while(getline(cin,filepath)) 		
	{
		if(filepath.length()==0) break;
		int v1=0, v2=0, i=0, len=filepath.length();
		while(filepath[i]!=':') v1*=10,v1+=(filepath[i++]-'0');
		i += 2;
		//cout<<v1<<": ";
		while(i<len)
		{
			v2=0;
			while(filepath[i]!=',') v2*=10,v2+=(filepath[i++]-'0');
			//cout<<v2<<" ";
			words[hashmap[v1]].insert(v2);
			//word_set.insert(v2);
			i++;
		}
		//cout<<endl;
	} 
	cout<<"��ȡ���"<<endl;
	cout<<n<<"������ "<<endl;
	ifs1.close();					
	cin.rdbuf(ori_in1);		
}

void load_data2(int n_, string edge_set_path, string key_set_path)
{
	// ����size��ʼ�� 
	n = n_;
	adj.resize(n); 
	adj_rev.resize(n);
	dis.resize(n);
	words.resize(n);
	vis.resize(n);
	word_dis.resize(n);
	indegree.resize(n);

	string filepath = edge_set_path;
	cout<<"�����ڽӱ�"<<endl;
	ifstream ifs(filepath);				// ���ļ��� 
	streambuf *ori_in = cin.rdbuf();	//����ԭ�������������ʽ
	cin.rdbuf(ifs.rdbuf());				// ���ض��� 
	
	int bar=0, ecnt=0;
	while(getline(cin,filepath)) 		// ��ȡ�ļ���
	{
		if(filepath.length()==0) break;
		string* it = &filepath;
		
		int v1=0, v2=0, i=0, len=(*it).length();
		while((*it)[i]!=':') v1*=10,v1+=((*it)[i++]-'0');
		i += 2;
		while(i<len)
		{
			v2=0;
			while((*it)[i]!=',') v2*=10,v2+=((*it)[i++]-'0');
			adj[v1].push_back(v2);
			adj_rev[v2].push_back(v1);
			/*
			int f1=find(v1), f2=find(v2);
			father[f1] = f2;
			if(f1==f2) cout<<"���ֻ�"<<endl;
			*/
			i++, ecnt++;
			//if(ecnt<10) cout<<v1<<" -> "<<v2<<endl;
		}
		bar++;
		if(bar%1000000==0) cout<<bar<<endl;
	} 
	cout<<bar<<endl;
	
	cout<<"��ȡ�ʻ�"<<endl;
	bar = 0;
	filepath = key_set_path;
	ifstream ifs1(filepath);				
	streambuf *ori_in1 = cin.rdbuf();	
	cin.rdbuf(ifs1.rdbuf());				
	while(getline(cin,filepath)) 		
	{
		if(filepath.length()==0) break;
		int v1=0, v2=0, i=0, len=filepath.length();
		while(filepath[i]!=':') v1*=10,v1+=(filepath[i++]-'0');
		i += 2;
		//cout<<v1<<": ";
		while(i<len)
		{
			v2=0;
			while(filepath[i]!=',') v2*=10,v2+=(filepath[i++]-'0');
			//cout<<v2<<" ";
			words[v1].insert(v2);
			//word_set.insert(v2);
			i++;
			if(bar<10) cout<<v1<<" -> "<<v2<<endl;
		}
		bar++; if(bar%1000000==0) cout<<bar<<endl;
		//cout<<endl;
	} 
	ifs1.close();					
	cin.rdbuf(ori_in1);		
	
	cout<<"ͼ�������: "<<n<<" ������"<<", "<<ecnt<<" ����"<<endl;
	ifs.close();						// �ر��� 
	cin.rdbuf(ori_in);					//�ص�����̨�ı�׼�������
}

// ------------------------------------------------------------------------------ //

/*
 *	@function is_control : ����ص� m1 �Ƿ�֧�� m2 
 *	@param m1			 : ����ص�1 
 *	@param m2			 : ����ص�2
 *	@return				 : m1�Ƿ�֧��m2 
 *	@explain			 : ����һ������ص�: a[x]��ʾ����x����ѯ�ʻ�ľ��� 
 						 : ���һ��Ԫ�ر�ʾ���ڵ� 
 */
bool is_control(vector<int>& m1, vector<int>& m2)
{
	int cnt1=0, cnt2=0;
	for(int i=0; i<m1.size()-1; i++)
	{
		if(m1[i] < m2[i]) cnt1++;
		if(m1[i] <= m2[i]) cnt2++;
	}
	return (cnt1>0)&&(cnt2==m1.size()-1);
}

/*
 *	@function is_inside : ��ѯx�ڵ��Ƿ����ĳ����ѯ�ʻ� 
 *	@param	x			: ��ѯ�Ľڵ� 
 *	@param query_words	: ��ѯ�ʻ㼯��
 *	@return 			���Ƿ���� true or false 
 */
bool is_inside(int x, vector<int>& query_words)
{
	for(int i=0; i<query_words.size(); i++)
		if(words[x].find(query_words[i])!=words[x].end()) return true;
	return false;
}

/*
 *	@function bfs1	   : ����bfs ��ѯ���е� 
 *	@param x		   : bfs��� 
 *	@param query_words : ���ҹؼ��ʼ���
 *	@param res		   : �������ص������ 
 *	@return			   : �Ϸ�������ص��򷵻�true 
 */
bool bfs1(int x, vector<int>& query_words, vector<int>& res)
{
	queue<int> q;
	q.push(x); vis[x]=x;
	int step = 0;
	
	while(!q.empty())
	{
		int qs = q.size();
		for(int sq=0; sq<qs; sq++)
		{
			// ȡ��ǰԪ�� 
			int tp=q.front(); q.pop();
			vis[tp] = x;
			// ����Ҫ���ҵĴʻ� ����ǰ������ ��bfs�ҵ������ 
			for(int i=0; i<query_words.size(); i++)
				if(words[tp].find(query_words[i])!=words[tp].end()) res[i]=min(res[i], step);
			// bfs 
			for(int i=0; i<adj[tp].size(); i++)
				if(vis[adj[tp][i]]!=x) q.push(adj[tp][i]), vis[adj[tp][i]]=x;
		}
		step++;
	}
	// �Ƿ��ǺϷ�����ص� 
	for(auto it=res.begin(); it!=res.end(); it++) if(*it==inf) return false;
	return true;
}

/*
 *	function query_violent : ������ѯ 
 */
void query_violent(vector<int>& query_words)
{
	for(int i=0; i<n; i++) vis[i]=-1;
	vector<vector<int>> glocs;	// ����ص� 
	for(int i=0; i<n; i++)
	{
		if(i%100000==0) cout<<i<<endl;
		vector<int> res(query_words.size());
		for(int q=0; q<query_words.size(); q++) res[q]=inf; 
		res.push_back(i);	// ���һλ�����ĸ��ڵ��� 
		if(!bfs1(i, query_words, res)) continue;
		if(query_words.size()==1 && res[0]==0) {glocs.push_back(res); continue;}
		int j;
		for(j=0; j<glocs.size(); j++)
		{
			if(is_control(glocs[j], res)) break;
		 	if(is_control(res, glocs[j])) glocs[j]=res;
		}
		if(j==glocs.size()) glocs.push_back(res);
	}
	
	for(int i=0; i<n; i++) vis[i]=-1;
	int cnt=0;
	for(int i=0; i<glocs.size(); i++)
	{
		if(vis[glocs[i].back()]==glocs[i].back()) continue;
		vis[glocs[i].back()]=glocs[i].back();
		cnt++;
		//cout<<"�� "<<i<<" ����ѯ��� ";
		for(int j=0; j<glocs[i].size()-1; j++)
		{
			cout<<"<"<<query_words[j]<<", "<<glocs[i][j]<<">  ";
		}cout<<"���ڵ��� "<<hashmap_rev[glocs[i].back()]<<endl;
	}
	cout<<"��ѯ���: "<<cnt<<" ��"<<endl;
	
}

/*
 *	function query_root : ֻ��ѯӵ�йؼ��ʵĸ� 
 */
void query_root(vector<int>& query_words)
{
	for(int i=0; i<n; i++) vis[i]=-1;
	vector<vector<int>> glocs;	// ����ص� 
	for(int i=0; i<n; i++)
	{
		if(i%100000==0) cout<<i<<endl;
		if(!is_inside(i, query_words)) continue;
		vector<int> res(query_words.size());
		for(int q=0; q<query_words.size(); q++) res[q]=inf; 
		res.push_back(i);	// ���һλ�����ĸ��ڵ��� 
		if(!bfs1(i, query_words, res)) continue;
		if(query_words.size()==1 && res[0]==0) {glocs.push_back(res); continue;}
		int j;
		for(j=0; j<glocs.size(); j++)
		{
			if(is_control(glocs[j], res)) break;
		 	if(is_control(res, glocs[j])) glocs[j]=res;
		}
		if(j==glocs.size()) glocs.push_back(res);
	}
	/*
	for(int i=0; i<n; i++) vis[i]=-1;
	int cnt=0;
	for(int i=0; i<glocs.size(); i++)
	{
		if(vis[glocs[i].back()]==glocs[i].back()) continue;
		vis[glocs[i].back()]=glocs[i].back();
		cnt++;
		//cout<<"�� "<<i<<" ����ѯ��� ";
		for(int j=0; j<glocs[i].size()-1; j++)
		{
			cout<<"<"<<query_words[j]<<", "<<glocs[i][j]<<">  ";
		}cout<<"���ڵ��� "<<hashmap_rev[glocs[i].back()]<<endl;
	}
	cout<<"��ѯ���: "<<cnt<<" ��"<<endl;
	*/
}

/*
 *	@function bfs2	   : ֻ��s�� 
 *	@param x		   : bfs��� 
 *	@param query_words : ���ҹؼ��ʼ���
 *	@param res		   : �������ص������ 
 *	@return			   : �Ϸ�������ص��򷵻�true 
 */
bool bfs2(int x, vector<int>& query_words, vector<int>& res, int s)
{
	queue<int> q;
	q.push(x); vis[x]=x;
	int step = 0;
	
	while(!q.empty() && step<s)
	{
		int qs = q.size();
		for(int sq=0; sq<qs; sq++)
		{
			// ȡ��ǰԪ�� 
			int tp=q.front(); q.pop();
			vis[tp] = x;
			// ����Ҫ���ҵĴʻ� ����ǰ������ ��bfs�ҵ������ 
			for(int i=0; i<query_words.size(); i++)
				if(words[tp].find(query_words[i])!=words[tp].end()) res[i]=min(res[i], step);
			// bfs 
			for(int i=0; i<adj[tp].size(); i++)
				if(vis[adj[tp][i]]!=x) q.push(adj[tp][i]), vis[adj[tp][i]]=x;
		}
		step++;
	}
	// �Ƿ��ǺϷ�����ص� 
	for(auto it=res.begin(); it!=res.end(); it++) if(*it==inf) return false;
	return true;
}

/*
 *	function query_kstep : bfs��֦ ֻ��kstep�� 
 */
void query_kstep(vector<int>& query_words, int kstep)
{
	for(int i=0; i<n; i++) vis[i]=-1;
	vector<vector<int>> glocs;
	for(int i=0; i<n; i++)
	{
		if(i%100000==0) cout<<i<<endl;
		vector<int> res(query_words.size());
		for(int q=0; q<query_words.size(); q++) res[q]=inf; 
		res.push_back(i);	// ���һλ�����ĸ��ڵ��� 
		if(!bfs2(i, query_words, res, kstep)) continue;
		if(query_words.size()==1 && res[0]==0) {glocs.push_back(res); continue;}
		int j;
		for(j=0; j<glocs.size(); j++)
		{
		 	if(is_control(glocs[j], res)) break;
		 	if(is_control(res, glocs[j])) glocs[j]=res;
		}
		if(j==glocs.size()) glocs.push_back(res);
	}
	/*
	for(int i=0; i<n; i++) vis[i]=-1;
	int cnt=0;
	for(int i=0; i<glocs.size(); i++)
	{
		if(vis[glocs[i].back()]==glocs[i].back()) continue;
		vis[glocs[i].back()]=glocs[i].back();
		cnt++;
		//cout<<"�� "<<i<<" ����ѯ��� ";
		for(int j=0; j<glocs[i].size()-1; j++)
		{
			cout<<"<"<<query_words[j]<<", "<<glocs[i][j]<<">  ";
		}cout<<"���ڵ��� "<<glocs[i].back()<<endl;
	}
	cout<<"��ѯ���: "<<cnt<<" ��"<<endl;
	*/
}

/*
 *	@function bfs_all : һ���Դ���x�����дʻ���� 
 *	@param x		  : ��� 
 */
void bfs_all(int x)
{
	queue<int> q;
	q.push(x); vis[x]=x;
	int step = 0;
	
	while(!q.empty())
	{
		int qs = q.size();
		for(int sq=0; sq<qs; sq++)
		{
			// ȡ��ǰԪ�� 
			int tp=q.front(); q.pop();
			vis[tp] = x;
			
			// �鿴���������дʻ� ���Ը��¾��� 
			for(auto it=words[tp].begin(); it!=words[tp].end(); it++)
				if(word_dis[x].find(*it)==word_dis[x].end())
					word_dis[x].insert(pair<int,int>(*it, step));
			// bfs 
			for(int i=0; i<adj[tp].size(); i++)
				if(vis[adj[tp][i]]!=x) q.push(adj[tp][i]), vis[adj[tp][i]]=x;
		}
		step++;
	}
}

/*
 *	@function load_worddis : Ԥ����������е㵽���дʻ�ľ��� 
 */
void load_worddis()
{
	for(int i=0; i<n; i++) vis[i]=-1;
	for(int i=0; i<n; i++) 
	{
		if(i%100==0) cout<<i<<endl;
		bfs_all(i);	
	}
}

/*
 *	@function query_in_preprocess : ��Ԥ����Ļ����ϲ�ѯ 
 */
void query_in_preprocess(vector<int>& query_words)
{
	vector<vector<int>> glocs;
	for(int i=0; i<n; i++)
	{
		vector<int> res(query_words.size()); res.push_back(i);
		int j;
		for(j=0; j<query_words.size(); j++)
		{
			auto it = word_dis[i].find(query_words[j]);
			if(it==word_dis[i].end()) break;
			else res[j]=it->second;
		}
		if(j<query_words.size()) continue;
		for(j=0; j<glocs.size(); j++)
		{
		 	if(is_control(glocs[j], res)) break;
		 	if(is_control(res, glocs[j])) glocs[j]=res;
		}
		if(j==glocs.size()) glocs.push_back(res);
	}
	/*
	for(int i=0; i<n; i++) vis[i]=-1;
	int cnt=0;
	for(int i=0; i<glocs.size(); i++)
	{
		if(vis[glocs[i].back()]==glocs[i].back()) continue;
		vis[glocs[i].back()]=glocs[i].back();
		cnt++;
		//cout<<"�� "<<i<<" ����ѯ��� ";
		for(int j=0; j<glocs[i].size()-1; j++)
		{
			cout<<"<"<<query_words[j]<<", "<<glocs[i][j]<<">  ";
		}cout<<"���ڵ��� "<<glocs[i].back()<<endl;
	}
	cout<<"��ѯ���: "<<cnt<<" ��"<<endl;
	*/
}

/*
 *	function query_root_kstep : ֻ��ѯӵ�йؼ��ʵĸ� + �����Ż� 
 */
void query_root_kstep(vector<int>& query_words, int kstep)
{
	for(int i=0; i<n; i++) vis[i]=-1;
	vector<vector<int>> glocs;	// ����ص� 
	for(int i=0; i<n; i++)
	{
		if(i%100000==0) cout<<i<<endl;
		if(!is_inside(i, query_words)) continue;
		vector<int> res(query_words.size());
		for(int q=0; q<query_words.size(); q++) res[q]=inf; 
		res.push_back(i);	// ���һλ�����ĸ��ڵ��� 
		if(!bfs2(i, query_words, res, kstep)) continue;
		if(query_words.size()==1 && res[0]==0) {glocs.push_back(res); continue;}
		int j;
		for(j=0; j<glocs.size(); j++)
		{
			if(is_control(glocs[j], res)) break;
		 	if(is_control(res, glocs[j])) glocs[j]=res;
		}
		if(j==glocs.size()) glocs.push_back(res);
	}
	/*
	for(int i=0; i<n; i++) vis[i]=-1;
	int cnt=0;
	for(int i=0; i<glocs.size(); i++)
	{
		if(vis[glocs[i].back()]==glocs[i].back()) continue;
		vis[glocs[i].back()]=glocs[i].back();
		cnt++;
		//cout<<"�� "<<i<<" ����ѯ��� ";
		for(int j=0; j<glocs[i].size()-1; j++)
		{
			cout<<"<"<<query_words[j]<<", "<<glocs[i][j]<<">  ";
		}cout<<"���ڵ��� "<<hashmap_rev[glocs[i].back()]<<endl;
	}
	cout<<"��ѯ���: "<<cnt<<" ��"<<endl;
	*/
}

/*
 *	@function bfs_rev : ���ŷ����bfs���Ҹ��¾��� 
 *	@param src		  : ��� 
 *	@return			  : ----
 */
void bfs_rev(int src)
{
	queue<int> q; q.push(src);
	vis[src] = src;
	while(!q.empty())
	{
		int qs = q.size();
		for(int sq=0; sq<qs; sq++)
		{
			int x=q.front(),y; q.pop(); vis[x]=src;
			for(int i=0; i<adj_rev[x].size(); i++)
			{
				y = adj_rev[x][i];
				if(vis[y]==src) continue;
				int update_flag = 0;
				for(int j=0; j<dis[x].size(); j++)
					if(dis[y][j]>dis[x][j]+1) dis[y][j]=dis[x][j]+1, update_flag=1;
				if(update_flag) q.push(y), vis[y]=src;
			}
		}
	}
}

/*
 *	function query_rev : ����bfs��������ѯ
 */
void query_rev(vector<int>& query_words)
{
	for(int i=0; i<n; i++) 
	{
		dis[i].resize(query_words.size());
		for(int j=0; j<query_words.size(); j++) dis[i][j]=inf;
	}
	for(int i=0; i<n; i++)
	{
		if(!is_inside(i, query_words)) continue;
		for(int j=0; j<query_words.size(); j++)
			if(words[i].find(query_words[j])!=words[i].end())dis[i][j]=0;
		bfs_rev(i);
	}
	vector<vector<int>> glocs;	// ����ص� ����
	for(int i=0; i<n; i++)
	{
		int j;
		for(j=0; j<query_words.size(); j++) if(dis[i][j]==inf) break;
		if(j<query_words.size()) continue;
		vector<int> res = dis[i];
		res.push_back(i);
		// ��������ص㼯�� 
		for(j=0; j<glocs.size(); j++)
		{
			if(is_control(glocs[j], res)) break;
		 	if(is_control(res, glocs[j])) glocs[j]=res;
		}
		if(j==glocs.size()) glocs.push_back(res);
	} 
	
	for(int i=0; i<n; i++) vis[i]=-1;
	int cnt=0;
	for(int i=0; i<glocs.size(); i++)
	{
		if(vis[glocs[i].back()]==glocs[i].back()) continue;
		vis[glocs[i].back()]=glocs[i].back();
		cnt++;
		//cout<<"�� "<<i<<" ����ѯ��� ";
		for(int j=0; j<glocs[i].size()-1; j++)
		{
			cout<<"<"<<query_words[j]<<", "<<glocs[i][j]<<">  ";
		}cout<<"���ڵ��� "<<hashmap_rev[glocs[i].back()]<<endl;
	}
	cout<<"��ѯ���: "<<cnt<<" ��"<<endl;
	
}

int main()
{
	load_data("datasheets/Yago_small/edge.txt", "datasheets/Yago_small/node_keywords.txt");
	
	//load_data2(8091179, "datasheets/Yago/edge.txt", "datasheets/Yago/node_keywords.txt");
	
	/*
	ͼ�������: 8091179 ������, 50415307 ����
	7359203 ����ͨ��֧
	*/
	
	clock_t st, ed;
	double t1=0, t2=0, t3=0, t4=0, t5=0, t6=0;
	
	/*
	��ѯ�ʻ㼯��: 10871246 ���: 0�� 
	��ѯ�ʻ㼯��: 10400593,9318031,9310210 ���: 1�� 
	��ѯ�ʻ㼯��: 11674756 ���: 443�� 
	��ѯ�ʻ㼯��: 11674756,11381939,10701562 ���: 12�� 
	*/
	
	// cout<<"Ԥ����"<<endl; load_worddis();	// Ԥ���� ֻ������small���� 
	
	vector<int> query_words{8632116, 9484081,8694912,10565862};
	//vector<int> query_words{11381939};
	//vector<int> query_words{11126302, 8159397};	// 2�� 
	//vector<int> query_words{11674756,11381939,10701562};
	
	
	st = clock();
	query_rev(query_words);
	ed = clock();
	cout<<"��ʱ: "<<(double)(ed-st)/CLOCKS_PER_SEC<<endl;
	
	/*
	#define batch 5
	for(int tt=1; tt<=batch; tt++)
	{
		query_words.clear();
		int wnum = tt;
		for(int i=0; i<wnum; i++)
		{
			int id1 = rand()%(n-1);
			if(words[id1].size()==0) {i--; continue;}
			int id2 = rand()%(words[id1].size());
			//cout<<id1<<" "<<id2<<endl; 
			auto it = words[id1].begin();
			for(int j=0; j<id2; j++) it++;
			query_words.push_back(*it);
			cout<<*it<<" ";
		}
		cout<<" ������: "<<tt<<endl;
		st = clock();
		query_violent(query_words);
		ed = clock();
		t1 += (double)(ed-st)/CLOCKS_PER_SEC;
		
		st = clock();
		query_kstep(query_words, 3);
		ed = clock();
		t2 += (double)(ed-st)/CLOCKS_PER_SEC;
		
		st = clock();
		query_root(query_words);
		ed = clock();
		t3 += (double)(ed-st)/CLOCKS_PER_SEC;
		
		st = clock();
		query_root_kstep(query_words, 3);
		ed = clock();
		t4 += (double)(ed-st)/CLOCKS_PER_SEC;
		
		st = clock();
		//query_in_preprocess(query_words);
		ed = clock();
		t5 += (double)(ed-st)/CLOCKS_PER_SEC;
		
		st = clock();
		query_rev(query_words);
		ed = clock();
		t6 += (double)(ed-st)/CLOCKS_PER_SEC;
	}
	
	cout<<t1/batch<<endl;
	cout<<t2/batch<<endl;
	cout<<t3/batch<<endl;
	cout<<t4/batch<<endl;
	cout<<t5/batch<<endl;
	cout<<t6/batch<<endl;
	*/
	
	return 0;
}

