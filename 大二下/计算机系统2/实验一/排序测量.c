#include<stdio.h>
#include<stdlib.h>
#include<time.h>
void insert_sort(int n[],int t)
{
	srand(time(NULL));
	int i,j,k,aim=0;
	for(i=1;i<t;i++) 
	{
		aim=n[i];//Ŀ����
		for(j=i-1;j>=0;j--)//���Ƚ��� 
		{
			if(aim<n[j])//��Ŀ����С�ڴ��Ƚ��� 
			{//Ŀ�����űȽ���ǰ�� 
				n[j+1]=n[j];//�˺�һ�� 
			}
			else 
			{
				break;//�ҵ���Ŀ����λ�� 
			}
		}
		if(aim!=n[i])//�ȶ�  ���Ŀ������λ�����ŵ���Ӧλ�� 
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
		int x=n[left];//�ڻ����� 
		while(i<j&&n[i]<n[j])
			j--;		//���ұ߿�ʼ�ҿ� 
		if(n[j]<=n[i])
		{
			n[i]=n[j];//����߿�  
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
		//���η�  �����Ѿ��ź�n[i]��λ�� 
		quick_sort(n,left,i-1);
		quick_sort(n,i+1,right);

	}
 } 
void combine(int n[],int left,int right)
{
	int length=right-left+1,j=0;
	int b[length],i=0,left0=left;
	int mid=(left+right)/2,k=mid+1;//right ��mid��Ϊ�������� 
	while((left<=mid)&&(k<=right))
	{
		if(n[left]<n[k])
			b[i++]=n[left++];
		else
			b[i++]=n[k++];//�ж�����˭С��С�ľͽ�һ 
	}
	if (left>mid)//�жϵ�һ������ 
		for(k;k<=right;k++)
			b[i++]=n[k];
	if(k>right)//�жϵڶ������� 
		for(left;left<=mid;left++)
			b[i++]=n[left];
	j=0; 
	for(j=0;j<length;j++)
		n[left0++]=b[j]; //��b��������ֵ��n���� 
 } 
void divide(int n[],int left,int right)
{//left Ϊ�����һ��Ԫ�� rightΪ�������һ��Ԫ�� 
	if(left==right)
	{
		return;//���ֻ��һ��Ԫ���򷵻� 
	}
	if(left<right)
	{
		int mid=(left+right)/2;//�ֿ�����
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
//	//ѡ������ 
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
//	printf("ѡ������20������ƽ��ʱ��Ϊ��");
//	printf("%lf\n",p);
//	printf("-------------------------------------\n");
//	
//	
//	//ð������ 
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
//	printf("ð������20������ƽ��ʱ��Ϊ��");
//	printf("%lf\n",p);
//	printf("-------------------------------------\n");
//	
//	
//	
//	
//	//��������
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
//	printf("��������20������ƽ��ʱ��Ϊ��");
//	printf("%lf\n",p);
//	printf("-------------------------------------\n");
//	 
//	
	//�ϲ����� 
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
	printf("�ϲ�����20������ƽ��ʱ��Ϊ��");
	printf("%lf\n",p);
	printf("-------------------------------------\n");
	
//	//��������
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
//	printf("��������20������ƽ��ʱ��Ϊ��");
//	printf("%lf\n",p);
//	printf("-------------------------------------\n"); 
//	
}
