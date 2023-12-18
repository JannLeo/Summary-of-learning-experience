#include <iostream>
#include <vector>
#include <algorithm>
#include <ctime>
#include <cstdlib>
#include <stack>

using namespace std;

/*
function   : 输出一个数组 
param nums : 要输出的数组引用 
return     : ---
*/
void out(vector<int>& nums)
{
	for(int i=0; i<nums.size(); i++)
		cout<<nums[i]<<" ";
	cout<<endl;
}

/*
function   : 对数组进行选择排序 
param nums : 要排序的数组引用 
return     : ---
*/
void select_sort(vector<int>& nums)
{
	for(int i=0; i<nums.size(); i++)
	{
		int id=i, val=nums[id];
		for(int j=i+1; j<nums.size(); j++)		
			if(nums[j]<val) val=nums[j], id=j;		
		swap(nums[id], nums[i]);
	}
}

/*
function         : 对数组进行冒泡排序 
param nums       : 要排序的数组引用 
param early_stop : 是否提前结束 
return     : ---
*/
void bubble_sort(vector<int>& nums, bool early_stop)
{
	for(int i=0; i<nums.size(); i++)
	{
		bool flag = false;
		for(int j=1; j<nums.size()-i; j++)
			if(nums[j]<nums[j-1]) 
				swap(nums[j], nums[j-1]), flag=true;
		if(!flag && early_stop) break;
	}
}

/*
function   : 对数组进行插入排序 
param nums : 要排序的数组引用 
return     : ---
*/
void insert_sort(vector<int>& nums)
{
	for(int i=1; i<nums.size(); i++)
	{
		int j=i, key=nums[j];
		while(j>0 && nums[j-1]>key)
			nums[j]=nums[j-1], j--;
		nums[j] = key;
	}
}

/*
function   : 对nums的子数组进行分治归并排序 
param nums : 要排序的数组引用 
param l    : 子数组范围 左边界 
param r    : 子数组范围 右边界 
return     : ---
explain    : 左右边界都是闭区间 
*/
void merge_sort(vector<int>& nums, int l, int r)
{
	if(l<0 || r>=nums.size() || l==r) return;
	int mid = (l+r)/2;
	merge_sort(nums, l, mid);
	merge_sort(nums, mid+1, r);
	inplace_merge(nums.begin()+l, nums.begin()+mid+1, nums.begin()+r+1); 
}

/*
function   : 对数组进行二路归并排序 
param nums : 要排序的数组引用 
return     : ---
*/
void merge_sort(vector<int>& nums)
{
	int step = 1;
	while(step<nums.size())
	{
		for(int i=0; i+step<nums.size(); i+=step*2)
		{
			int l=i, mid=i+step, r=min((int)nums.size(), i+step*2);
			inplace_merge(nums.begin()+l, nums.begin()+mid, nums.begin()+r);	
		}
		step *= 2;
	}
}

/*
function   : 对nums的子数组进行快速排序 
param nums : 要排序的数组引用 
param l    : 子数组范围 左边界 
param r    : 子数组范围 右边界 
return     : ---
explain    : 左右边界都是闭区间 
*/
void quick_sort(vector<int>& nums, int l, int r)
{
	if(l<0 || r>=nums.size() || l>=r) return;
	int key=nums[l], i=l, j=r;
	while(i<j)
	{
		while(i<j && nums[j]>=key) j--;
		swap(nums[i], nums[j]);
		while(i<j && nums[i]<=key) i++;
		swap(nums[i], nums[j]);
	}
	nums[i] = key;
	quick_sort(nums, l, i-1);
	quick_sort(nums, i+1, r);
}

/*
function   : 对nums的子数组进行快速排序 
param nums : 要排序的数组引用 
return     : ---
explain    : 递归会爆栈空间，写了个非递归的，还是爆 
*/
void quick_sort(vector<int>& nums)
{
	typedef struct node
	{
		int l, r, state;
		node(int L, int R, int S):l(L),r(R),state(S){}
	}node;
	
	stack<node> s; s.push(node(0, nums.size()-1, 0));
	while(!s.empty())
	{
		node tp=s.top();
		if(tp.state==0)
		{
			if(tp.l<0 || tp.r>=nums.size() || tp.l>=tp.r){s.pop(); continue;}
			int key=nums[tp.l], i=tp.l, j=tp.r;
			while(i<j)
			{
				while(i<j && nums[j]>=key) j--;
				nums[i] = nums[j];
				while(i<j && nums[i]<=key) i++;
				nums[j] = nums[i];
			}
			nums[i] = key;
			s.top().state++;
			s.push(node(tp.l, i-1, 0)), s.push(node(i+1, tp.r, 0));
		}
		else if(tp.state==1) s.pop();
	}
}

int main()
{ 
	double t1=0, t2=0, t3=0, t4=0, t5=0, t6=0;
	#define sample 20
	#define batch 10000
	int t = sample;
	while(t--)
	{
		cout<<t<<endl;
		int n=batch, limit=114514;
		vector<int> v(n), v1;
		for(int i=0; i<n; i++) v[i]=rand()%limit;
		//for(int i=0; i<n; i++) v[i]=n-i;
		
		clock_t startTime, endTime; 

		// select 
		v1 = v;
		startTime = clock();
		select_sort(v1);
	    endTime = clock();
		t1 += (double)(endTime - startTime) / CLOCKS_PER_SEC;
		cout<<"select_sort "<<t<<" "<< endTime - startTime<<endl;
		
		// bubble_sort 1
		v1 = v;
		startTime = clock();
		bubble_sort(v1, false);
	    endTime = clock();
		t2 += (double)(endTime - startTime) / CLOCKS_PER_SEC;
		cout<<"bubble_sort "<<t<<" "<< endTime - startTime<<endl;
		
		// bubble_sort 2 
		v1 = v;
		startTime = clock();
		bubble_sort(v1, true);
	    endTime = clock();
		t3 += (double)(endTime - startTime) / CLOCKS_PER_SEC;
		cout<<"bubble_sort2 "<<t<<" "<< endTime - startTime<<endl;
		
		// insert_sort 
		v1 = v;
		startTime = clock();
		insert_sort(v1);
	    endTime = clock();
		t4 += (double)(endTime - startTime) / CLOCKS_PER_SEC;
		cout<<"insert_sort "<<t<<" "<< endTime - startTime<<endl;
		
		// merge_sort 
		v1 = v;
		startTime = clock();
		merge_sort(v1);
	    endTime = clock();
		t5 += (double)(endTime - startTime) / CLOCKS_PER_SEC;
		cout<<"merge_sort "<<t<<" "<< endTime - startTime<<endl;
		
		// quick_sort 
		v1 = v;
		startTime = clock();
		quick_sort(v1, 0, v1.size()-1);
		// quick_sort(v1);
	    endTime = clock();
		t6 += (double)(endTime - startTime) / CLOCKS_PER_SEC;
		cout<<"quick_sort "<<t<<" "<< endTime - startTime<<endl;
	}
	
	cout<<t1/sample<<endl;
	cout<<t2/sample<<endl;
	cout<<t3/sample<<endl;
	cout<<t4/sample<<endl;
	cout<<t5/sample<<endl;
	cout<<t6/sample<<endl;
	
	return 0;
}
