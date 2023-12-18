#include<iostream>
#include<ctime>
using namespace std;

int N[5] = {10000, 20000, 30000, 40000, 50000}; //数组范围
#define Times 20  //运算次数

    void
    Bubble(int *arr, int n){    //冒泡排序
    int i, j, tmp;
    for (i = 0; i < n; ++i)
    {
        for (j = 0; j < n - i -1; ++j)
        {
            if(arr[j]>arr[j+1])
            {
                tmp = arr[j];
                arr[j] = arr[j+1];
                arr[j+1] = tmp;
            }
        }
    }
}

void Selection(int *arr, int n){  //选择排序
    int i, j, min, tmp;
    for (i = 0; i < n-1; ++i){
        min = i;
        for (j = i+1; j < n; ++j)
            if(arr[j]<arr[min])
                min = j;
        tmp = arr[min];
        arr[min] = arr[i];
        arr[i] = tmp;
    }
}

void Insert(int *arr, int n){    //插入排序
    int i, pos, tmp;
    for(i = 0; i < n; ++i){
        pos = i - 1;
        tmp = arr[i];
        while (pos >= 0 && arr[pos] > tmp){
            arr[pos + 1] = arr[pos];
            pos--;
        }
        arr[pos+1] = tmp;
    }
}

void QuickSort(int *arr, int low, int high){  //快速排序
    if (low >= high)
        return;
    int i = low, j = high, tmp = arr[i];
    while (i < j)
    {
        while (i < j && arr[j] >= tmp)
            j--;
        if (i < j)
            arr[i++] = arr[j];
        while (i < j && arr[i] < tmp)
            i++;
        if (i < j)
            arr[j--] = arr[i];
    }
    arr[i] = tmp;
    QuickSort(arr, low, i - 1);
    QuickSort(arr, i + 1, high);
}

void Quick(int *arr, int n){    //快速排序
    QuickSort(arr, 0, n);
}

void Merge(int *arr, int low, int middle, int high){  //归并排序
    int n1 = middle - low; 
    int n2 = high - middle;
    int i, j, k;
    int *a1 = new int[n1];
    int *a2 = new int[n2];
    for(i = 0; i < n1; ++i)
        a1[i] = arr[low + i];
    for(j = 0; j < n2; ++j)
        a2[j] = arr[middle + j];
    for (i = 0, j = 0, k = low; k < high;++k){
        if (i < n1 && a1[i] <= a2[j])
            arr[k] = a1[i++];
        else if (j < n2 && a1[i] >= a2[j])
            arr[k] = a2[j++];
        else if (i == n1 && j < n2)
            arr[k] = a2[j++];
        else if (j == n2 && i < n1)
            arr[k] = a1[i++];
    }
    delete []a1;
    delete []a2;
}

void MergeSort(int *arr, int low, int high){   //归并排序
    if(low+1<high){
        int m = (low + high) / 2;
        MergeSort(arr, low, m);
        MergeSort(arr, m, high);
        Merge(arr, low, m, high); 
    }
}

int main()
{
    clock_t TimeInit[20], TimeFinal[20];

    double AvgTime, Sum;
    srand((unsigned)time(NULL));
    for(int count=0; count < 1; ++count){
        Sum = 0;
        int *arr = new int[N[count]];
        for (int i = 0; i < Times; ++i)
        {
            for (int j = 0; j < N[count]; ++j)
                arr[j] = rand();
            TimeInit[i] = clock();
            // Bubble(arr, N[count]);
            // Selection(arr, N[count]);
            //Insert(arr, N[count]);
            Quick(arr, N[count]);
            //MergeSort(arr, 0, N[count]);
            TimeFinal[i] = clock();
        }
        // for (int i = 0; i < N[count];++i)
        //     cout << arr[i] << ' ';
        // cout << endl;

        for (int i = 0; i < Times; i++)
        {
            Sum += (double)(TimeFinal[i] - TimeInit[i]);
            }
        AvgTime = Sum / CLOCKS_PER_SEC / Times * 1000;
        cout << AvgTime << "ms"<<" "<<endl;
        delete[] arr;
    }   
    int n;
    cin >> n;
    return 0;
}


