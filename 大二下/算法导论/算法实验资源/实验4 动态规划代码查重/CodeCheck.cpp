#include <bits/stdc++.h>

using namespace std;

/*
 *	@function char_trim : 单行前后导过滤器 过滤前后 空格 tab {} //注释 
 * 	@param s			: 要过滤的字符串
 *	@return 			: 过滤后的字符串 
 */
string char_trim(string &s)
{
	int i=s.find("//"); if(i!=string::npos) s.erase(s.begin()+i, s.end());
    while(s.back()=='}' || s.back()=='{' || s.back()==' ' || s.back()=='\t') s.pop_back();
    while(s.length()>0 && s[0]==' ') s.erase(0, 1);
	while(s.length()>0 && s[0]=='\t') s.erase(0, 1);
	while(s.length()>0 && s[0]==' ') s.erase(0, 1);
    return s;
}

/*
 *	@function line_trim : 批量代码通用行过滤器 去除空行 tab {} /* //注释 
 *	@param a			: 代码字符串数组 a[i]表示第i句代码
 *	@return 			: ----
 */
void line_trim(vector<string>& a)
{
	for(int i=0; i<a.size(); i++) char_trim(a[i]);
	int flag=1, id;
	vector<string> b;
	for(int i=0; i<a.size(); i++)
	{
		id = a[i].find("/*");
		// 如果没遇到 / * 号就视为有效代码 
		if(id==string::npos)		
		{
			if(flag==1) b.push_back(a[i]);
		}
		// 读取到 / * 开始忽略行 但是要读入这行 / * 之前的内容 
		else	 
		{
			string temp = a[i].substr(0, id); 
			temp = char_trim(temp);
			b.push_back(temp); 
			flag = 0;
		}
		id = a[i].find("*/");
		// 读取到 * / 结束忽略 同时读取 */ 之后的内容 
		if(id!=string::npos)
		{
			string temp = a[i].substr(id+2);
			temp = char_trim(temp);
			b.push_back(temp); 
			flag = 1; 
		}
	}
	a = b;
	for(int i=0; i<a.size(); i++)
	if(a[i].length()==0) a.erase(a.begin()+i), i--;
}

void print(vector<string>& a)
{
	for(int i=0; i<a.size(); i++) cout<<a[i]<<endl;
}

/*
 *	@function readfile : 将文件作为行字符串读取进lines 
 *	@param filepath    : 文件路径 
 *	@param lines	   : 接收文件行的字符串数组 
 *	@return            : ----
 */
void readfile(string filepath, vector<string>& lines)
{
	ifstream ifs(filepath);				// 打开文件流 
	streambuf *ori_in = cin.rdbuf();	//保存原来的输入输出方式
	cin.rdbuf(ifs.rdbuf());				// 流重定向 
	while(getline(cin,filepath)) lines.push_back(filepath);	// 读取文件行 
	ifs.close();						// 关闭流 
	cin.rdbuf(ori_in);					//回到控制台的标准输入输出
}

/*
 *	@function writefile : 将lines数组中字符串作为行写入文件 
 *	@param filepath     : 文件路径 
 *	@param lines	    : 写入内容 字符串数组 
 *	@return             : ----
 */
void writefile(string filepath, vector<string>& lines)
{
	ofstream ofs(filepath);				// 打开文件流 
	streambuf *ori_out = cout.rdbuf();	//保存原来的输入输出方式
	cout.rdbuf(ofs.rdbuf());			// 流重定向 
	for(int i=0; i<lines.size(); i++) cout<<lines[i]<<endl;	// 读取文件行 
	ofs.close();						// 关闭流 
	cout.rdbuf(ori_out);				//回到控制台的标准输入输出
}

/*
 *	@function split_by : 用给定字符分割字符串数组 
 *	@param s		   : 要分割的整个字符串 
 *	@param a		   : 分割后的每个tocken存放的数组
 *	@param ch		   : 按照字符ch来分割
 *	@return 		   : ---- 
 */
void split_by(string s, vector<string>& a, char ch)
{
	int idx = s.find(ch);
	if(idx == string::npos) {a.push_back(s); return;}
	a.push_back(s.substr(0, idx));
	split_by(s.substr(idx+1), a, ch);
}

/*
 *	@function pure_var : 以变量名规则过滤字符串 去除前缀空格 后缀符号 提取数组名 
 *	@param a		   : 变量名数组
 *	@return			   : ---- 
 */
void pure_var(vector<string>& a)
{
	for(int i=0; i<a.size(); i++)
	{
		a[i] = char_trim(a[i]);
		if('0'<=a[i][0] && a[i][0]<='9') {a.erase(a.begin()+i); i--; continue;}	// 数字开头的变量不行 
		int i1=a[i].find(' '), i2=a[i].find('='), i3=a[i].find(';'), i4=a[i].find('[');
		if(i1==string::npos) i1 = INT_MAX;
		if(i2==string::npos) i2 = INT_MAX;
		if(i3==string::npos) i3 = INT_MAX;
		if(i4==string::npos) i4 = INT_MAX;
		int id = min(min(i1, i2), min(i3, i4));
		if(id < INT_MAX) a[i]=a[i].substr(0, id);
	}
}

/*
 *	@function get_var : 得到代码字符串数组的变量名
 *	@param a		  : 代码字符串数组 a[i]表示第i句代码
 *	@return 		  : 字符串数组 存放变量名 
 *	@explain		  : 缺点 无法检测自定义数据类型 
 */
static unordered_set<string> ha{"int", "float", "double", "long", "bool", "string"};
vector<string> get_var(vector<string>& a)
{
	vector<string> vars;
	for(int i=0; i<a.size(); i++)
	{
		// 如果这一行是在申请变量 即 无 () ，排除 int main() 等函数影响 
		if(a[i].find('(')==string::npos && ha.find(a[i].substr(0, a[i].find_first_of(' ')))!=ha.end())
		{
			string temp = a[i].substr(a[i].find_first_of(' ')+1);	// 将变量类型隔离开 
			split_by(temp, vars, ',');								// 按照逗号分割 
		}
	}
	pure_var(vars);	// 去除变量名后面的 赋值 = 号 或者是分号 或者是空格 
	return vars;
}

/*
 *	@function replace_var : 用abcdefg .... 替换变量名
 *	@param a			  : 代码字符串数组 a[i]表示第i句代码
 *	@param vars			  : 变量名集合
 *	@return 			  : ---- 
 */
void  replace_var(vector<string>& a, vector<string>& vars)
{
	char var = 'a';
	for(int i=0; i<vars.size(); i++)
	{
		for(int j=0; j<a.size(); j++)
		{
			while(1)
			{
				int idx = a[j].find(vars[i]);
				string newname = ""; newname += var;
				if(idx != string::npos) a[j].replace(idx, vars[i].length(), newname);
				else break;
			}
		}
		var++;
	}
}

/*
 *	@function replace_var : 用空字符 替换变量名
 *	@param a			  : 代码字符串数组 a[i]表示第i句代码
 *	@param vars			  : 变量名集合
 *	@return 			  : ---- 
 */
void replace_var_null(vector<string>& a, vector<string>& vars)
{
	for(int i=0; i<vars.size(); i++)
	{
		for(int j=0; j<a.size(); j++)
		{
			while(1)
			{
				int idx = a[j].find(vars[i]);
				if(idx != string::npos) a[j].replace(idx, vars[i].length(), "");
				else break;
			}
		}
	}
}

// end of declaration of util functions : 字符处理帮助函数定义结束 
// -------------------------------------------------- //
// match algorithm define in below 		: 查重匹配算法定义在下方 

/*
 *	@function edit_dis : 求两字符串编辑距离 即s1增加/替换/删除 k 个字符能变成s2 
 *	@param s1	       : 字符串1 
 *	@param s2	   	   : 字符串2
 *	@return 		   : 两字符串的编辑距离 
 */
int edit_dis(string s1, string s2)
{
	int len1=s1.length(), len2=s2.length();
	vector<vector<int>> dp(len1+1);
	for(int i=0; i<dp.size(); i++) dp[i].resize(len2+1);
	for(int i=1; i<=len1; i++) dp[i][0] = i;
	for(int i=1; i<=len2; i++) dp[0][i] = i;
	for(int i=1; i<=len1; i++)
		for(int j=1; j<=len2; j++)
			dp[i][j] = (s1[i-1]==s2[j-1])?(dp[i-1][j-1]):(min(dp[i-1][j-1], min(dp[i-1][j], dp[i][j-1]))+1);
	return dp.back().back();
}

/*
 *	@function lcs : 最长相同子序列 -- 空间优化求解 
 *	@param s1     : 要求解的字符串1 
 *	@param s2     : 要求解的字符串2 
 *	@return       : 最长相同子序列长度
 *	@explain	  : 复杂度O(n^2) 
 */
int lcs(string s1, string s2)
{
	int len1=s1.length(), len2=s2.length(), last=0;
	vector<int> dp(len2+1);
	for(int i=1; i<=len1; i++)
	{
		last = 0;
		for(int j=1; j<=len2; j++)
		{
			int temp = dp[j];
			dp[j] = (s1[i-1]==s2[j-1])?(last+1):(max(dp[j], dp[j-1]));
			last = temp;
		}
	}
	return dp.back();
}

/*
 *	@function lis : 最长上升子序列求解 -- 时间优化求解 
 *	@param nums   : 要求解的序列数组
 *	@return       : 最长上升子序列长度
 *	@explain	  : 复杂度O(nlog(n)) 
 */
int lis(vector<int> nums)
{
	if(nums.size()<2) return nums.size();
	vector<int> seq{nums[0]};
	for(int i=1; i<nums.size(); i++)
	{
		int j = lower_bound(seq.begin(), seq.end(), nums[i])-seq.begin();
		if(j==seq.size()) seq.push_back(nums[i]);
		else seq[j]=nums[i];
	}
	return seq.size();
}

/*
 *	@function lcs : 最长相同子序列 -- 时间优化求解 O(nlog(n))  
 *	@param s1     : 要求解的字符串1 
 *	@param s2     : 要求解的字符串2 
 *	@return       : 最长相同子序列长度
 *	@explain	  : 复杂度O(nlog(n))  
 */
int lcs1(string s1, string s2)
{
	int len1=s1.length(), len2=s2.length();
	unordered_map<char, vector<int>> hash;
	for(int i=len2-1; i>=0; i--) hash[s2[i]].push_back(i);
	vector<int> seq;
	for(int i=0; i<len1; i++)
		for(int j=0; j<hash[s1[i]].size(); j++) seq.push_back(hash[s1[i]][j]);
	return lis(seq);
}

/*
 *	@function lcs_str_path : 对字符串数组做 lcs 路径记录 
 *	@param dp			   : 动态规划 lcs 数组 需要根据他来确定走的方向 
 *	@param D			   : 字符串相似度列表 D[i][j] 表示 a.cpp 第i行和 b.cpp 第j行是否相似 
 *	@param path			   : 存放路径的数组, path[0]对应a.cpp第_行, path[1]对应b.cpp 
 *	@param i, j			   : 当前走到dp数组格子的位置 (行 / 列) 
 *	@return				   : ----
 */
void lcs_str_path(vector<vector<int>>& dp, vector<vector<int>>& D, vector<vector<int>>& path, int i, int j)
{
	if(i<1 || j<1) return;
	if(D[i-1][j-1] == 1)
	{
		path.push_back(vector<int>{i-1, j-1});
		lcs_str_path(dp, D, path, i-1, j-1);
	}
	else
	{
		if(dp[i][j]==dp[i][j-1])
			lcs_str_path(dp, D, path, i, j-1);
		else 
			lcs_str_path(dp, D, path, i-1, j);
	}
}

/*
 *	@function lcs_str : 计算字符串数组的lcs 
 *	@param D		  : 字符串相似度列表 D[i][j] 表示 a.cpp 第i行和 b.cpp 第j行是否相似 
 *	@return  		  : lcs路径数组path 放路径的数组, path[0]对应a.cpp第_行, path[1]对应b.cpp 
 */
vector<vector<int>> lcs_str(vector<vector<int>>& D)
{
	vector<vector<int>> mat(D.size()+1);
	for(int i=0; i<mat.size(); i++) mat[i].resize(D[0].size()+1);
	
	for(int i=1; i<mat.size(); i++)
		for(int j=1; j<mat[0].size(); j++)
			mat[i][j] = (D[i-1][j-1]==1)?(mat[i-1][j-1]+1):(max(mat[i-1][j],mat[i][j-1]));
	
	vector<vector<int>> ans;
	lcs_str_path(mat, D, ans, D.size(), D[0].size());
	reverse(ans.begin(), ans.end());
	return ans;
}

/*
 *	@function lcs_str : 暴力匹配每一行代码 
 *	@param D		  : 字符串相似度 S[i][j] 表示 a.cpp 第i行和 b.cpp 第j行相似度 
 *	@param r  	      : 筛选阈值 
 *	@return  		  : 两份代码中相似的行 path[0]对应a.cpp第_行, path[1]对应b.cpp 
 */
vector<vector<int>> violate_match(vector<vector<int>>& S, double r)
{
	vector<vector<int>> ans;
	for(int i=0; i<S.size(); i++)
	{
		int j = max_element(S[i].begin(), S[i].end()) - S[i].begin();
		if(S[i][j] > r) ans.push_back(vector<int>{i, j});
	}
	return ans;
}

/*
 *	@function rate : LCS计算两行代码重复比率 
 *	@param s1	   : 字符串1 
 *	@param s2	   : 字符串2
 *	@return        : 字符串相似度 
 */
double rate_lcs(string s1, string s2)
{
	return (double)lcs1(s1, s2) / (double)min(s1.length(), s2.length());
}

/*
 *	@function rate : 编辑距离计算两行代码重复比率 
 *	@param s1	   : 字符串1 
 *	@param s2	   : 字符串2
 *	@return        : 字符串相似度 
 */
double rate_edis(string s1, string s2)
{
	return 1.0 - (double)edit_dis(s1, s2) / (double)max(s1.length(), s2.length());
}

vector<int> get_origin_var_adj(vector<vector<int>>& adj, int i)
{
	vector<int> adji(adj[0].size()), temp;
	for(int j=0; j<adj[0].size(); j++)
	{
		if(adj[i][j]==1 && i!=j)
		{
			temp=get_origin_var_adj(adj,j);
			int cnt = 0;
			for(int k=0; k<temp.size(); k++) 
				if(temp[k]==1) adji[k]=1;
				else cnt++;
			if(cnt == temp.size()) adji[j]=1;
		} 
	}
	return adji;
}

/*
 *	@function  get_var_adj : 变量依赖关系建图 
 *	@param lines		   : 每一行代码 
 * 	@param vars			   : 变量数组
 *	@return 			   : 变量依赖关系建图--邻接矩阵 
 */
vector<vector<int>> get_var_adj(vector<string>& lines, vector<string>& vars)
{
	vector<vector<int>> adj(vars.size()), adj_;
	for(int i=0; i<adj.size(); i++) adj[i].resize(vars.size());
	for(int i=0; i<lines.size(); i++)
	{
		for(int j=0; j<vars.size(); j++)
		{
			// 寻找赋值语句 vid是左值 eid等于号  
			int vid = lines[i].find(vars[j]);
			int eid = lines[i].find("=");
			// 统计左值变量和那些变量有关，建图（邻接矩阵） 
			if(vid!=string::npos && eid!=string::npos && vid<eid)
				for(int k=0; k<vars.size(); k++)
					if(lines[i].find(vars[k])!=string::npos) adj[j][k]=1;
		}
	}
	for(int i=0; i<adj.size(); i++)
		// adj_.push_back(get_origin_var_adj(adj, i));
	return adj;
}

/*
 *	@function cos_sum : 计算两向量的余弦相似度 
 *	@param v1		  : 向量1 
 *	@param v2		  : 向量2
 *	@return  		  : 向量相似度 
 */
double cos_sim(vector<int> v1, vector<int> v2)
{
	double su=0, sd=0, s1=0, s2=0;
	for(int i=0; i<v1.size(); i++) su+=(v1[i]*v2[i]);
	for(int i=0; i<v1.size(); i++) s1+=(v1[i]*v1[i]); s1=sqrt(s1);
	for(int i=0; i<v1.size(); i++) s2+=(v2[i]*v2[i]); s2=sqrt(s2);
	sd = s1 * s2;
	return su/sd;
}

int main()
{
	/*
	// LCS时间优化测试
	int len=5000, batch=10, ans1, ans2;
	string chars = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
	double t1=0, t2=0;
	clock_t st, ed;
	for(int t=0; t<batch; t++)
	{
		string s1, s2;
		for(int i=0; i<len; i++) s1 += chars[rand()%chars.length()];
		for(int i=0; i<len; i++) s2 += chars[rand()%chars.length()];
		// cout<<s1<<endl<<s2<<endl;
		
		st = clock();
		ans1 = lcs(s1, s2);
		ed = clock();
		t1 += (double)(ed-st)/CLOCKS_PER_SEC;
		
		st = clock();
		ans2 = lcs1(s1, s2);
		ed = clock();
		t2 += (double)(ed-st)/CLOCKS_PER_SEC;
		
		cout<<t<<endl;
	}
	cout<<t1/batch<<endl<<t2/batch<<endl;
	*/
	
	/*
	// 行代码过滤测试 
	vector<string> a;
	readfile("过滤测试.cpp", a);
	cout<<"过滤测试.cpp 原始代码:"<<endl; print(a); cout<<endl;
	// 行过滤代码 
	line_trim(a);
	cout<<"过滤测试.cpp 过滤后代码:"<<endl; print(a); cout<<endl;
	*/
	
	// 变量图关系建立测试
	/*
	vector<string> a;
	readfile("aaa.cpp", a);
	cout<<"aaa.cpp 原始代码:"<<endl; print(a); cout<<endl;
	// 行过滤代码 
	line_trim(a);
	cout<<"aaa.cpp 过滤后代码:"<<endl; print(a); cout<<endl;
	// 提取变量 
	vector<string> a_vars = get_var(a);
	cout<<"aaa.cpp 变量提取:"<<endl; print(a_vars);	cout<<endl;
	// replace_var_null(a, a_vars);
	// cout<<"a.cpp 替换变量后代码:"<<endl; print(a); cout<<endl;
	// 提取变量图关系
	vector<vector<int>> adj = get_var_adj(a, a_vars);
	for(int i=0; i<adj.size(); i++)
	{
		for(int j=0; j<adj[0].size(); j++)
		{
			cout<<adj[i][j]<<" ";
		}
		cout<<endl;
	}
	*/
	
	
	// 测试 
	vector<string> a, b;
	
	// 读取源文件 
	readfile("a4.cpp", a);
	cout<<"a.cpp 原始代码:"<<endl; print(a); cout<<endl;
	// 行过滤代码 
	line_trim(a);
	cout<<"a.cpp 过滤后代码:"<<endl; print(a); cout<<endl;
	
	// 提取变量 
	vector<string> a_vars = get_var(a);
	cout<<"a.cpp 变量提取:"<<endl; print(a_vars);	cout<<endl;
	replace_var_null(a, a_vars);
	// replace_var(a, a_vars);
	cout<<"a.cpp 替换变量后代码:"<<endl; print(a); cout<<endl;
	
	
	cout<<endl<<"--------------------------------"<<endl<<endl;
	
	// 读取源文件 
	readfile("b4.cpp", b);
	cout<<"b.cpp 原始代码:"<<endl; print(b); cout<<endl;
	// 行过滤代码 
	line_trim(b);
	cout<<"b.cpp 过滤后代码:"<<endl; print(b); cout<<endl;
	
	
	// 提取变量 
	vector<string> b_vars = get_var(b);
	cout<<"b.cpp 变量提取:"<<endl; print(b_vars);	cout<<endl;
	replace_var_null(b, b_vars);
	// replace_var(b, b_vars);
	cout<<"b.cpp 替换变量后代码:"<<endl; print(b); cout<<endl;
	
	
	cout<<endl<<"--------------------------------"<<endl<<endl;
	
	// 计算匹配率S / D矩阵 
	#define r 0.9
	vector<vector<int>> D(a.size()), S(a.size());
	for(int i=0; i<S.size(); i++) S[i].resize(b.size()), D[i].resize(b.size());
	for(int i=0; i<S.size(); i++)
		for(int j=0; j<S[0].size(); j++)
			S[i][j] = rate_lcs(a[i],b[j]), D[i][j]=(S[i][j]>r)?(1):(0);
			// S[i][j] = rate_edis(a[i],b[j]), D[i][j]=(S[i][j]>r)?(1):(0);
	
	// 行LCS匹配
	cout<<"行LCS匹配"<<endl; 
	vector<vector<int>> sim_ab = lcs_str(D);
	cout<<endl;
	cout<<left<<setw(30)<<"a.cpp 匹配的代码";
	cout<<"                             ";
	cout<<left<<setw(30)<<"b.cpp 匹配的代码"<<endl;
	for(int i=0; i<sim_ab.size(); i++)
	{
		cout<<left<<setw(30)<<a[sim_ab[i][0]];
		cout<<"                             ";
		cout<<left<<setw(30)<<b[sim_ab[i][1]]<<endl;
	}
	
	double ra = (double)sim_ab.size() / (double)(min(a.size(), b.size()));
	cout<<endl<<"匹配率为: "<<ra<<endl;
	
	cout<<endl<<"--------------------------------"<<endl<<endl;
	
	// 暴力匹配
	cout<<"暴力匹配"<<endl; 
	sim_ab = violate_match(S, r);
	cout<<endl;
	cout<<left<<setw(30)<<"a.cpp 匹配的代码";
	cout<<"                             ";
	cout<<left<<setw(30)<<"b.cpp 匹配的代码"<<endl;
	for(int i=0; i<sim_ab.size(); i++)
	{
		cout<<left<<setw(30)<<a[sim_ab[i][0]];
		cout<<"                             ";
		cout<<left<<setw(30)<<b[sim_ab[i][1]]<<endl;
	}
	
	ra = (double)sim_ab.size() / (double)(min(a.size(), b.size()));
	cout<<endl<<"匹配率为: "<<ra<<endl;
	
	cout<<endl<<"--------------------------------"<<endl<<endl;
	
	
	/*
	// 变量关系建图匹配 
	vector<string> a, b;
	// 读取源文件 
	readfile("a4.cpp", a);
	cout<<"a.cpp 原始代码:"<<endl; print(a); cout<<endl;
	// 行过滤代码 
	line_trim(a);
	cout<<"aaa.cpp 过滤后代码:"<<endl; print(a); cout<<endl;
	// 提取变量 
	vector<string> a_vars = get_var(a);
	cout<<"aaa.cpp 变量提取:"<<endl; print(a_vars);	cout<<endl;
	// 变量关系建图
	vector<vector<int>> adj_a = get_var_adj(a, a_vars); 
	
	cout<<endl<<"--------------------------------"<<endl<<endl;
	
	// 读取源文件 
	readfile("b4.cpp", b);
	cout<<"bbb.cpp 原始代码:"<<endl; print(b); cout<<endl;
	// 行过滤代码 
	line_trim(b);
	cout<<"bbb.cpp 过滤后代码:"<<endl; print(b); cout<<endl;
	// 提取变量 
	vector<string> b_vars = get_var(b);
	cout<<"b.cpp 变量提取:"<<endl; print(b_vars);	cout<<endl;
	// 变量关系建图
	vector<vector<int>> adj_b = get_var_adj(b, b_vars); 
	
	int cc = 0;
	for(int i=0; i<adj_b.size(); i++)
	{
		int cnt = 0;
		for(int j=0; j<adj_b.size(); j++) cnt+=adj_a[i][j];
		if(cnt==0) continue;
		for(int j=0; j<adj_b.size(); j++)
		{
			#define R 0.88
			if(cos_sim(adj_a[i], adj_b[j]) > R)
			{
				for(int r=0; r<a.size(); r++)
				{
					int v1aidx = a[r].find(a_vars[i]);
					int v2aidx = a[r].find(a_vars[j]);
					int v1bidx = b[r].find(b_vars[i]);
					int v2bidx = b[r].find(b_vars[j]);
					if(v1aidx!=string::npos &&
					   v2aidx!=string::npos &&
					   v1bidx!=string::npos &&
					   v2bidx!=string::npos)
					{
					   	cout<<left<<setw(55)<<a[r];
						cout<<" -- ";
						cout<<left<<setw(55)<<b[r]<<endl;
						cc++;
					}
				}
			}
		}
	}
	
	cout<<"匹配率为"<<(double)cc/min(a.size(), b.size())/2<<endl;
	
	cout<<endl<<"--------------------------------"<<endl<<endl;
	*/
		
	return 0;
}

/*
a12cd3kc
123kkkc

abcadc
cabedab
*/
