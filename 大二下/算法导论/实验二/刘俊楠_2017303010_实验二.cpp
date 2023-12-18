#include<iostream>
#include<fstream>    //�����ȡ�ļ� 
#include<stdlib.h>    
#include<ctime>   //��ʱ 
#include<float.h>   //�����ֵ 
#include<cmath>
using namespace std;
#define N 100000    //����㼯���ݴ�С 
#define MAX_distance DBL_MAX   //�������ֵ������ 
# define cmpXtimes 0  
# define cmpYtimes 1

struct point{   //����� 
	double x;
	double y;
}; 
point Left[N/2-1];    //���ҷָ������㼯 
point Right[N/2-1];
point p[N],q[N];   //p[N]���ڱ����㷨���   Q[n]���ڹ鲢�㷨���  ����Ϊȫ�ֱ���������� 
//void read_files(point *Point,point *Qoint){   //��ȡ�ļ� 
//	int i;
//	ifstream infile;
//	infile.open("C:/Users/11440/Desktop/��ҵ��μ�/�����/�㷨����/ʵ���/Test.txt",ios::in);
//	cout<<"Reading..."<<endl;
//	for(i=0;i<N;i++)
//	{ 
//	infile>>Point[i].x>>Point[i].y;
//	Qoint[i]=Point[i];
//	cout<<"�Ѷ�ȡ"<<i+1<<"����"<<endl; 
//}
//}
void born_point(point *p,point *q){    //ֱ�����ɵ� 
	int i;
	for(i=0;i<N;i++)
	{
		p[i].x=rand()+(double)rand()/RAND_MAX;
		p[i].y=rand()+(double)rand()/RAND_MAX;
//		cout<<p[i].x<<" "<<p[i].y<<endl<<endl;
		q[i]=p[i];
//		cout<<"������"<<i+1<<"����"<<endl;
	}
}
 
double point_distance(point a,point b){     //�������   �������ó�distance����  ������ 
	double dis;
	dis=(a.x-b.x)*(a.x-b.x)+(a.y-b.y)*(a.y-b.y);
//	cout<<dis<<endl;
	return dis;
}
double brute_sort(point *Point){   //�����㷨    ��������point���Ʊ���  ������ 
	int i,j;
	double min_vio=MAX_distance;
	for(i=0;i<N;i++){
		for(j=i+1;j<N;j++){    //�������Ƚ� 
			if(point_distance(Point[i],Point[j])<min_vio){
				min_vio=point_distance(Point[i],Point[j]);
			}
		}
//		cout<<"�ѱ�������"<<i+1<<"����"<<endl;
	}
	return min_vio;   //�����������С���� 
}
//�ϲ����� ��x����
void CombineX(point *p, int left, int mid, int right, int times)	
{
    int n1=mid-left;  //���߳��� 
    int n2=right-mid-1;  //�Ұ�߳��� 
    int i,j,k;
    for(i = 0; i<=n1; ++i){
        Left[i]=p[left + i];  //������������ 
    }

    for (j=0; j<=n2; ++j){
        Right[j]=p[mid+j+1];//�����Ұ������ 
    }
    
    if(times ==cmpXtimes){  //��x����ʱ 
        for (i=0, j=0, k=left;k<=right;k++)
        {
            if (i<=n1&&Left[i].x<=Right[j].x)   //��߱��ұ�С  �ȷ���� 
                p[k]=Left[i++];
            else if(j<=n2&&Left[i].x>=Right[j].x)  //�ұ߱����С  �ȷ��ұ�   
                p[k]=Right[j++];
            else if(i==n1+1&& j<=n2)//����������  �Ұ�߿�ʼ���� 
                p[k]=Right[j++];
            else if(j==n2+1&&i<=n1) // �Ұ��������  ���߿�ʼ���� 
                p[k]=Left[i++];
        }
    }
    else if (times == cmpYtimes)//��y����ʱ 
    {
        for (i=0,j=0,k=left;k<=right;k++)    //ͬ�� 
        {
            if (i<= n1 && Left[i].y <= Right[j].y)  //ͬ�� 
                p[k]=Left[i++];
            else if(j<=n2&&Left[i].y>= Right[j].y)
                p[k]=Right[j++];
            else if(i==n1+1&&j<=n2)
                p[k]=Right[j++];
            else if(j==n2+1&&i<=n1)
                p[k]=Left[i++];
        }
    }
}
void merge_sortX(point*p,int left,int right,int times){   // ���η��ķֿ�ʼ 
	if(left<right)
	{
		int mid=(left+right)/2;
		merge_sortX(p,left,mid,times);    //�ݹ���� 
		merge_sortX(p,mid+1,right,times);//�ݹ��ұ� 
		CombineX(p,left,mid,right,times);//�ϲ� 
	}
}
double Min_Dis(point *p,int left,int right){       //������С����  ��x��y�����ã� 
    if(right-left==1)    //ʣ������ʱ  
         return point_distance(p[left], p[right]);//������С���� 
     else if(right-left==2){   //3����ʱ 
        double d1=point_distance(p[left],p[right]);
        double d2=point_distance(p[left+1],p[right]);
        double d3=point_distance(p[left], p[left+1]);
        if(d1<=d2 && d1<=d3){     //����3����С���� 
            return d1;
        }           
        else if(d2<=d1 && d2 <=d3){
            return d2;
        }
        else
            return d3;
    }
    else if(right==left)   //һ����ʱ   �������ֵ  ��Ϊ��Ч 
        return MAX_distance;
    int mid=(right+left) / 2;
    double mid_x=p[mid].x;   //ȡ�м���xֵ 
    double dis_left=Min_Dis(p, left, mid);   //�ҵ���㼯��С���� 
    double dis_right=Min_Dis(p, mid + 1, right);   //�ҵ��ҵ㼯��С���� 
    double min_dis=(dis_left < dis_right) ? dis_left : dis_right; // �Ƚ�������С���� 
    double temp;
//    merge_sortX(p, left, right, cmpYtimes);    // x�������  ��y���в���  Ѱ���������� 
    int i,j,k;
    point *s = new point[N];   			 // ����ռ�   
    int s_pointindex = 0;                                  //�����м�㼯����
    for(i=left;i<=right;++i){
        if (abs(p[i].x-mid_x)<= sqrt(min_dis))
        {    //�Ƚϵó�s�����е�x-min_x���е�x+min_x���ڵ�ֵ,�ҵ��м���������ĵ�
            s[s_pointindex++]=p[i];         
        }
    }

    for (i=0;i<s_pointindex; i++)   //���м�����ĵ���м��� 
    {
        j = i-3;
        k = i+3;//ȡ6���� 
        if(j<0)
            j=0;
        if(k>s_pointindex)
            k=s_pointindex;
        for (;j<k&&j!=i;j++)
        {
            temp=(s[i].x-s[j].x)*(s[i].x-s[j].x)+(s[i].y-s[j].y)*(s[i].y-s[j].y);   //�����м�㼯����
            if (temp < min_dis)   //����η������̾���Ƚ�
                min_dis=temp;
        }
    }
    
    delete[] s;       //ɾ���ڴ� 
    return min_dis;   //������С���� 
}

int main()
{
//	int t;
//	for(t=0;t<20;t++)
//	{ 
	srand((unsigned)time(NULL));   //���Ӻ���һ��Ҫ������������  ���ں���������� 
	double Timebrute,Timemerge;
	clock_t Timestart[2],Timefinal[2];    //ʹ��ctime ���clock_t��ʱ���� 
	born_point(p,q);         //���ɵ㼯p �� q  �ֱ����ںϲ�����ͱ������� 
	double min_brute=0;
	//�����㷨  ������ʱ��
//	Timestart[0]=clock();//��ʱ��ʼ 
//	min_brute=brute_sort(p);   //�����㷨���� 
//	
//	Timefinal[0]=clock();//��ʱ���� 
	//�鲢�㷨  ������ʱ�� 
	Timestart[1]=clock(); 
	merge_sortX(q,0,N-1,cmpXtimes);
	double min_merge = Min_Dis(q, 0, N - 1);
	Timefinal[1]=clock();
	//ʹ��ctime���CLOCKS_PER_SEC�Ժ���Ϊ��λ����ʱ�� 
	Timebrute=Timefinal[0]-Timestart[0]/ (double)CLOCKS_PER_SEC * 1000;
	Timemerge=Timefinal[1]-Timestart[1]/ (double)CLOCKS_PER_SEC * 1000;
	cout<<"�����ģΪ:"<<N<<"����"<<endl; 
//	cout<<"�����㷨��̾���Ϊ��"<<sqrt(min_brute)<<endl;//��������㷨��̾���
//	cout<<"�����㷨����ʱ��:"<<Timebrute<<"ms"<<endl;
	cout<<"�ϲ��㷨��̾���Ϊ��"<<sqrt(min_merge)<<endl;//����ϲ��㷨��̾���
	cout<<"�ϲ��㷨����ʱ��:"<<Timemerge<<"ms"<<endl;
//}
}
