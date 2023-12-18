#include<iostream>
#include<ctime>
using namespace std;
const int SIZE = 1000000;
int h[SIZE],vtx[10*SIZE],nxt[10*SIZE];//  head下标为点num  数值为边下标    vtx存储边点num   nxt存储下一条边vtx下标
int ltflag[SIZE],ltfl=0;//连通分量flag以及连通分量
int flag[10*SIZE];
int idx = 0;//  idx为现在节点在记录中位置；
			//边表节点的创建
int flag_delete = 0;
int delete_ifflag = 0;

//加边
void addEdge(int a, int b) {
	nxt[idx] = h[a]; h[a] = idx;vtx[idx] = b;idx++;
}
void DFS(int a,int n) { //a=顶点   edge=边下标
	if (a == -1)
		return;
	ltflag[a] = 1;   //连通标记
	//int p = vtx[h[a]];//p=边点
	//int q = h[a];//q=边下标
	int p = h[a];//第一条边下标
	while (p != -1) {
		if (ltflag[vtx[p]] == 0 && flag[p] != 1) {//该边未被访问且未被删除
			DFS(vtx[p],n);//DFS查找同级点
			p = nxt[p];
		}
		//else if (flag[p] == 1) {
		//	/*
		//	对于已经删除的边,我们需要删除其两点之间的记录   包括A-B与B-A
		//	并且对于删除的边相关的点，我们需要遍历所有点找到与其相关的联通量  若有则不是桥，否则是桥
		//	*/
		//	//如果被删除
		////加参数flag_delete
		//		//return;
		//	p = h[flag_delete];//p=应删除的点对应的第一条边;
		//	while (p != -1) {//当p对应的边还有时
		//		if (ltflag[nxt[h[flag_delete]]] != 0) {//寻找p的邻接点中已经被标记的点,如果删除点对应的边的连通分量不等于0时
		//			DFS(nxt[h[flag_delete]], n);		 //删除点的对应边开始递归
		//			p = nxt[p];							//寻找删除点下一条边对应下标
		//		}
		//		else {
		//			break;   //若对应边未被标记，则进入下一条边查看

		//		}
		//	}
		//}
		else {
			break;
		}

			
	}
}
int  liantong(int n) {//n=顶点数目
	for (int i = 0;i < n;i++) {
		if (ltflag[i] == 0) {
			ltfl++;
			DFS(i,n);//边

		}
	}
	
	
	cout << "有" << ltfl << "个连通分量" << endl;
	return ltfl;
}
void Bridge(int n,int m) {
	int b_num = 0;
	int lt1 = liantong(n);
	ltfl = 0;
	int p = -1;
	int k = 1;
	for (int i = 0;i < n;i++) {//i代表边数组下标
		p = h[i];
		while (p != -1) {
			flag[p] = 1;
			flag_delete =p;//删除点下标
			nxt[flag_delete] = -1;
			//应该怎么删？
			//cout << "对于边" << i << " " << vtx[p] << endl;
			memset(ltflag, 0, sizeof(ltflag));
			int new_liantong = liantong(n);
			if (lt1 != new_liantong) {
				cout << "桥为" << i << " " << vtx[p] << endl;
			}
			memset(flag, 0, sizeof(flag));
			p = nxt[p];
			ltfl = 0;
		}
	}
}

int main() {
	cout << "请输入点数目与边数目:" << endl;
	int n, m,x,y;
	cin >> n >> m;
	memset(h, -1, sizeof(h));
	memset(ltflag, 0, sizeof(ltflag));
	memset(flag, 0, sizeof(flag));
	/*for (int i = 0;i < SIZE;i++) {
		h[i] = -1;
		ltflag[i] = 0;
	}
	for (int i = 0;i < 10 * SIZE;i++) {
		flag[i] = 0;
	}*/
	clock_t start, end;
	for (int i = 0;i < m;i++) {
		cout << "请输入边：" << endl;
		cin >> x >> y;
		addEdge(x, y);
		addEdge(y, x);
	}
	start = clock();
	Bridge(n,m);
	end = clock();   //结束时间
	/*int p = -1;
	for (int i = 0;i < n;i++) {
		p = h[i];
		cout << i << ":";
		while (p != -1) {
			cout << " " << vtx[p];
			p = nxt[p];

		}
		cout << endl;
	}*/
	cout << "基准算法所花时间：" << double(end - start) << "ms" << endl;



}
/*
5 4
0 1
0 2
1 2
3 4

3 4
*/