#include<iostream>
#include<vector>
#include<Windows.h>
using namespace std;
#define INT_MIN 0x80000000;
/*struct node {//设置链表结构体
	int x; //节点的编号
	node* next;
	node(int x_) {
		this->x = x_;
		next = nullptr;
	}

};*/
int color_except[451][451];//设置颜色排除矩阵
int color_flag1[451];//点颜色标记；若涂色则为1；
void add_edge(int n, int m, int* edge_max,int neiber2,int neiber1) {//邻接点赋值为1 增加边数 增加度数
	/*node* a = head[n][0];//找到第n个表头
	node* b = new node(m);//创建新邻接点
	node* c = new node(n);
	node* d = head[m][0];
	b->next = a->next;
	a->next = b;
	c->next = d->next;
	d->next = c;//头插法插入*/
	neiber1 = 1;
	neiber2 = 1;
	edge_max[n]++;
	edge_max[m]++;
}
bool ok(int point_num,int p_num,int **neiber,int *result) {//判断颜色是否可用
	for (int i = 1;i <= point_num;i++) {
		//判断相邻点位是否有相同颜色
			if (neiber[p_num][i] && result[i] == result[p_num])//相邻且颜色相等
			{
				color_except[p_num][result[i]] = 1;//该点颜色排除
				return false;//返回false 递归
			}

		
	}
	return true;
}
int findcolor(int** neiber, int* result, int p_num, int point_num, int color_num) {
	//查找还能用几种颜色
	int* color_flag = new int[color_num + 1];//颜色登记
	for (int i = 0;i <= color_num;i++)//初始化颜色登记
		color_flag[i] = 0;
	for (int i = 1;i <= point_num;i++) {//判断相邻点是否有color_num个不同颜色
		if (neiber[p_num][i]) {//相邻点判断
			if (result[i] <= color_num && result[i] > 0)//若相邻点有涂色 则标记
				color_flag[result[i]] = result[i];
		}
	}
	int fflag = 0;//添加颜色种类标记
	for (int i = 1;i <= color_num;i++) {
		if (color_flag[i] == 0) {//若某颜色没标记  则fflag加一
			fflag = 1 + fflag;
			

		}
	}
	return fflag;

}
void okcolor(int** neiber, int* result, int p_num, int point_num, int color_num) {
	//判断是否能上色   未考虑邻接点颜色种类快满了的时候，他们不同颜色种类的邻接点时候还有共同邻接点  有则不能填色
	int* color_flag = new int[color_num+1];//颜色登记
	for (int i = 0;i <= color_num;i++)//初始化颜色登记
		color_flag[i] = 0;
	for (int i = 1;i <= point_num;i++) {//判断相邻点是否有color_num个不同颜色
		if (neiber[p_num][i]) {
			if (result[i] <= color_num && result[i] > 0)//若相邻点有涂色 则标记
				color_flag[result[i]] = result[i];
		}
	}
	int fflag = 0;//添加颜色种类标记
	for (int i = 1;i <= color_num;i++) {
		if (color_flag[i] == 0) {//若某颜色没标记  则fflag加一
			fflag = 1 + fflag;
			if (color_except[p_num][i] != 1) {//若该点对该颜色不排斥
				result[p_num] = i;//设置颜色为该颜色
				break;
			}

		}
		else
			color_except[p_num][i] = 1;//若邻接点有该颜色  则标记去除颜色
	}
	
	if (fflag == 0||fflag==color_num)//若无颜色可选  则返回0
		result[p_num] = 0;
	

}
int find_point_maxedge(int* result, int* edge_max, int* color_rest, int color_num, int point_num,int **neiber, int* record_pnum)
{//找到符合要求的点
	int degree = INT_MIN;
	int k = 1;
	int* maxedge_point = new int[point_num + 1];
	for (int i = 1;i <= point_num;i++) {//找到最大度相应的点
		maxedge_point[i] = 0;//存放最大度的点标号初始化
		if (result[i] != 0||color_flag1[i]==1)//如果已经有颜色  或者记录点已有颜色 则跳过
			continue;
		if (degree < edge_max[i]) {//如果度数大  则赋值给degree
			degree = edge_max[i];
		}
	}
	for (int i = 1;i <= point_num;i++) {//记录最大度对应点的集合
		if (degree == edge_max[i]&&!color_flag1[i]) {//当degree等于
			maxedge_point[k] = i;//记录相同最大度数目标点下标
			k++;//数组长度增加一
		}
	}
	int flag_mincolor = color_num + 1, flag_minnum = 0;
	for (int i = 1;i < k;i++) {//选择最少可选颜色的点
		if (color_rest[maxedge_point[i]] < flag_mincolor) {//如果剩余颜色小于上一度点颜色
			flag_mincolor = color_rest[maxedge_point[i]];//赋值目标点可填颜色数
			flag_minnum = maxedge_point[i];//返回值为目标点标号
		}
	}
	delete[]maxedge_point;
	if (flag_minnum == 0) {
		cout << "error!" << endl;
		return flag_minnum;
	}
	else
		return flag_minnum;
}
//                  记录涂色点        点数目       可用颜色数      各点剩余颜色数     各点度数    邻接点矩阵   当前涂色几个点   涂色结果   当前涂色点                          
void traceback(int *record_pnum,int point_num, int color_num, int* color_rest, int* edge_max, int **neiber, int flag, int* result,int p_num,int k) {
	if (flag > point_num) {//设置输出条件
		cout << "测试成功！结果为："<<endl;
		for (int i = 1;i <= point_num;i++) {
			cout <<  result[i] << " ";
			if (i % 10 == 0)
				cout << endl;
		}
		cout << endl;
		return;
	}
	
	p_num= find_point_maxedge(result, edge_max, color_rest, color_num, point_num, neiber,record_pnum);//找到相应点
	
	if(p_num==0){
		//若找不到目标点
		cout << k << endl;
		record_pnum[k] = 0;//上个记录点清零
		//color_flag1[p_num] = 1;//点标记涂色
		k--;//目标点选择记录退1
		//result[p_num] = 0;//颜色标记0
		p_num = record_pnum[k];//目标点上移
		for (int i = 1;i <= point_num;i++) {//目标点邻接点度数加一
			if (neiber[p_num][i])
				edge_max[i]++;
			int neiber_point=findcolor(neiber, result,i, point_num, color_num);//上一记录点的邻接点的邻接点颜色种类
			if (neiber_point < color_num-1) {//若上一记录点的邻接点的邻接点种类
				color_except[i][result[i]] = 1;
				okcolor(neiber, result, i, point_num, color_num);
			}
		}
		
		//递归
	
		traceback(record_pnum, point_num, color_num, color_rest, edge_max, neiber, flag, result, p_num,k);
	}
	
	
	if (!result[p_num]) {//若返回颜色为0
		result[p_num]++;//颜色加加
	}
	for (int i = 1;i < color_num;i++) {//检查颜色冲突
		if (!ok(point_num, p_num, neiber, result)) {//若赋值颜色冲突
			result[p_num]++;
		}
		else
			break;
	}
	if (!ok(point_num, p_num, neiber, result)) {//若实在没颜色可选
		k--;//目标点选择记录退1
		color_flag1[p_num] = 0;//涂色标记0;
		result[p_num] = 0;//颜色标记0
		p_num = record_pnum[k];//目标点上移
		for (int i = 1;i <= point_num;i++) {//目标点邻接点度数加一
			if (neiber[p_num][i] ) {//相邻
				edge_max[i]++;//度加一
				color_rest[i]++;//颜色加一
				color_except[i][result[p_num]] = 0;//邻接点所选颜色恢复
			}
		}
		flag--;//点记录减一
		traceback(record_pnum, point_num, color_num, color_rest, edge_max, neiber, flag, result, p_num, k);
	}
	for (int i = 1;i <= point_num;i++) {//相邻度数加一  相邻可选颜色减一
		if (neiber[p_num][i] ) {//相邻
			edge_max[i]++;//度加一
			//color_rest[i]--;//剩余颜色减一
			color_except[i][result[p_num]] = 1;//邻接点可选色系少一

		}
	}
	color_flag1[p_num] = 1;//点标记涂色
	//最后则flag++;
	okcolor(neiber, result, p_num, point_num, color_num);//找到邻接点可用颜色，并赋值颜色
	flag++;
	//若找到目标点 则
	record_pnum[k] = p_num;
	//okcolor(neiber, result, p_num, point_num, color_num);//找到邻接点可用颜色，并赋值颜色

	k++;//记录点数组右移
	traceback(record_pnum, point_num, color_num, color_rest, edge_max, neiber, flag, result, p_num,k);
}

//vector<node*>head;//设置表头      ①使数据更紧凑
int main() {
	cout << "请输入颜色种类：";
	int color_num;
	cin >> color_num;
	cout << "请输入点个数：";
	int point_num;
	cin >> point_num;
	cout << "请输入边个数：";
	int edge_num;
	cin >> edge_num;
	cout << "请输入点与邻接点标号:";
	int** neiber = NULL;
	neiber = new int* [point_num+1];
	for (int i = 0;i < point_num + 1;i++) {
		neiber[i] = new int[point_num + 1];
	}
	for (int i = 0;i <= point_num;i++) {
		for (int j = 0;j <= point_num;j++) {
			neiber[i][j] = 0;
			color_except[i][j] = 0;
		}
	}
	//head.resize(point_num + 1);//表头大小定义
	int* edge_max = new int[point_num + 1];//记录各个点边数 用于MRV

	for (int i = 0;i <= point_num;i++) {
		edge_max[i] = 0;
		color_flag1[i] = 0;
	}
	//for (int i = 1;i <= point_num;i++) head[i] = new node(i);
	for (int i = 1;i<=edge_num;i++) {//记录邻接表
		int n = 0, m = 0;
		cin >> n >> m;
		//add_edge(n, m, edge_max,neiber[n][m],neiber[m][n]);//增加邻接表节点    并且两点点邻接边数加一
		neiber[m][n] = 1;
		neiber[n][m] = 1;
		edge_max[n]++;
		edge_max[m]++;
	}
	int* color_rest = new int[point_num + 1];
		color_rest[0] = 0;
	for (int i = 1;i <= point_num;i++) //记录可用颜色剩余  若涂色则为0；
		color_rest[i] = color_num;
	int* record_pnum = new int[point_num + 1];//记录填色历史
	for (int i = 0;i <= point_num;i++) {
		record_pnum[i] = 0;
	}
	int flag = 1;
	int p_num = 0;
	int* result = new int[point_num + 1];
	for (int i = 0;i <= point_num;i++)
		result[i] = 0;
	int k = 1;
	DWORD start_time = GetTickCount();
	traceback(record_pnum, point_num, color_num, color_rest, edge_max, neiber, flag, result, p_num,k);
	DWORD end_time = GetTickCount();
	cout << "程序运行时间为：" << end_time - start_time <<"ms"<< endl;
	/*
	vector<vector<int>>pt(point_num + 1, vector<int>(point_num + 1));//设置point_num+1个vector邻接表



	for(int i=1;i<=point_num;i++){//记录邻接表
		int n = 0, m = 0;
		cin >> n >> m;
		pt[n].push_back(m);
		pt[m].push_back(n);
	}

	*/
}
