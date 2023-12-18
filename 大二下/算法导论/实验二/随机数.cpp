#include<iostream>
#include<fstream>
#include<ctime> 
#include<stdlib.h>
#include<float.h>
#include<cmath>
using namespace std;
#define N 100000
struct point{    //生成点 
	double x;
	double y;
};
void born_point(point *points){

	int i;
	for(i=0;i<N;i++)
	{
		points[i].x=rand()+(double)rand()/RAND_MAX;
		points[i].y=rand()+(double)rand()/RAND_MAX;
		cout<<points[i].x<<" "<<points[i].y<<endl;
	}
}
int main()
{
	srand((unsigned)time(NULL));
	point p[100000];
	int i,j;
	for(j=0;j<10;j++)   //循环十次生成100万个随机点 
	{ 
	born_point(p);
//	ofstream outfile;
//	outfile.open("C:/Users/11440/Desktop/Test.txt",ios::app);
//	for(i=0;i<N;i++)
//	{
//	outfile<<p[i].x<<" "<<p[i].y<<endl;
// } 
// outfile.close();
}
} 
