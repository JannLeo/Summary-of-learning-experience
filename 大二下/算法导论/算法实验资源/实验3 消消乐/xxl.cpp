#include <bits/stdc++.h>

using namespace std;

int k, m, n, ans=0;
vector<vector<int>> path, p;

int iabs(int x){return (x>=0)?(x):(-x);}

/*
function  : print 打印矩阵
param mat : 要打印的矩阵的引用
return    : ---- 
*/ 
void print(vector<vector<int>>& mat)
{
	for(int i=0; i<m; i++)
	{
		for(int j=0; j<n; j++) cout<<mat[i][j]<<" ";
		cout<<endl;
	}
}

/*
function : 交换两个数字 
param n1 : 第一个数字的引用 
param n2 : 第二个数字的引用
return   : ---- 
*/
void bswap(int& n1, int& n2)
{
	n1 ^= n2;
	n2 ^= n1;
	n1 ^= n2;
}

/*
function  : erase 消去方块并且使剩余方块下落
param mat : 方块数组的引用
return    : 消去所有可能的方块后最大得分
explain   : 遍历棋盘以计算是否出现3连号或者以上 复杂度为O(m*n) 
		  : 因为消去而产生的新的相邻3连也会被计算(返回时尾递归)
*/
int erase(vector<vector<int>>& mat)
{
	int cnt3=0, cnt4=0, cnt5=0;
	// 计算3，4，5的连续块个数
	for(int i=0; i<m; i++)
	{
		for(int j=0; j<n; j++)
		{
			if(i+2<m && mat[i][j]!=0)	// 长度为3，纵块 
			{
				if(iabs(mat[i][j])==iabs(mat[i+1][j])&&
				   iabs(mat[i+1][j])==iabs(mat[i+2][j])) 
					mat[i][j]=mat[i+1][j]=mat[i+2][j]=-iabs(mat[i][j]), cnt3++;
			}
			if(j+2<n && mat[i][j]!=0)	// 长度为3，横块 
			{
				if(iabs(mat[i][j])==iabs(mat[i][j+1])&&
				   iabs(mat[i][j+1])==iabs(mat[i][j+2])) 
					mat[i][j]=mat[i][j+1]=mat[i][j+2]=-iabs(mat[i][j]), cnt3++;
			}
			if(i+3<m && mat[i][j]!=0)	// 长度为4，纵块 
			{
				if(iabs(mat[i][j])==iabs(mat[i+1][j])&&
				   iabs(mat[i+1][j])==iabs(mat[i+2][j])&&
				   iabs(mat[i+2][j])==iabs(mat[i+3][j])) 
					mat[i][j]=mat[i+1][j]=mat[i+2][j]=mat[i+3][j]=-iabs(mat[i][j]), cnt4++;
			}
			if(j+3<n && mat[i][j]!=0)	// 长度为4，横块 
			{
				if(iabs(mat[i][j])==iabs(mat[i][j+1])&&
				   iabs(mat[i][j+1])==iabs(mat[i][j+2])&&
				   iabs(mat[i][j+2])==iabs(mat[i][j+3])) 
					mat[i][j]=mat[i][j+1]=mat[i][j+2]=mat[i][j+3]=-iabs(mat[i][j]), cnt4++;
			}
			if(i+4<m && mat[i][j]!=0)	// 长度为5，纵块 
			{
				if(iabs(mat[i][j])==iabs(mat[i+1][j])&&
				   iabs(mat[i+1][j])==iabs(mat[i+2][j])&&
				   iabs(mat[i+2][j])==iabs(mat[i+3][j])&&
				   iabs(mat[i+3][j])==iabs(mat[i+4][j])) 
					mat[i][j]=mat[i+1][j]=mat[i+2][j]=mat[i+3][j]=mat[i+4][j]=-iabs(mat[i][j]), cnt5++;
			}
			if(j+4<n && mat[i][j]!=0)	// 长度为5，横块 
			{
				if(iabs(mat[i][j])==iabs(mat[i][j+1])&&
				   iabs(mat[i][j+1])==iabs(mat[i][j+2])&&
				   iabs(mat[i][j+2])==iabs(mat[i][j+3])&&
				   iabs(mat[i][j+3])==iabs(mat[i][j+4])) 
					mat[i][j]=mat[i][j+1]=mat[i][j+2]=mat[i][j+3]=mat[i][j+4]=-iabs(mat[i][j]), cnt5++;
			}
		}
	}
	// 方块下落 
	for(int j=0; j<n; j++)
	{
		int st=m-1, ed=0, dst=0, delta=0;
		while(st>=0 && mat[st][j]>0) st--;
		for(ed=st; ed>=0&&mat[ed][j]<=0; ed--){}
		delta = st-ed;
		for(int i=ed; i>=0; i--) 
			mat[i+delta][j]=mat[i][j], mat[i][j]=0;
	}
	for(int i=0; i<m; i++)
		for(int j=0; j<n; j++) mat[i][j]=max(mat[i][j], 0);
	cnt4-=2*cnt5, cnt3-=(3*cnt5+2*cnt4);		// 消去重复的计数 
	if(cnt3 + cnt4*4 + cnt5*10 == 0) return 0;	// 是否需要消去新的连号 
	return cnt3 + cnt4*4 + cnt5*10 + erase(mat);
}

/*
function   : dfs 深度优先搜索，搜最大得分的消去方式
param mat  : 方块数组的引用
param step : 执行交换的次数
param sum  : 当前递归树节点得分值 
return     : ----
explain    : 最优答案（全局变量）会在递归达到最深时被更新 
*/
void dfs(vector<vector<int>>& mat, int step, int sum)
{
	if(step==0)
	{
		if(sum > ans)
			ans=sum, path=p;
		return;
	}
	vector<vector<int>> a;
	for(int i=0; i<m; i++)
	{
		for(int j=0; j<n; j++)
		{
			if(i+1<m && mat[i][j] && mat[i+1][j])
			{
				a=mat, bswap(a[i][j], a[i+1][j]);
				int res = erase(a);
				if(res>0) 
				{
					p.push_back(vector<int>{i,j,i+1,j});
					dfs(a, step-1, sum+res);
					p.pop_back();
				}
			}
			if(j+1<n && mat[i][j] && mat[i][j+1])
			{
				a=mat, bswap(a[i][j], a[i][j+1]);
				int res = erase(a);
				if(res>0) 
				{
					p.push_back(vector<int>{i,j,i,j+1});
					dfs(a, step-1, sum+res);
					p.pop_back();	
				}
			}
		}
	}
}

/*
function cmp : 比较函数，存储状态时对状态按照得分降序排序时使用
param v1     : 第1个状态的引用 
param v2     : 第2个状态的引用 
return 		 : 比较结果 
explain      : 状态保存为一维数组[得分,x1,y1,x2,y2] xy为交换的方块的坐标 
*/
bool cmp(const vector<int>& v1, const vector<int>& v2)
{
	return v1[0]>v2[0];
}

/*
function   : 贪心法+dfs：每次选择得分前 k 大的分支 
param mat  : 方块数组的引用
param step : 执行交换的次数
param tpk  : 选择前 tpk 大的状态进行递归 
return     : ----
explain    : 不能保证得到最优解 
*/
void dfs_topk(vector<vector<int>>& mat, int step, int sum, int tpk)
{
	if(step==0)
	{
		if(sum > ans)
			ans=sum, path=p;
		return;
	}
	vector<vector<int>> a, seq;
	int maxv=0,x1=0,y1=0,x2=0,y2=0,res;
	for(int i=0; i<m; i++)
	{
		for(int j=0; j<n; j++)
		{
			if(i+1<m && mat[i][j] && mat[i+1][j])
			{
				a=mat, bswap(a[i][j], a[i+1][j]);
				res = erase(a);
				if(res > maxv) seq.push_back(vector<int>{res,i,j,i+1,j});
			}
			if(j+1<n && mat[i][j] && mat[i][j+1])
			{
				a=mat, bswap(a[i][j], a[i][j+1]);
				res = erase(a);
				if(res > maxv) seq.push_back(vector<int>{res,i,j,i,j+1});
			}
		}
	}
	sort(seq.begin(), seq.end(), cmp);
	for(int i=0; i<min((int)seq.size(),tpk); i++)
	{
		a=mat, bswap(a[seq[i][1]][seq[i][2]], a[seq[i][3]][seq[i][4]]);
		res = erase(a);
		p.push_back(vector<int>(seq[i].begin()+1, seq[i].end()));
		dfs_topk(a, step-1, sum+res, tpk);
		p.pop_back();
	}
}

/*
function   : mat2str 矩阵转为字符串，为下面hashmap查表做key用 
param v    : 棋盘矩阵 
param step : 当前走的步数
return     : 转换后的字符串，因为STL有提供string的hash函数，方便做key查表 
*/
string mat2str(vector<vector<int>>& v, int step)
{
	string str = "";
	for(int i=0; i<v.size(); i++)
		for(int j=0; j<v[0].size(); j++) str += (char)(v[i][j]+'0');
	str += (char)(step+'0');
	return str;
}

/* hashmap 哈希表保存棋盘状态与得分，key=棋盘 value=得分 */
unordered_map<string, int> hashmap;

/*
function   : dfs + mem 记忆化的深度优先搜索，也是动态规划的一种实现
param mat  : 方块数组的引用
param step : 执行交换的次数
return     : 当前棋盘能够获得的最大价值 
explain    : 采用记忆化的策略，计算答案之前先查看这个棋盘是否之前被计算过 
		   : 得到的是全局最优解 
*/
int dfs_mem(vector<vector<int>>& mat, int step)
{
	if(step==0) return 0;
	// 递归前先查表，有则直接返回 
	vector<vector<int>> a; 
	string key = mat2str(mat, step);
	if(hashmap[key] != 0) return hashmap[key]; 
	// 穷举状态开始递归 
	int maxv=0, val=0;
	for(int i=0; i<m; i++)
	{
		for(int j=0; j<n; j++)
		{
			if(i+1<m && mat[i][j] && mat[i+1][j])
			{
				a=mat, bswap(a[i][j], a[i+1][j]);
				int res = erase(a);
				if(res>0) 
				{
					p.push_back(vector<int>{i,j,i+1,j});
					val = dfs_mem(a, step-1);
					maxv = max(maxv, val+res);
					p.pop_back();
				}
			}
			if(j+1<n && mat[i][j] && mat[i][j+1])
			{
				a=mat, bswap(a[i][j], a[i][j+1]);
				int res = erase(a);
				if(res>0) 
				{
					p.push_back(vector<int>{i,j,i,j+1});
					val = dfs_mem(a, step-1);
					maxv = max(maxv, val+res);
					p.pop_back();	
				}
			}
		}
	}
	// 保存这一次的结果 
	hashmap[key] = maxv;
	return maxv;
}

/*
function   : printPath 打印一次dfs之后获得的路径以及答案 
param name : 方法名称  
param src  : 路径的目标棋盘矩阵 引用
return     : ----
*/
void printPath(string name, vector<vector<int>> src)
{
	cout<<endl<<"  >>> "<<name<<"过程如下: <<<"<<endl<<endl;
	print(src);
	for(int k=0; k<path.size(); k++)
	{
		cout<<"对上面 ↑棋盘进行交换 "; 
		cout<<"("<<path[k][0]<<","<<path[k][1]<<") <--> ";
		cout<<"("<<path[k][2]<<","<<path[k][3]<<") "<<"得到下面的棋盘 ↓:"<<endl;
		cout<<"棋盘状态:"<<endl;
		bswap(src[path[k][0]][path[k][1]], src[path[k][2]][path[k][3]]);
		erase(src);
		print(src);
	}
	cout<<name<<"最大得分是: "<<ans<<endl;
}

int main()
{	
	#define k_types 6
	#define row 7
	#define col 7 
	#define x_step 1
	#define select_top_k 3
	#define sample 20
	k=k_types, m=row, n=col;
	
	clock_t start, end;
	
	/*
	// 去掉这部分的注释可以实现：实验要求1 手动输入数据，计算不同x，不同算法得分  
	vector<vector<int>> mat(m), m1, m2;
	for(int i=0; i<m; i++) mat[i].resize(n);
	for(int i=0; i<m; i++)
		for(int j=0; j<n; j++) cin>>mat[i][j];
	
	// 回溯法 
	ans=0, m1=mat;
	start = clock();
	dfs(m1, x_step, 0);
	end = clock();
	printPath("回溯法", m1);
	cout<<"回溯法用时: "<<(double)(end-start)/CLOCKS_PER_SEC<<" s"<<endl;
	
	// 回溯+贪心,选择前 select_top_k 大的分支进行dfs 
	ans=0, m2=mat;
	start = clock();
	dfs_topk(m2, x_step, 0, select_top_k);
	end = clock();
	printPath("回溯+贪心法", m2);
	cout<<"回溯+贪心法用时: "<<(double)(end-start)/CLOCKS_PER_SEC<<" s"<<endl;
	*/
	
	/*
	// 去掉这部分的注释可以实现：实验要求2 随机生成数据，测试极限规模 
	default_random_engine rd(time(NULL));
	uniform_int_distribution<int> dist(1, k_types);
	
	vector<vector<int>> mat(m), m1, m2;
	for(int i=0; i<m; i++) mat[i].resize(n);
	while(1)
	{
		for(int i=0; i<m; i++)
			for(int j=0; j<n; j++) mat[i][j]=dist(rd);
		if(erase(mat)==0) break;
	}
	cout<<"数据生成完毕, 执行步数为 "<<x_step<<endl;
	
	ans=0, m1=mat;
	start = clock();
	dfs(m1, x_step, 0);
	end = clock();
	printPath("回溯法", m1);
	cout<<"回溯法用时: "<<(double)(end-start)/CLOCKS_PER_SEC<<" s"<<endl;
	*/
	
	// 实验要求3 随机生成数据，测试时间 
	double t1=0,t2=0,t3=0,t4=0,t5=0,t6=0,s1=0,s2=0,s3=0,s4=0,s5=0,s6=0;
	default_random_engine rd(time(NULL));
	uniform_int_distribution<int> dist(1, k_types);
	
	int tt = sample;
	while(tt--)
	{
		vector<vector<int>> mat(m), m1;
		for(int i=0; i<m; i++) mat[i].resize(n);
		while(1)
		{
			for(int i=0; i<m; i++)
				for(int j=0; j<n; j++) mat[i][j]=dist(rd);
			if(erase(mat)==0) break;
		}
		cout<<"数据生成完毕 "<<sample-tt<<endl;
		
		// 回溯法 
		ans=0, m1=mat;
		start = clock();
		dfs(m1, x_step, 0);
		end = clock();
		t1 += (double)(end-start)/CLOCKS_PER_SEC;
		s1 += ans; 
		
		// 每次递归最大的前 1 个分支 
		ans=0, m1=mat;
		start = clock();
		//dfs_topk(m1, x_step, 0, 1);
		end = clock();
		t2 += (double)(end-start)/CLOCKS_PER_SEC;
		s2 += ans; 
		
		// 每次递归最大的前 3 个分支
		ans=0, m1=mat;
		start = clock();
		//dfs_topk(m1, x_step, 0, 3);
		end = clock();
		t3 += (double)(end-start)/CLOCKS_PER_SEC;
		s3 += ans; 
		
		// 每次递归最大的前 5 个分支
		ans=0, m1=mat;
		start = clock();
		//dfs_topk(m1, x_step, 0, 5);
		end = clock();
		t4 += (double)(end-start)/CLOCKS_PER_SEC;
		s4 += ans; 
		
		// 每次递归最大的前 7 个分支
		ans=0, m1=mat;
		start = clock();
		//dfs_topk(m1, x_step, 0, 7);
		end = clock();
		t5 += (double)(end-start)/CLOCKS_PER_SEC;
		s5 += ans; 
		
		// 记忆化
		ans=0, m1=mat;
		hashmap.clear();	// 清除记忆 
		start = clock();
		//ans = dfs_mem(m1, x_step);
		end = clock();
		t6 += (double)(end-start)/CLOCKS_PER_SEC;
		s6 += ans; 
	} 

	
	cout<<"步数为 "<<x_step<<endl;
	cout<<"回溯:  平均用时 "<<t1/sample<<" s, 平均得分 "<<s1/sample<<endl;
	cout<<"topk=1 平均用时 "<<t2/sample<<" s, 平均得分 "<<s2/sample<<endl;
	cout<<"topk=3 平均用时 "<<t3/sample<<" s, 平均得分 "<<s3/sample<<endl;
	cout<<"topk=5 平均用时 "<<t4/sample<<" s, 平均得分 "<<s4/sample<<endl;
	cout<<"topk=7 平均用时 "<<t5/sample<<" s, 平均得分 "<<s5/sample<<endl;
	cout<<"记忆化 平均用时 "<<t6/sample<<" s, 平均得分 "<<s6/sample<<endl;
	
	cout<<t1/sample<<endl;
	cout<<t2/sample<<endl;
	cout<<t3/sample<<endl;
	cout<<t4/sample<<endl;
	cout<<t5/sample<<endl;
	cout<<t6/sample<<endl<<endl;
	
	cout<<s1/sample<<endl;
	cout<<s2/sample<<endl;
	cout<<s3/sample<<endl;
	cout<<s4/sample<<endl;
	cout<<s5/sample<<endl;
	cout<<s6/sample<<endl<<endl;
	
	return 0;
}

/*
样例1 
3 3 4 3
3 2 3 3
2 4 3 4
1 3 4 3
3 3 1 1
3 4 3 3
1 4 4 3
1 2 3 2

自定义样例 
3 3 4 3 1 3 4 3
3 2 3 3 1 2 3 2
2 4 3 4 3 3 1 1
1 3 4 3 2 4 3 4
3 3 1 1 3 3 1 1
3 4 3 3 2 4 3 4
1 4 4 3 1 2 3 2
1 2 3 2 4 3 2 1

// 测试消除结果 样例 debug用 
3 4 3 3
3 2 4 3
2 3 3 4
1 4 4 3
3 3 1 1
4 4 1 3
1 3 1 3
1 1 1 1

0 0 0 0
0 3 4 3
0 2 3 3
3 4 3 4
3 3 4 3
2 4 3 3
1 4 4 3
1 2 3 2

0 3 4 3
0 2 3 3
0 4 3 4
3 3 4 3
3 1 1 1
2 4 3 3
1 4 4 3
1 2 3 2

*/
