#include <bits/stdc++.h>

using namespace std;

/*
 *	@function char_trim : ����ǰ�󵼹����� ����ǰ�� �ո� tab {} //ע�� 
 * 	@param s			: Ҫ���˵��ַ���
 *	@return 			: ���˺���ַ��� 
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
 *	@function line_trim : ��������ͨ���й����� ȥ������ tab {} /* //ע�� 
 *	@param a			: �����ַ������� a[i]��ʾ��i�����
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
		// ���û���� / * �ž���Ϊ��Ч���� 
		if(id==string::npos)		
		{
			if(flag==1) b.push_back(a[i]);
		}
		// ��ȡ�� / * ��ʼ������ ����Ҫ�������� / * ֮ǰ������ 
		else	 
		{
			string temp = a[i].substr(0, id); 
			temp = char_trim(temp);
			b.push_back(temp); 
			flag = 0;
		}
		id = a[i].find("*/");
		// ��ȡ�� * / �������� ͬʱ��ȡ */ ֮������� 
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
 *	@function readfile : ���ļ���Ϊ���ַ�����ȡ��lines 
 *	@param filepath    : �ļ�·�� 
 *	@param lines	   : �����ļ��е��ַ������� 
 *	@return            : ----
 */
void readfile(string filepath, vector<string>& lines)
{
	ifstream ifs(filepath);				// ���ļ��� 
	streambuf *ori_in = cin.rdbuf();	//����ԭ�������������ʽ
	cin.rdbuf(ifs.rdbuf());				// ���ض��� 
	while(getline(cin,filepath)) lines.push_back(filepath);	// ��ȡ�ļ��� 
	ifs.close();						// �ر��� 
	cin.rdbuf(ori_in);					//�ص�����̨�ı�׼�������
}

/*
 *	@function writefile : ��lines�������ַ�����Ϊ��д���ļ� 
 *	@param filepath     : �ļ�·�� 
 *	@param lines	    : д������ �ַ������� 
 *	@return             : ----
 */
void writefile(string filepath, vector<string>& lines)
{
	ofstream ofs(filepath);				// ���ļ��� 
	streambuf *ori_out = cout.rdbuf();	//����ԭ�������������ʽ
	cout.rdbuf(ofs.rdbuf());			// ���ض��� 
	for(int i=0; i<lines.size(); i++) cout<<lines[i]<<endl;	// ��ȡ�ļ��� 
	ofs.close();						// �ر��� 
	cout.rdbuf(ori_out);				//�ص�����̨�ı�׼�������
}

/*
 *	@function split_by : �ø����ַ��ָ��ַ������� 
 *	@param s		   : Ҫ�ָ�������ַ��� 
 *	@param a		   : �ָ���ÿ��tocken��ŵ�����
 *	@param ch		   : �����ַ�ch���ָ�
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
 *	@function pure_var : �Ա�������������ַ��� ȥ��ǰ׺�ո� ��׺���� ��ȡ������ 
 *	@param a		   : ����������
 *	@return			   : ---- 
 */
void pure_var(vector<string>& a)
{
	for(int i=0; i<a.size(); i++)
	{
		a[i] = char_trim(a[i]);
		if('0'<=a[i][0] && a[i][0]<='9') {a.erase(a.begin()+i); i--; continue;}	// ���ֿ�ͷ�ı������� 
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
 *	@function get_var : �õ������ַ�������ı�����
 *	@param a		  : �����ַ������� a[i]��ʾ��i�����
 *	@return 		  : �ַ������� ��ű����� 
 *	@explain		  : ȱ�� �޷�����Զ����������� 
 */
static unordered_set<string> ha{"int", "float", "double", "long", "bool", "string"};
vector<string> get_var(vector<string>& a)
{
	vector<string> vars;
	for(int i=0; i<a.size(); i++)
	{
		// �����һ������������� �� �� () ���ų� int main() �Ⱥ���Ӱ�� 
		if(a[i].find('(')==string::npos && ha.find(a[i].substr(0, a[i].find_first_of(' ')))!=ha.end())
		{
			string temp = a[i].substr(a[i].find_first_of(' ')+1);	// ���������͸��뿪 
			split_by(temp, vars, ',');								// ���ն��ŷָ� 
		}
	}
	pure_var(vars);	// ȥ������������� ��ֵ = �� �����Ƿֺ� �����ǿո� 
	return vars;
}

/*
 *	@function replace_var : ��abcdefg .... �滻������
 *	@param a			  : �����ַ������� a[i]��ʾ��i�����
 *	@param vars			  : ����������
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
 *	@function replace_var : �ÿ��ַ� �滻������
 *	@param a			  : �����ַ������� a[i]��ʾ��i�����
 *	@param vars			  : ����������
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

// end of declaration of util functions : �ַ������������������� 
// -------------------------------------------------- //
// match algorithm define in below 		: ����ƥ���㷨�������·� 

/*
 *	@function edit_dis : �����ַ����༭���� ��s1����/�滻/ɾ�� k ���ַ��ܱ��s2 
 *	@param s1	       : �ַ���1 
 *	@param s2	   	   : �ַ���2
 *	@return 		   : ���ַ����ı༭���� 
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
 *	@function lcs : ���ͬ������ -- �ռ��Ż���� 
 *	@param s1     : Ҫ�����ַ���1 
 *	@param s2     : Ҫ�����ַ���2 
 *	@return       : ���ͬ�����г���
 *	@explain	  : ���Ӷ�O(n^2) 
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
 *	@function lis : �������������� -- ʱ���Ż���� 
 *	@param nums   : Ҫ������������
 *	@return       : ����������г���
 *	@explain	  : ���Ӷ�O(nlog(n)) 
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
 *	@function lcs : ���ͬ������ -- ʱ���Ż���� O(nlog(n))  
 *	@param s1     : Ҫ�����ַ���1 
 *	@param s2     : Ҫ�����ַ���2 
 *	@return       : ���ͬ�����г���
 *	@explain	  : ���Ӷ�O(nlog(n))  
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
 *	@function lcs_str_path : ���ַ��������� lcs ·����¼ 
 *	@param dp			   : ��̬�滮 lcs ���� ��Ҫ��������ȷ���ߵķ��� 
 *	@param D			   : �ַ������ƶ��б� D[i][j] ��ʾ a.cpp ��i�к� b.cpp ��j���Ƿ����� 
 *	@param path			   : ���·��������, path[0]��Ӧa.cpp��_��, path[1]��Ӧb.cpp 
 *	@param i, j			   : ��ǰ�ߵ�dp������ӵ�λ�� (�� / ��) 
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
 *	@function lcs_str : �����ַ��������lcs 
 *	@param D		  : �ַ������ƶ��б� D[i][j] ��ʾ a.cpp ��i�к� b.cpp ��j���Ƿ����� 
 *	@return  		  : lcs·������path ��·��������, path[0]��Ӧa.cpp��_��, path[1]��Ӧb.cpp 
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
 *	@function lcs_str : ����ƥ��ÿһ�д��� 
 *	@param D		  : �ַ������ƶ� S[i][j] ��ʾ a.cpp ��i�к� b.cpp ��j�����ƶ� 
 *	@param r  	      : ɸѡ��ֵ 
 *	@return  		  : ���ݴ��������Ƶ��� path[0]��Ӧa.cpp��_��, path[1]��Ӧb.cpp 
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
 *	@function rate : LCS�������д����ظ����� 
 *	@param s1	   : �ַ���1 
 *	@param s2	   : �ַ���2
 *	@return        : �ַ������ƶ� 
 */
double rate_lcs(string s1, string s2)
{
	return (double)lcs1(s1, s2) / (double)min(s1.length(), s2.length());
}

/*
 *	@function rate : �༭����������д����ظ����� 
 *	@param s1	   : �ַ���1 
 *	@param s2	   : �ַ���2
 *	@return        : �ַ������ƶ� 
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
 *	@function  get_var_adj : ����������ϵ��ͼ 
 *	@param lines		   : ÿһ�д��� 
 * 	@param vars			   : ��������
 *	@return 			   : ����������ϵ��ͼ--�ڽӾ��� 
 */
vector<vector<int>> get_var_adj(vector<string>& lines, vector<string>& vars)
{
	vector<vector<int>> adj(vars.size()), adj_;
	for(int i=0; i<adj.size(); i++) adj[i].resize(vars.size());
	for(int i=0; i<lines.size(); i++)
	{
		for(int j=0; j<vars.size(); j++)
		{
			// Ѱ�Ҹ�ֵ��� vid����ֵ eid���ں�  
			int vid = lines[i].find(vars[j]);
			int eid = lines[i].find("=");
			// ͳ����ֵ��������Щ�����йأ���ͼ���ڽӾ��� 
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
 *	@function cos_sum : �������������������ƶ� 
 *	@param v1		  : ����1 
 *	@param v2		  : ����2
 *	@return  		  : �������ƶ� 
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
	// LCSʱ���Ż�����
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
	// �д�����˲��� 
	vector<string> a;
	readfile("���˲���.cpp", a);
	cout<<"���˲���.cpp ԭʼ����:"<<endl; print(a); cout<<endl;
	// �й��˴��� 
	line_trim(a);
	cout<<"���˲���.cpp ���˺����:"<<endl; print(a); cout<<endl;
	*/
	
	// ����ͼ��ϵ��������
	/*
	vector<string> a;
	readfile("aaa.cpp", a);
	cout<<"aaa.cpp ԭʼ����:"<<endl; print(a); cout<<endl;
	// �й��˴��� 
	line_trim(a);
	cout<<"aaa.cpp ���˺����:"<<endl; print(a); cout<<endl;
	// ��ȡ���� 
	vector<string> a_vars = get_var(a);
	cout<<"aaa.cpp ������ȡ:"<<endl; print(a_vars);	cout<<endl;
	// replace_var_null(a, a_vars);
	// cout<<"a.cpp �滻���������:"<<endl; print(a); cout<<endl;
	// ��ȡ����ͼ��ϵ
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
	
	
	// ���� 
	vector<string> a, b;
	
	// ��ȡԴ�ļ� 
	readfile("a4.cpp", a);
	cout<<"a.cpp ԭʼ����:"<<endl; print(a); cout<<endl;
	// �й��˴��� 
	line_trim(a);
	cout<<"a.cpp ���˺����:"<<endl; print(a); cout<<endl;
	
	// ��ȡ���� 
	vector<string> a_vars = get_var(a);
	cout<<"a.cpp ������ȡ:"<<endl; print(a_vars);	cout<<endl;
	replace_var_null(a, a_vars);
	// replace_var(a, a_vars);
	cout<<"a.cpp �滻���������:"<<endl; print(a); cout<<endl;
	
	
	cout<<endl<<"--------------------------------"<<endl<<endl;
	
	// ��ȡԴ�ļ� 
	readfile("b4.cpp", b);
	cout<<"b.cpp ԭʼ����:"<<endl; print(b); cout<<endl;
	// �й��˴��� 
	line_trim(b);
	cout<<"b.cpp ���˺����:"<<endl; print(b); cout<<endl;
	
	
	// ��ȡ���� 
	vector<string> b_vars = get_var(b);
	cout<<"b.cpp ������ȡ:"<<endl; print(b_vars);	cout<<endl;
	replace_var_null(b, b_vars);
	// replace_var(b, b_vars);
	cout<<"b.cpp �滻���������:"<<endl; print(b); cout<<endl;
	
	
	cout<<endl<<"--------------------------------"<<endl<<endl;
	
	// ����ƥ����S / D���� 
	#define r 0.9
	vector<vector<int>> D(a.size()), S(a.size());
	for(int i=0; i<S.size(); i++) S[i].resize(b.size()), D[i].resize(b.size());
	for(int i=0; i<S.size(); i++)
		for(int j=0; j<S[0].size(); j++)
			S[i][j] = rate_lcs(a[i],b[j]), D[i][j]=(S[i][j]>r)?(1):(0);
			// S[i][j] = rate_edis(a[i],b[j]), D[i][j]=(S[i][j]>r)?(1):(0);
	
	// ��LCSƥ��
	cout<<"��LCSƥ��"<<endl; 
	vector<vector<int>> sim_ab = lcs_str(D);
	cout<<endl;
	cout<<left<<setw(30)<<"a.cpp ƥ��Ĵ���";
	cout<<"                             ";
	cout<<left<<setw(30)<<"b.cpp ƥ��Ĵ���"<<endl;
	for(int i=0; i<sim_ab.size(); i++)
	{
		cout<<left<<setw(30)<<a[sim_ab[i][0]];
		cout<<"                             ";
		cout<<left<<setw(30)<<b[sim_ab[i][1]]<<endl;
	}
	
	double ra = (double)sim_ab.size() / (double)(min(a.size(), b.size()));
	cout<<endl<<"ƥ����Ϊ: "<<ra<<endl;
	
	cout<<endl<<"--------------------------------"<<endl<<endl;
	
	// ����ƥ��
	cout<<"����ƥ��"<<endl; 
	sim_ab = violate_match(S, r);
	cout<<endl;
	cout<<left<<setw(30)<<"a.cpp ƥ��Ĵ���";
	cout<<"                             ";
	cout<<left<<setw(30)<<"b.cpp ƥ��Ĵ���"<<endl;
	for(int i=0; i<sim_ab.size(); i++)
	{
		cout<<left<<setw(30)<<a[sim_ab[i][0]];
		cout<<"                             ";
		cout<<left<<setw(30)<<b[sim_ab[i][1]]<<endl;
	}
	
	ra = (double)sim_ab.size() / (double)(min(a.size(), b.size()));
	cout<<endl<<"ƥ����Ϊ: "<<ra<<endl;
	
	cout<<endl<<"--------------------------------"<<endl<<endl;
	
	
	/*
	// ������ϵ��ͼƥ�� 
	vector<string> a, b;
	// ��ȡԴ�ļ� 
	readfile("a4.cpp", a);
	cout<<"a.cpp ԭʼ����:"<<endl; print(a); cout<<endl;
	// �й��˴��� 
	line_trim(a);
	cout<<"aaa.cpp ���˺����:"<<endl; print(a); cout<<endl;
	// ��ȡ���� 
	vector<string> a_vars = get_var(a);
	cout<<"aaa.cpp ������ȡ:"<<endl; print(a_vars);	cout<<endl;
	// ������ϵ��ͼ
	vector<vector<int>> adj_a = get_var_adj(a, a_vars); 
	
	cout<<endl<<"--------------------------------"<<endl<<endl;
	
	// ��ȡԴ�ļ� 
	readfile("b4.cpp", b);
	cout<<"bbb.cpp ԭʼ����:"<<endl; print(b); cout<<endl;
	// �й��˴��� 
	line_trim(b);
	cout<<"bbb.cpp ���˺����:"<<endl; print(b); cout<<endl;
	// ��ȡ���� 
	vector<string> b_vars = get_var(b);
	cout<<"b.cpp ������ȡ:"<<endl; print(b_vars);	cout<<endl;
	// ������ϵ��ͼ
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
	
	cout<<"ƥ����Ϊ"<<(double)cc/min(a.size(), b.size())/2<<endl;
	
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
