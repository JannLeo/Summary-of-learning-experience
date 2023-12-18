#include <bits/stdc++.h>

using namespace std;

int k, m, n, ans=0;
vector<vector<int>> path, p;

int iabs(int x){return (x>=0)?(x):(-x);}

/*
function  : print ��ӡ����
param mat : Ҫ��ӡ�ľ��������
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
function : ������������ 
param n1 : ��һ�����ֵ����� 
param n2 : �ڶ������ֵ�����
return   : ---- 
*/
void bswap(int& n1, int& n2)
{
	n1 ^= n2;
	n2 ^= n1;
	n1 ^= n2;
}

/*
function  : erase ��ȥ���鲢��ʹʣ�෽������
param mat : �������������
return    : ��ȥ���п��ܵķ�������÷�
explain   : ���������Լ����Ƿ����3���Ż������� ���Ӷ�ΪO(m*n) 
		  : ��Ϊ��ȥ���������µ�����3��Ҳ�ᱻ����(����ʱβ�ݹ�)
*/
int erase(vector<vector<int>>& mat)
{
	int cnt3=0, cnt4=0, cnt5=0;
	// ����3��4��5�����������
	for(int i=0; i<m; i++)
	{
		for(int j=0; j<n; j++)
		{
			if(i+2<m && mat[i][j]!=0)	// ����Ϊ3���ݿ� 
			{
				if(iabs(mat[i][j])==iabs(mat[i+1][j])&&
				   iabs(mat[i+1][j])==iabs(mat[i+2][j])) 
					mat[i][j]=mat[i+1][j]=mat[i+2][j]=-iabs(mat[i][j]), cnt3++;
			}
			if(j+2<n && mat[i][j]!=0)	// ����Ϊ3����� 
			{
				if(iabs(mat[i][j])==iabs(mat[i][j+1])&&
				   iabs(mat[i][j+1])==iabs(mat[i][j+2])) 
					mat[i][j]=mat[i][j+1]=mat[i][j+2]=-iabs(mat[i][j]), cnt3++;
			}
			if(i+3<m && mat[i][j]!=0)	// ����Ϊ4���ݿ� 
			{
				if(iabs(mat[i][j])==iabs(mat[i+1][j])&&
				   iabs(mat[i+1][j])==iabs(mat[i+2][j])&&
				   iabs(mat[i+2][j])==iabs(mat[i+3][j])) 
					mat[i][j]=mat[i+1][j]=mat[i+2][j]=mat[i+3][j]=-iabs(mat[i][j]), cnt4++;
			}
			if(j+3<n && mat[i][j]!=0)	// ����Ϊ4����� 
			{
				if(iabs(mat[i][j])==iabs(mat[i][j+1])&&
				   iabs(mat[i][j+1])==iabs(mat[i][j+2])&&
				   iabs(mat[i][j+2])==iabs(mat[i][j+3])) 
					mat[i][j]=mat[i][j+1]=mat[i][j+2]=mat[i][j+3]=-iabs(mat[i][j]), cnt4++;
			}
			if(i+4<m && mat[i][j]!=0)	// ����Ϊ5���ݿ� 
			{
				if(iabs(mat[i][j])==iabs(mat[i+1][j])&&
				   iabs(mat[i+1][j])==iabs(mat[i+2][j])&&
				   iabs(mat[i+2][j])==iabs(mat[i+3][j])&&
				   iabs(mat[i+3][j])==iabs(mat[i+4][j])) 
					mat[i][j]=mat[i+1][j]=mat[i+2][j]=mat[i+3][j]=mat[i+4][j]=-iabs(mat[i][j]), cnt5++;
			}
			if(j+4<n && mat[i][j]!=0)	// ����Ϊ5����� 
			{
				if(iabs(mat[i][j])==iabs(mat[i][j+1])&&
				   iabs(mat[i][j+1])==iabs(mat[i][j+2])&&
				   iabs(mat[i][j+2])==iabs(mat[i][j+3])&&
				   iabs(mat[i][j+3])==iabs(mat[i][j+4])) 
					mat[i][j]=mat[i][j+1]=mat[i][j+2]=mat[i][j+3]=mat[i][j+4]=-iabs(mat[i][j]), cnt5++;
			}
		}
	}
	// �������� 
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
	cnt4-=2*cnt5, cnt3-=(3*cnt5+2*cnt4);		// ��ȥ�ظ��ļ��� 
	if(cnt3 + cnt4*4 + cnt5*10 == 0) return 0;	// �Ƿ���Ҫ��ȥ�µ����� 
	return cnt3 + cnt4*4 + cnt5*10 + erase(mat);
}

/*
function   : dfs ������������������÷ֵ���ȥ��ʽ
param mat  : �������������
param step : ִ�н����Ĵ���
param sum  : ��ǰ�ݹ����ڵ�÷�ֵ 
return     : ----
explain    : ���Ŵ𰸣�ȫ�ֱ��������ڵݹ�ﵽ����ʱ������ 
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
function cmp : �ȽϺ������洢״̬ʱ��״̬���յ÷ֽ�������ʱʹ��
param v1     : ��1��״̬������ 
param v2     : ��2��״̬������ 
return 		 : �ȽϽ�� 
explain      : ״̬����Ϊһά����[�÷�,x1,y1,x2,y2] xyΪ�����ķ�������� 
*/
bool cmp(const vector<int>& v1, const vector<int>& v2)
{
	return v1[0]>v2[0];
}

/*
function   : ̰�ķ�+dfs��ÿ��ѡ��÷�ǰ k ��ķ�֧ 
param mat  : �������������
param step : ִ�н����Ĵ���
param tpk  : ѡ��ǰ tpk ���״̬���еݹ� 
return     : ----
explain    : ���ܱ�֤�õ����Ž� 
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
function   : mat2str ����תΪ�ַ�����Ϊ����hashmap�����key�� 
param v    : ���̾��� 
param step : ��ǰ�ߵĲ���
return     : ת������ַ�������ΪSTL���ṩstring��hash������������key��� 
*/
string mat2str(vector<vector<int>>& v, int step)
{
	string str = "";
	for(int i=0; i<v.size(); i++)
		for(int j=0; j<v[0].size(); j++) str += (char)(v[i][j]+'0');
	str += (char)(step+'0');
	return str;
}

/* hashmap ��ϣ��������״̬��÷֣�key=���� value=�÷� */
unordered_map<string, int> hashmap;

/*
function   : dfs + mem ���仯���������������Ҳ�Ƕ�̬�滮��һ��ʵ��
param mat  : �������������
param step : ִ�н����Ĵ���
return     : ��ǰ�����ܹ���õ�����ֵ 
explain    : ���ü��仯�Ĳ��ԣ������֮ǰ�Ȳ鿴��������Ƿ�֮ǰ������� 
		   : �õ�����ȫ�����Ž� 
*/
int dfs_mem(vector<vector<int>>& mat, int step)
{
	if(step==0) return 0;
	// �ݹ�ǰ�Ȳ������ֱ�ӷ��� 
	vector<vector<int>> a; 
	string key = mat2str(mat, step);
	if(hashmap[key] != 0) return hashmap[key]; 
	// ���״̬��ʼ�ݹ� 
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
	// ������һ�εĽ�� 
	hashmap[key] = maxv;
	return maxv;
}

/*
function   : printPath ��ӡһ��dfs֮���õ�·���Լ��� 
param name : ��������  
param src  : ·����Ŀ�����̾��� ����
return     : ----
*/
void printPath(string name, vector<vector<int>> src)
{
	cout<<endl<<"  >>> "<<name<<"��������: <<<"<<endl<<endl;
	print(src);
	for(int k=0; k<path.size(); k++)
	{
		cout<<"������ �����̽��н��� "; 
		cout<<"("<<path[k][0]<<","<<path[k][1]<<") <--> ";
		cout<<"("<<path[k][2]<<","<<path[k][3]<<") "<<"�õ���������� ��:"<<endl;
		cout<<"����״̬:"<<endl;
		bswap(src[path[k][0]][path[k][1]], src[path[k][2]][path[k][3]]);
		erase(src);
		print(src);
	}
	cout<<name<<"���÷���: "<<ans<<endl;
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
	// ȥ���ⲿ�ֵ�ע�Ϳ���ʵ�֣�ʵ��Ҫ��1 �ֶ��������ݣ����㲻ͬx����ͬ�㷨�÷�  
	vector<vector<int>> mat(m), m1, m2;
	for(int i=0; i<m; i++) mat[i].resize(n);
	for(int i=0; i<m; i++)
		for(int j=0; j<n; j++) cin>>mat[i][j];
	
	// ���ݷ� 
	ans=0, m1=mat;
	start = clock();
	dfs(m1, x_step, 0);
	end = clock();
	printPath("���ݷ�", m1);
	cout<<"���ݷ���ʱ: "<<(double)(end-start)/CLOCKS_PER_SEC<<" s"<<endl;
	
	// ����+̰��,ѡ��ǰ select_top_k ��ķ�֧����dfs 
	ans=0, m2=mat;
	start = clock();
	dfs_topk(m2, x_step, 0, select_top_k);
	end = clock();
	printPath("����+̰�ķ�", m2);
	cout<<"����+̰�ķ���ʱ: "<<(double)(end-start)/CLOCKS_PER_SEC<<" s"<<endl;
	*/
	
	/*
	// ȥ���ⲿ�ֵ�ע�Ϳ���ʵ�֣�ʵ��Ҫ��2 ����������ݣ����Լ��޹�ģ 
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
	cout<<"�����������, ִ�в���Ϊ "<<x_step<<endl;
	
	ans=0, m1=mat;
	start = clock();
	dfs(m1, x_step, 0);
	end = clock();
	printPath("���ݷ�", m1);
	cout<<"���ݷ���ʱ: "<<(double)(end-start)/CLOCKS_PER_SEC<<" s"<<endl;
	*/
	
	// ʵ��Ҫ��3 ����������ݣ�����ʱ�� 
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
		cout<<"����������� "<<sample-tt<<endl;
		
		// ���ݷ� 
		ans=0, m1=mat;
		start = clock();
		dfs(m1, x_step, 0);
		end = clock();
		t1 += (double)(end-start)/CLOCKS_PER_SEC;
		s1 += ans; 
		
		// ÿ�εݹ�����ǰ 1 ����֧ 
		ans=0, m1=mat;
		start = clock();
		//dfs_topk(m1, x_step, 0, 1);
		end = clock();
		t2 += (double)(end-start)/CLOCKS_PER_SEC;
		s2 += ans; 
		
		// ÿ�εݹ�����ǰ 3 ����֧
		ans=0, m1=mat;
		start = clock();
		//dfs_topk(m1, x_step, 0, 3);
		end = clock();
		t3 += (double)(end-start)/CLOCKS_PER_SEC;
		s3 += ans; 
		
		// ÿ�εݹ�����ǰ 5 ����֧
		ans=0, m1=mat;
		start = clock();
		//dfs_topk(m1, x_step, 0, 5);
		end = clock();
		t4 += (double)(end-start)/CLOCKS_PER_SEC;
		s4 += ans; 
		
		// ÿ�εݹ�����ǰ 7 ����֧
		ans=0, m1=mat;
		start = clock();
		//dfs_topk(m1, x_step, 0, 7);
		end = clock();
		t5 += (double)(end-start)/CLOCKS_PER_SEC;
		s5 += ans; 
		
		// ���仯
		ans=0, m1=mat;
		hashmap.clear();	// ������� 
		start = clock();
		//ans = dfs_mem(m1, x_step);
		end = clock();
		t6 += (double)(end-start)/CLOCKS_PER_SEC;
		s6 += ans; 
	} 

	
	cout<<"����Ϊ "<<x_step<<endl;
	cout<<"����:  ƽ����ʱ "<<t1/sample<<" s, ƽ���÷� "<<s1/sample<<endl;
	cout<<"topk=1 ƽ����ʱ "<<t2/sample<<" s, ƽ���÷� "<<s2/sample<<endl;
	cout<<"topk=3 ƽ����ʱ "<<t3/sample<<" s, ƽ���÷� "<<s3/sample<<endl;
	cout<<"topk=5 ƽ����ʱ "<<t4/sample<<" s, ƽ���÷� "<<s4/sample<<endl;
	cout<<"topk=7 ƽ����ʱ "<<t5/sample<<" s, ƽ���÷� "<<s5/sample<<endl;
	cout<<"���仯 ƽ����ʱ "<<t6/sample<<" s, ƽ���÷� "<<s6/sample<<endl;
	
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
����1 
3 3 4 3
3 2 3 3
2 4 3 4
1 3 4 3
3 3 1 1
3 4 3 3
1 4 4 3
1 2 3 2

�Զ������� 
3 3 4 3 1 3 4 3
3 2 3 3 1 2 3 2
2 4 3 4 3 3 1 1
1 3 4 3 2 4 3 4
3 3 1 1 3 3 1 1
3 4 3 3 2 4 3 4
1 4 4 3 1 2 3 2
1 2 3 2 4 3 2 1

// ����������� ���� debug�� 
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
