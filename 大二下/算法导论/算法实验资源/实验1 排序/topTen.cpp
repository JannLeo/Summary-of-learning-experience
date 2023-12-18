#include <iostream>
#include <vector>
#include <algorithm>
#include <queue>
#include <ctime>
#include <cstdlib>

using namespace std;

/*
function   : ���һ������ 
param nums : Ҫ������������� 
return     : ---
*/
void out(vector<int>& nums)
{
	for(int i=0; i<nums.size(); i++)
		cout<<nums[i]<<" ";
	cout<<endl;
}

/*
function   : �ҵ�һ����������k��Ԫ�� 
param nums : Ŀ����������� 
param k    : ������k��Ԫ�� 
return     : k��Ԫ����ɵ����� 
explain    : ����Ȼ��ȡǰʮ��Ԫ�أ����Ӷ� O(nlog(n))  
*/
vector<int> topK_1(vector<int>& nums, int k)
{
	sort(nums.begin(), nums.end(), greater<int>());
	return vector<int>(nums.begin(), nums.begin()+k);
}

/*
function   : �ҵ�һ����������k��Ԫ�� 
param nums : Ŀ����������� 
param k    : ������k��Ԫ�� 
return     : k��Ԫ����ɵ����� 
explain    : ��k�Σ����Ӷ� O(nk)
*/
vector<int> topK_2(vector<int>& nums, int k)
{
	vector<int> ans;
	for(int i=0; i<k; i++)
	{
		int idx = max_element(nums.begin(), nums.end())-nums.begin();
		ans.push_back(nums[idx]);
		nums[idx] = INT_MIN;
	}
	return ans;
}

/*
function   : �ҵ�һ����������k��Ԫ�� 
param nums : Ŀ����������� 
param k    : ������k��Ԫ�� 
return     : k��Ԫ����ɵ����� 
explain    : ά����СΪk��С���ѣ����Ӷ� O(nlog(k)) 
*/
vector<int> topK_3(vector<int>& nums, int k)
{
	priority_queue<int, vector<int>, greater<int> > q;
	for(int i=0; i<nums.size(); i++)
	{
		if(q.size()<k) q.push(nums[i]);
		else if(q.top()<nums[i]){q.pop(); q.push(nums[i]);}
	}
	vector<int> ans;
	while(!q.empty())
	{
		ans.push_back(q.top());
		q.pop();
	}
	return ans;
}

int main()
{
	/*
	// algorithm validation 
	vector<int> v = {1,3,6,8,2,12,11,5,14,4,9,17,15,7,19,10,16,13,18,20};
	vector<int> v1=v, v2=v, v3=v, ans;
	
	ans = topK_1(v1, 10);
	out(ans);
	
	ans = topK_2(v2, 10);
	out(ans);
	
	ans = topK_3(v3, 10);
	out(ans);
	*/
	
	// time validation
	#define sample 20
	#define batch 5000000
	int t = sample;
	double t1=0, t2=0, t3=0;
	int n=batch, limit=114514;
	clock_t startTime, endTime; 
	while(t--)
	{
		cout<<t<<endl;
		vector<int> v(n), v1, ans;
		for(int i=0; i<n; i++) v[i]=rand()%limit;
		
		// 1
		v1 = v;
		startTime = clock();
		ans = topK_1(v1, 10);
	    endTime = clock();
	    //out(ans);
		t1 += (double)(endTime - startTime) / CLOCKS_PER_SEC;
		
		// 2
		v1 = v;
		startTime = clock();
		ans = topK_2(v1, 10);
	    endTime = clock();
	    //out(ans);
		t2 += (double)(endTime - startTime) / CLOCKS_PER_SEC;
		
		// 3
		v1 = v;
		startTime = clock();
		ans = topK_3(v1, 10);
	    endTime = clock();
	    //out(ans);
		t3 += (double)(endTime - startTime) / CLOCKS_PER_SEC;
	}
	
	cout<<t1/sample<<endl;
	cout<<t2/sample<<endl;
	cout<<t3/sample<<endl;
	
	return 0;
}
