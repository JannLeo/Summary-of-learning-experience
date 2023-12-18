#include <omp.h>
#include <stdlib.h>
#include <time.h>
#include <iostream>
#include <algorithm>
#include <math.h>
using namespace std;

const int TESTTIMES = 5;//测试次数

void checkArr(double a[], double ans[],int n) {
	//check
	bool flag = true;
	for (int i = 0; i < n; i++) {
		if (a[i] != ans[i]) {
			cout << "结果错误" << endl;
			flag = false;
			break;
		}
	}
	if (flag) cout << "结果正确" << endl;
}
						
// 输出数组内元素
void showArr(double a[], int n) {
	for (int i = 0; i < n; i++) {
		printf("%f ", a[i]);
	}
	printf("\n");
}
//借助临时数组b来合并两段有序的数组a
void merge(double a[], double b[], int startIndex, int midIndex, int endIndex)
{
	int i = startIndex, j = midIndex + 1, k = startIndex;
	while (i <= midIndex && j <= endIndex ){
		if (a[i] > a[j]) {
			b[k++] = a[j++];
		}
		else {
			b[k++] = a[i++];
		}
	}
	//合并剩下多余的
	while (i <= midIndex ) b[k++] = a[i++];
	while (j <= endIndex ) b[k++] = a[j++];
	//重新赋值
	for (i = startIndex; i <= endIndex; i++) a[i] = b[i];
}


void main()
{
	int n, p;//数组大小n，线程数p
	cout << "输入数组大小以及线程数：" << endl;
	cin >> n >> p;
	double *a = new double[n];//初始数据
	double* b = new double[n];//temp数组
	double* ans = new double[n]; // answer


	int tid;//线程ID
	int t = TESTTIMES;//测试次数
	clock_t start, end;//记录起始和结束时间
	double all_parallel = 0, all_non_parallel = 0;//统计全部时间，最后记录平均
	double time;//记录单次时间
	int i, j, k;//循环变量



	while (t--) {

		omp_set_num_threads(p);//设置线程数量
		#pragma omp parallel shared(a,b,p) private(i,j) 
		{
			tid = omp_get_thread_num();

			//并行： 随机初始化
			#pragma omp for schedule(static,4)
			for (i = 0; i < n; i++) {
				a[i] = rand() / double(RAND_MAX);
				ans[i] = a[i];
			}

			//统一进度，阻塞一下确保初始化完成,并且开始计时。	
			#pragma omp barrier
			#pragma omp single
			{
				start = clock();
			}
			
			//并行：sort排序p段
			int len = n / p;
			#pragma omp for schedule(static,1)
			for (i = 0; i < p; i++) {
				sort(a + i * len, a + (i + 1) * len);
			}
			
			//统一线程进度，阻塞一下确保数组a的所有段有序			
			#pragma omp barrier
			// 隐含 #pragma omp flush 
			// 并行：归并
			for (int block_length = len; block_length < n; block_length += block_length) {
				#pragma omp for schedule(static,1)
				for (int startIndex = 0; startIndex < n - block_length; startIndex += (block_length + block_length)) {
					int midIndex = startIndex + block_length - 1;
					int endIndex = startIndex + block_length + block_length - 1;
					merge(a, b, startIndex, midIndex, endIndex < n ? endIndex : n - 1);
				}
				//确保数组a的所有段长度为blocklength的时候有序			
				#pragma omp barrier
			}
			#pragma omp barrier
			#pragma omp single
			{
				end = clock();
				time = (end - start) / 1000.0;
				printf("并行时间：%f s\n", time);
				all_parallel += time;
			}
		}

		//串行程序计算
		start = clock();
		int len = n / p;
		for (i = 0; i < p; i++) {
			sort(ans + i * len, ans + (i + 1) * len);
		}
		// 串行：归并
		for (int block_length = len; block_length < n; block_length += block_length) {
			for (int startIndex = 0; startIndex < n - block_length; startIndex += (block_length + block_length)) {
				int midIndex = startIndex + block_length - 1;
				int endIndex = startIndex + block_length + block_length - 1;
				merge(ans, b, startIndex, midIndex, endIndex < n ? endIndex : n - 1);
			}
		}
		end = clock();
		time = (end - start) / 1000.0;
		printf("串行时间：%f s\n", time);
		all_non_parallel += time;

		checkArr(a , ans , n);

	}
	printf("串行平均时间：%f\n", all_non_parallel / TESTTIMES);
	printf("并行平均时间：%f\n", all_parallel / TESTTIMES);
	printf("加速比: %f\n", all_non_parallel / all_parallel);
}


