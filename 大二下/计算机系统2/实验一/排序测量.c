#include<stdio.h>
#include<stdlib.h>
#include<time.h>
void insert_sort(int n[],int t)
{
	srand(time(NULL));
	int i,j,k,aim=0;
	for(i=1;i<t;i++) 
	{
		aim=n[i];//目标数
		for(j=i-1;j>=0;j--)//待比较数 
		{
			if(aim<n[j])//若目标数小于待比较数 
			{//目标数放比较数前面 
				n[j+1]=n[j];//退后一格 
			}
			else 
			{
				break;//找到与目标数位置 
			}
		}
		if(aim!=n[i])//比对  如果目标数有位置则安排到相应位置 
		{
			n[j+1]=aim;
		}
	}
 }  
void quick_sort(int n[],int left,int right)
{
	if(left<right)
	{
		int i=left,j=right;
		int x=n[left];//挖基础坑 
		while(i<j&&n[i]<n[j])
			j--;		//从右边开始找坑 
		if(n[j]<=n[i])
		{
			n[i]=n[j];//填左边坑  
			i++;
		}
		while(i<j&&n[i]<n[j])
			i++;
		if(n[i]>=n[j])
		{
			n[j]=n[i];
			j--;
		}
	
		n[i]=x;
		//分治法  表明已经排好n[i]的位置 
		quick_sort(n,left,i-1);
		quick_sort(n,i+1,right);

	}
 } 
void combine(int n[],int left,int right)
{
	int length=right-left+1,j=0;
	int b[length],i=0,left0=left;
	int mid=(left+right)/2,k=mid+1;//right 与mid都为限制条件 
	while((left<=mid)&&(k<=right))
	{
		if(n[left]<n[k])
			b[i++]=n[left++];
		else
			b[i++]=n[k++];//判断最左谁小，小的就进一 
	}
	if (left>mid)//判断第一个多余 
		for(k;k<=right;k++)
			b[i++]=n[k];
	if(k>right)//判断第二个多余 
		for(left;left<=mid;left++)
			b[i++]=n[left];
	j=0; 
	for(j=0;j<length;j++)
		n[left0++]=b[j]; //将b数组有序值给n数组 
 } 
void divide(int n[],int left,int right)
{//left 为数组第一个元素 right为数组最后一个元素 
	if(left==right)
	{
		return;//如果只有一个元素则返回 
	}
	if(left<right)
	{
		int mid=(left+right)/2;//分开两半
		divide(n,left,mid);
		divide(n,mid+1,right);
		combine(n,left,right);
		
	}
 } 
 
 
//------------------------------------------------------------------------
int main()
{
	int k=0,n[100000],t=0,b;
	scanf("%d",&t);
	int i,j,num=0;
	double p=0;
//	for(k=0;k<20;k++)
//	{
//	for(i=0;i<t;i++)
//	{
//		num=rand();
//		n[i]=num;
//		
//	}
//	float start,finish;
//	double Total_time;
//	p=0;
//	
//	
//	
//	//选择排序 
//	start=clock();
//	for(i=0;i<t;i++)
//	{
//		for(j=i+1;j<t;j++)
//		{
//			if(n[i]>n[j])
//			{
//				b=n[i];
//				n[i]=n[j];
//				n[j]=b;
//			}
//		 } 
//	}
//	finish=clock();
//	Total_time=(double)(finish-start)/CLOCKS_PER_SEC;
//	p=p+Total_time;
//	
//	}
//	p=p/20;
//	printf("选择排序20组运行平均时间为：");
//	printf("%lf\n",p);
//	printf("-------------------------------------\n");
//	
//	
//	//冒泡排序 
//	for(k=0;k<20;k++)
//	{
//	for(i=0;i<t;i++)
//	{
//		num=rand();
//		n[i]=num;
//		
//	}
//	float start,finish;
//	double Total_time;
//	p=0;
//	start=clock();
//	for(i=0;i<t-1;i++)
//	{
//		for(j=0;j<t-1-i;j++)
//		{
//			if(n[j]>n[j+1])
//			{
//				b=n[j];
//				n[j]=n[j+1];
//				n[j+1]=b;
//			}
//		}
//	}
//	finish=clock();
//	Total_time=(double)(finish-start)/CLOCKS_PER_SEC;
//	p=p+Total_time;
//	
//	}
//	p=p/20;
//	printf("冒泡排序20组运行平均时间为：");
//	printf("%lf\n",p);
//	printf("-------------------------------------\n");
//	
//	
//	
//	
//	//插入排序
//	for(k=0;k<20;k++)
//	{
//	for(i=0;i<t;i++)
//	{
//		num=rand();
//		n[i]=num;
//		
//	}
//	float start,finish;
//	double Total_time;
//	p=0;
//	start=clock();
//	insert_sort(n,t);
//	finish=clock();
//	Total_time=(double)(finish-start)/CLOCKS_PER_SEC;
//	p=p+Total_time;
//	
//	}
//	p=p/20;
//	printf("插入排序20组运行平均时间为：");
//	printf("%lf\n",p);
//	printf("-------------------------------------\n");
//	 
//	
	//合并排序 
	for(k=0;k<20;k++)
	{
	for(i=0;i<t;i++)
	{
		num=rand();
		n[i]=num;
		
	}
	float start,finish;
	double Total_time;
	p=0;
	start=clock();
	divide(n,0,t);
	
	
	
	
	finish=clock();
	Total_time=(double)(finish-start)/CLOCKS_PER_SEC;
	p=p+Total_time;
	
	}
	p=p/20;
	printf("合并排序20组运行平均时间为：");
	printf("%lf\n",p);
	printf("-------------------------------------\n");
	
//	//快速排序
//	for(k=0;k<20;k++)
//	{
//	for(i=0;i<t;i++)
//	{
//		num=rand();
//		n[i]=num;
//		
//	}
//	float start,finish;
//	double Total_time;
//	p=0;
//	start=clock();
//	quick_sort(n,0,t);
//	finish=clock();
//	Total_time=(double)(finish-start)/CLOCKS_PER_SEC;
//	p=p+Total_time;
//	
//	}
//	p=p/20;
//	printf("快速排序20组运行平均时间为：");
//	printf("%lf\n",p);
//	printf("-------------------------------------\n"); 
//	
}
