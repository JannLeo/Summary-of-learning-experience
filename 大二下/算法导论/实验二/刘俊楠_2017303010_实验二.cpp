#include<iostream>
#include<fstream>    //保存读取文件 
#include<stdlib.h>    
#include<ctime>   //计时 
#include<float.h>   //给最大值 
#include<cmath>
using namespace std;
#define N 100000    //定义点集数据大小 
#define MAX_distance DBL_MAX   //定义最大值变量名 
# define cmpXtimes 0  
# define cmpYtimes 1

struct point{   //定义点 
	double x;
	double y;
}; 
point Left[N/2-1];    //左右分割的数组点集 
point Right[N/2-1];
point p[N],q[N];   //p[N]用于暴力算法求解   Q[n]用于归并算法求解  定义为全局变量放入堆中 
//void read_files(point *Point,point *Qoint){   //读取文件 
//	int i;
//	ifstream infile;
//	infile.open("C:/Users/11440/Desktop/作业与课件/大二下/算法导论/实验二/Test.txt",ios::in);
//	cout<<"Reading..."<<endl;
//	for(i=0;i<N;i++)
//	{ 
//	infile>>Point[i].x>>Point[i].y;
//	Qoint[i]=Point[i];
//	cout<<"已读取"<<i+1<<"个点"<<endl; 
//}
//}
void born_point(point *p,point *q){    //直接生成点 
	int i;
	for(i=0;i<N;i++)
	{
		p[i].x=rand()+(double)rand()/RAND_MAX;
		p[i].y=rand()+(double)rand()/RAND_MAX;
//		cout<<p[i].x<<" "<<p[i].y<<endl<<endl;
		q[i]=p[i];
//		cout<<"已生成"<<i+1<<"个点"<<endl;
	}
}
 
double point_distance(point a,point b){     //计算距离   不可设置成distance函数  会重名 
	double dis;
	dis=(a.x-b.x)*(a.x-b.x)+(a.y-b.y)*(a.y-b.y);
//	cout<<dis<<endl;
	return dis;
}
double brute_sort(point *Point){   //暴力算法    不可设置point名称变量  会重名 
	int i,j;
	double min_vio=MAX_distance;
	for(i=0;i<N;i++){
		for(j=i+1;j<N;j++){    //暴力法比较 
			if(point_distance(Point[i],Point[j])<min_vio){
				min_vio=point_distance(Point[i],Point[j]);
			}
		}
//		cout<<"已暴力计算"<<i+1<<"个点"<<endl;
	}
	return min_vio;   //暴力法算出最小距离 
}
//合并排序 并x排序
void CombineX(point *p, int left, int mid, int right, int times)	
{
    int n1=mid-left;  //左半边长度 
    int n2=right-mid-1;  //右半边长度 
    int i,j,k;
    for(i = 0; i<=n1; ++i){
        Left[i]=p[left + i];  //定义左半边数组 
    }

    for (j=0; j<=n2; ++j){
        Right[j]=p[mid+j+1];//定义右半边数组 
    }
    
    if(times ==cmpXtimes){  //对x排序时 
        for (i=0, j=0, k=left;k<=right;k++)
        {
            if (i<=n1&&Left[i].x<=Right[j].x)   //左边比右边小  先放左边 
                p[k]=Left[i++];
            else if(j<=n2&&Left[i].x>=Right[j].x)  //右边比左边小  先放右边   
                p[k]=Right[j++];
            else if(i==n1+1&& j<=n2)//左半边排序完  右半边开始排序 
                p[k]=Right[j++];
            else if(j==n2+1&&i<=n1) // 右半边排序完  左半边开始排序 
                p[k]=Left[i++];
        }
    }
    else if (times == cmpYtimes)//对y排序时 
    {
        for (i=0,j=0,k=left;k<=right;k++)    //同上 
        {
            if (i<= n1 && Left[i].y <= Right[j].y)  //同上 
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
void merge_sortX(point*p,int left,int right,int times){   // 分治法的分开始 
	if(left<right)
	{
		int mid=(left+right)/2;
		merge_sortX(p,left,mid,times);    //递归左边 
		merge_sortX(p,mid+1,right,times);//递归右边 
		CombineX(p,left,mid,right,times);//合并 
	}
}
double Min_Dis(point *p,int left,int right){       //返回最小距离  （x，y都适用） 
    if(right-left==1)    //剩两个点时  
         return point_distance(p[left], p[right]);//返回最小距离 
     else if(right-left==2){   //3个点时 
        double d1=point_distance(p[left],p[right]);
        double d2=point_distance(p[left+1],p[right]);
        double d3=point_distance(p[left], p[left+1]);
        if(d1<=d2 && d1<=d3){     //返回3点最小距离 
            return d1;
        }           
        else if(d2<=d1 && d2 <=d3){
            return d2;
        }
        else
            return d3;
    }
    else if(right==left)   //一个点时   返回最大值  因为无效 
        return MAX_distance;
    int mid=(right+left) / 2;
    double mid_x=p[mid].x;   //取中间点的x值 
    double dis_left=Min_Dis(p, left, mid);   //找到左点集最小距离 
    double dis_right=Min_Dis(p, mid + 1, right);   //找到右点集最小距离 
    double min_dis=(dis_left < dis_right) ? dis_left : dis_right; // 比较左右最小距离 
    double temp;
//    merge_sortX(p, left, right, cmpYtimes);    // x排序完成  对y进行操作  寻找最近距离点 
    int i,j,k;
    point *s = new point[N];   			 // 分配空间   
    int s_pointindex = 0;                                  //定义中间点集数量
    for(i=left;i<=right;++i){
        if (abs(p[i].x-mid_x)<= sqrt(min_dis))
        {    //比较得出s区域（中点x-min_x到中点x+min_x）内的值,找到中间区域包含的点
            s[s_pointindex++]=p[i];         
        }
    }

    for (i=0;i<s_pointindex; i++)   //对中间区域的点进行计算 
    {
        j = i-3;
        k = i+3;//取6个点 
        if(j<0)
            j=0;
        if(k>s_pointindex)
            k=s_pointindex;
        for (;j<k&&j!=i;j++)
        {
            temp=(s[i].x-s[j].x)*(s[i].x-s[j].x)+(s[i].y-s[j].y)*(s[i].y-s[j].y);   //计算中间点集距离
            if (temp < min_dis)   //与分治法求得最短距离比较
                min_dis=temp;
        }
    }
    
    delete[] s;       //删除内存 
    return min_dis;   //返回最小距离 
}

int main()
{
//	int t;
//	for(t=0;t<20;t++)
//	{ 
	srand((unsigned)time(NULL));   //种子函数一定要放在主函数中  放在函数里会重置 
	double Timebrute,Timemerge;
	clock_t Timestart[2],Timefinal[2];    //使用ctime 里的clock_t计时函数 
	born_point(p,q);         //生成点集p 与 q  分别用于合并排序和暴力排序 
	double min_brute=0;
	//暴力算法  并计算时间
//	Timestart[0]=clock();//计时开始 
//	min_brute=brute_sort(p);   //暴力算法计算 
//	
//	Timefinal[0]=clock();//计时结束 
	//归并算法  并计算时间 
	Timestart[1]=clock(); 
	merge_sortX(q,0,N-1,cmpXtimes);
	double min_merge = Min_Dis(q, 0, N - 1);
	Timefinal[1]=clock();
	//使用ctime里的CLOCKS_PER_SEC以毫秒为单位计算时间 
	Timebrute=Timefinal[0]-Timestart[0]/ (double)CLOCKS_PER_SEC * 1000;
	Timemerge=Timefinal[1]-Timestart[1]/ (double)CLOCKS_PER_SEC * 1000;
	cout<<"输入规模为:"<<N<<"个点"<<endl; 
//	cout<<"暴力算法最短距离为："<<sqrt(min_brute)<<endl;//输出暴力算法最短距离
//	cout<<"暴力算法所用时间:"<<Timebrute<<"ms"<<endl;
	cout<<"合并算法最短距离为："<<sqrt(min_merge)<<endl;//输出合并算法最短距离
	cout<<"合并算法所用时间:"<<Timemerge<<"ms"<<endl;
//}
}
