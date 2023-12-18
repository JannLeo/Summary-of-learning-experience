#include <bits/stdc++.h>

using namespace std;

typedef struct p
{
	int x, y;
	p(){}
	p(int X, int Y):x(X),y(Y){}	
}p;

/*
������С��������ֹĬ��min��int�βνض� 
*/
double lfmin(double a, double b)
{
	return (a<b)?(a):(b);
}

/*
�ȽϺ����������ã�x����x��ͬ��y����
param p1 : ��һ����
param p2 : �ڶ����� 
return   : p1 ǰ�� p2 ? 
*/
bool cmpx(const p& p1, const p& p2)
{
	if(p1.x==p2.x) return p1.y<p2.y;
	return p1.x<p2.x;
}

/*
�ȽϺ����������ã���y���򣬹鲢�� 
param p1 : ��һ����
param p2 : �ڶ����� 
return   : p1 ǰ�� p2 ? 
*/
bool cmpy(const p& p1, const p& p2)
{
	return p1.y<p2.y;
}

/*
�������ŷ�Ͼ��� 
param p1 : ��һ����
param p2 : �ڶ����� 
return   : ���룬������ 
*/
double dis(const p& p1, const p& p2)
{
	return sqrt((double)(p1.x-p2.x)*(p1.x-p2.x)+(double)(p1.y-p2.y)*(p1.y-p2.y));
}

/*
������ˮƽ���� 
param p1 : ��һ����
param p2 : �ڶ����� 
return   : ˮƽ���룬������ 
*/
double disX(const p& p1, const p& p2)
{
	double ans = (double)p1.x - (double)p2.x;
	if(ans<0) return ans*-1;
	return ans;
}

/*
���ع�ϣ��������ϣsetȥ�ظ�����
param p : ��
return  : ���ݵ�����õ��Ĺ�ϣֵ 
*/
struct hashfunc
{
	size_t operator()(const p& P) const
	{
		return size_t(P.x*114514 + P.y);
	}	
};

/*
���رȽϺ�������ϣsetȥ�ظ�����
param p1 : ��һ����
param p2 : �ڶ����� 
return  : �����Ƿ���ͬ 
*/
struct eqfunc
{
	bool operator()(const p& p1, const p& p2) const
	{
		return ((p1.x==p2.x)&&(p1.y==p2.y));
	}	
};

/*
�������������
param points : �������
return       : �����Ծ��� 
*/ 
double cp(vector<p>& points)
{
	double ans = (double)INT_MAX;
	for(int i=0; i<points.size(); i++)
		for(int j=i+1; j<points.size(); j++)
			ans = lfmin(ans, dis(points[i], points[j]));
	return ans;
}

/*
������������ԣ����Ӷ�O(nlog(n)log(n)) 
param points : �������
param l      : ��������˵�
param r      : �������Ҷ˵� 
return       : �����Ծ��� 
explain      : ����[l, r]����ұ� 
*/ 
double cp(vector<p>& points, int l, int r)
{
	if(l>=r) return (double)INT_MAX;
	if(l+1==r) return dis(points[l], points[r]);
	int mid=(l+r)/2, le=mid, ri=mid, h=0;
	double d=lfmin(cp(points, l, mid), cp(points, mid+1, r)), ans=d;
	vector<p> ll, rr;
	while(le>=l && disX(points[mid], points[le])<=d) ll.push_back(points[le]), le--;
	while(ri<=r && disX(points[mid], points[ri])<=d) rr.push_back(points[ri]), ri++;
	sort(ll.begin(), ll.end(), cmpy), sort(rr.begin(), rr.end(), cmpy);
	for(int i=0; i<ll.size(); i++)
	{
		while(h<rr.size() && rr[h].y+d<ll[i].y) h++; h=min((int)rr.size(), h);
		for(int j=h; j<min((int)rr.size(), h+6); j++)
			if(!eqfunc()(ll[i], rr[j])) ans=lfmin(ans, dis(ll[i], rr[j])); 
	}
	return lfmin(ans, d);
}

/*
����+�鲢��������ԣ����Ӷ�O(nlog(n)) 
param points : �������
param l      : ��������˵�
param r      : �������Ҷ˵� 
return       : �����Ծ��� 
explain      : ����[l, r]����ұ� 
*/ 
double cpm(vector<p>& points, int l, int r)
{
	if(l>=r) return (double)INT_MAX;
	if(l+1==r) 
	{
		if(cmpy(points[r], points[l])) swap(points[l], points[r]);
		return dis(points[l], points[r]);
	}
	int mid=(l+r)/2, le=mid, ri=mid, h=0;
	p midp = points[mid];
	double d=lfmin(cpm(points, l, mid), cpm(points, mid+1, r)), ans=d;
	inplace_merge(points.begin()+l, points.begin()+mid+1, points.begin()+r+1, cmpy);
	vector<p> ll, rr;
	for(int i=l; i<=r; i++)
	{
		if(midp.x>=points[i].x && disX(midp, points[i])<=d) ll.push_back(points[i]);
		if(midp.x<=points[i].x && disX(midp, points[i])<=d) rr.push_back(points[i]);
	}
	for(int i=0; i<ll.size(); i++)
	{
		while(h<rr.size() && rr[h].y+d<ll[i].y) h++; h=min((int)rr.size(), h);
		for(int j=h; j<min((int)rr.size(), h+6); j++)
			if(!eqfunc()(ll[i], rr[j])) ans=lfmin(ans, dis(ll[i], rr[j])); 
	}
	return lfmin(ans, d);
}

int main()
{
	// ����������� 
	int n,x,y,t,cnt=0; 
	double t1=0, t2=0, t3=0;
	#define sample 20 
	#define batch 500000
	#define lower 0
	#define upper (int)sqrt(batch)+1
	t = sample;
	n = batch;
	vector<p>  pp(n), p1, p2, p3;
	for(int i=0; i<upper&&cnt<n; i++)
		for(int j=0; j<upper&&cnt<n; j++)
			pp[cnt].x=i, pp[cnt++].y=j;
	
	while(t--)
	{
		cout<<t<<endl;
		p1=pp; p2=pp;
		clock_t st, ed; 
		double ans1, ans2, ans3;
		
		sort(p1.begin(), p1.end(), cmpx);
		st = clock();
		ans1 = cp(p1, 0, p1.size()-1);
		ed = clock();
		t1 += (double)(ed - st) / CLOCKS_PER_SEC;
		cout<<(double)(ed - st) / CLOCKS_PER_SEC<<endl;
		
		sort(p2.begin(), p2.end(), cmpx);
		st = clock();
		ans2 = cpm(p2, 0, p2.size()-1);
		ed = clock();
		t2 += (double)(ed - st) / CLOCKS_PER_SEC;
		cout<<(double)(ed - st) / CLOCKS_PER_SEC<<endl;
	}
	cout<<"--"<<endl;
	cout<<t1/sample<<endl;	// ��     ��
	cout<<t2/sample<<endl;	// ����+�鲢
	
	/*
	// һ����� 
	int n,x,y,t; 
	double t1=0, t2=0, t3=0;
	
	#define sample 50 
	#define batch 50000
	#define lower 0
	#define upper (int)sqrt(batch)*3
	
	t = sample;
	n = batch;
		
	default_random_engine rd(time(NULL));
	uniform_int_distribution<int> dist(lower, upper);

	vector<p>  pp(n), p1, p2, p3;

	while(t--)
	{
		unordered_set<p, hashfunc, eqfunc> hash;
		for(int i=0; i<n; i++)
		{
			pp[i].x = dist(rd);
			pp[i].y = dist(rd);
			if(i%(batch/10)==0)
				cout<<"������"<<i/(batch/10)<<" : ("<<pp[i].x<<", "<<pp[i].y<<"), ��Χ:[0,"<<upper<<"]"<<endl;
			if(hash.find(pp[i])==hash.end()) hash.insert(pp[i]);
			else i--;
		}
		cout<<"�����飺"<<sample-t<<endl;
		p1=pp, p2=pp, p3=pp;
		
		clock_t st, ed; 
		double ans1, ans2, ans3;
		
		sort(p1.begin(), p1.end(), cmpx);
		st = clock();
		ans1 = cp(p1, 0, p1.size()-1);
		ed = clock();
		t1 += (double)(ed - st) / CLOCKS_PER_SEC;
		
		sort(p2.begin(), p2.end(), cmpx);
		st = clock();
		ans2 = cpm(p2, 0, p2.size()-1);
		ed = clock();
		t2 += (double)(ed - st) / CLOCKS_PER_SEC;
		
		st = clock();
		//ans3 = cp(p3);
		ed = clock();
		t3 += (double)(ed - st) / CLOCKS_PER_SEC;
	}

	cout<<t1/sample<<endl;	// ��     ��
	cout<<t2/sample<<endl;	// ����+�鲢
	cout<<t3/sample<<endl;	// ��     ��
	*/
	
	/*
	// �뱩�����Աȣ�������ȷ�ԣ� 2715633 �������������ȫ����ȷ 
	int n,x,y,t; 
	double t1, t2, t3;
	
	#define sample 20 
	#define batch 50
	#define lower 0
	#define upper 1000000
	
	t = sample;
	n = batch;
		
	default_random_engine rd(time(NULL));
	uniform_int_distribution<int> dist(lower, upper);

	vector<p>  pp(n), p1, p2, p3;
	
	long long tt=0;
	while(1)
	{
		unordered_set<p, hashfunc, eqfunc> hash;
		
		for(int i=0; i<n; i++)
		{
			pp[i].x = dist(rd);
			pp[i].y = dist(rd);
			if(hash.find(pp[i])==hash.end()) hash.insert(pp[i]);
			else i--;
		}
		p1=pp, p2=pp, p3=pp;
		cout<<"�������� "<<tt<<endl;
		tt++;
		
		clock_t st, ed; 
		double ans1, ans2, ans3;
		
		st = clock();
		sort(p1.begin(), p1.end(), cmpx);
		ans1 = cp(p1, 0, p1.size()-1);
		ed = clock();
		t1 += (double)(ed - st) / CLOCKS_PER_SEC;
		
		st = clock();
		sort(p2.begin(), p2.end(), cmpx);
		ans2 = cpm(p2, 0, p2.size()-1);
		ed = clock();
		t2 += (double)(ed - st) / CLOCKS_PER_SEC;
		
		st = clock();
		ans3 = cp(p3);
		ed = clock();
		t3 += (double)(ed - st) / CLOCKS_PER_SEC;
	
		if(ans1!=ans3 || ans2!=ans3 || ans1!=ans2)
		{
			for(int i=0; i<pp.size(); i++)
				cout<<"("<<pp[i].x<<", "<<pp[i].y<<endl;	
			break;
		};
	}
	*/
	
	return 0;
}

/*
12
1 1
1 2
2 0
2 1
2 3
3 1
3 3
4 0
4 2
5 1
5 4
6 2

2715633

6 81
50 0
32 48
63 14
41 33
0 8
17 80
68 87
26 43
28 70
*/
