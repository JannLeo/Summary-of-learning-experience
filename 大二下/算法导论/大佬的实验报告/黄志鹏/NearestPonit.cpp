#include <iostream>
#include <ctime>
#include <cmath>
#include <float.h>
using namespace std;     //c++	

#define MAX_DIS DBL_MAX
#define N  10000
#define cmp_x 0
#define cmp_y 1
#define Trials 1
struct Point{
    double x;
    double y;
};
Point Left[50001];
Point Right[50001];
int MID_X;

double Distance(Point a, Point b){
    return (a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y);   //点距离计算
}
double Brute(Point *Points){    //计算最小距离？
    int i, j;
    double min = MAX_DIS;
    for (i = 0; i < N; ++i)
    {
        for (j = i + 1; j < N; ++j)
        {
            if(Distance(Points[i],Points[j]) < min)
                min = Distance(Points[i], Points[j]);
        }
    }
    return min;
}
void Generate_Points(Point *Points){    //产生随机数
    srand((unsigned)time(NULL));
    int i;
    for (i = 0; i < N; ++i){
        Points[i].x = rand()+rand()-1;
        Points[i].y = rand()+rand()-1;
    }
}
void Merge(Point *Points, int left, int mid, int right, int option)		//合并排序,p点，left=0,mid=9999，right=0；
{
    int n1 = mid - left;
    int n2 = right - mid - 1;
    int i, j, k;
    for(i = 0; i <= n1; ++i){
        Left[i] = Points[left + i];
    }

    for (j = 0; j <= n2; ++j){
        Right[j] = Points[mid + j + 1];
    }
    
    if(option == cmp_x){
        for (i = 0, j = 0, k = left; k <= right; ++k)
        {
            if (i <= n1 && Left[i].x <= Right[j].x)
                Points[k] = Left[i++];
            else if (j <= n2 && Left[i].x >= Right[j].x)
                Points[k] = Right[j++];
            else if (i == n1+1 && j <= n2)
                Points[k] = Right[j++];
            else if (j == n2+1 && i <= n1)
                Points[k] = Left[i++];
        }
    }
    else if (option == cmp_y)
    {
        for (i = 0, j = 0, k = left; k <= right; ++k)
        {
            if (i <= n1 && Left[i].y <= Right[j].y)
                Points[k] = Left[i++];
            else if (j <= n2 && Left[i].y >= Right[j].y)
                Points[k] = Right[j++];
            else if (i == n1 + 1 && j <= n2)
                Points[k] = Right[j++];
            else if (j == n2 + 1 && i <= n1)
                Points[k] = Left[i++];
        }
    }
}

void Merge_Sort(Point *Points,int left,int right, int option){
    if(left<right){
        int mid = (left + right) / 2;
        Merge_Sort(Points, left, mid, option);
        Merge_Sort(Points, mid + 1, right, option);
        Merge(Points,left, mid, right, option);
    }
 
}

double Min_Dis(Point *Points, int left, int right){       //返回最小距离
    if(right - left == 1)
        return Distance(Points[left], Points[right]);
    else if(right - left == 2){
        double d1 = Distance(Points[left], Points[right]);
        double d2 = Distance(Points[left+1], Points[right]);
        double d3 = Distance(Points[left], Points[right-1]);
        if(d1<=d2 && d1<=d3){
            return d1;
        }           
        else if(d2<=d1 && d2 <=d3){
            return d2;
        }
        else
            return d3;
    }
    else if(right == left)
        return MAX_DIS;

    int mid = (right + left ) / 2;
    double mid_x = Points[mid].x;
    double dis_left = Min_Dis(Points, left, mid);
    double dis_right = Min_Dis(Points, mid + 1, right);
    double min_dis = (dis_left < dis_right) ? dis_left : dis_right;
    double temp;

    Merge_Sort(Points, left, right, cmp_y);    // p点    left=0   right=9999 cmp_y=0 
    
    int i,j,k;
    Point *s = new Point[100000];   			 // 分配空间   
    int s_points_index = 0;
    for(i = 0; i <= right; ++i){
        if (abs(Points[i].x - mid_x) <= sqrt(min_dis))
        {    //比较的得出s区域（中点x-min_x到中点x+min_x）内的值
            s[s_points_index++] = Points[i];
        }
    }

    for (i = 0; i < s_points_index; ++i)
    {
        j = i - 4;
        k = i + 4;
        if(j < 0)
            j = 0;
        if(k > s_points_index)
            k = s_points_index;
        for (; j < k && j != i; ++j)
        {
            temp = (s[i].x - s[j].x) * (s[i].x - s[j].x) + (s[i].y - s[j].y) * (s[i].y - s[j].y);
            if (temp < min_dis)
                min_dis = temp;
        }
    }
    
    delete[] s;
    return min_dis;
}

int main(){
    double time_divide, time_brute;
    clock_t TimeInit[2], TimeFinal[2];
    Point p[100000];
    Generate_Points(p);
    //计算分治法所用时间
    TimeInit[0] = clock();
    Merge_Sort(p, 0, N - 1, cmp_x);          //p为点，N-1=9999 cmp_x=0;
    double Min_Distance_Divide = sqrt(Min_Dis(p, 0, N - 1));
    TimeFinal[0] = clock();

    //计算蛮力法所用时间
    TimeInit[1] = clock();
    double Min_Distance1_Brute = sqrt(Brute(p));
    TimeFinal[1] = clock();

    time_divide = (double)(TimeFinal[0] - TimeInit[0]) / (double)CLOCKS_PER_SEC * 1000;
    time_brute = (double)(TimeFinal[1] - TimeInit[1]) / (double)CLOCKS_PER_SEC * 1000;

    cout << "数据规模：" << N << endl;
    cout << "分治法所用时间：" <<time_divide << "ms" << endl;
    cout << "蛮力法法所用时间：" <<time_brute << "ms" << endl;
    cout << "分治法算出的距离：" << Min_Distance_Divide << endl;
    cout << "蛮力法算出的距离：" << (double)Min_Distance1_Brute << endl;

    int n;
    cin >> n;
    return 0;
}
