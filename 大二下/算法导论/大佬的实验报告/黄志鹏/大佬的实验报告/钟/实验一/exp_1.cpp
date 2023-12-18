#include <bits/stdc++.h>
using namespace std;

int checker = 0;

void selection_sort(int *data, int len)
{
    for (int i = 1; i < len; i++)
    {
        int min_i = i;
        for (int j = i + 1; j <= len; j++)
        {
            if (data[j] < data[min_i])
                min_i = j;
        }
        swap(data[min_i], data[i]);
    }
}

void bubble_sort(int *data, int len)
{
    bool swap_flag;
    for (int i = 1; i <= len; i++)
    {
        swap_flag = false;
        for (int j = 1; j <= len - i; j++)
            if (data[j] > data[j + 1])
            {
                swap(data[j], data[j + 1]);
                swap_flag = true;
            }
        if (!swap_flag)
            break;
    }
}

void insertion_sort(int *data, int left, int right)
{
    int node;
    for (int i = left + 1; i <= right; i++)
    {
        node = data[i];
        int j = i - 1;
        while (j-- >= 1)
        {
            if (data[j] > node)
                data[j + 1] = data[j];
            else
                break;
        }
        data[j + 1] = node;
    }
}

void merge_sort(int *data, int left, int right)
{
    if (left == right)
        return;
    int middle = (left + right) / 2;
    merge_sort(data, left, middle);
    merge_sort(data, middle + 1, right);

    queue<int> merge_queue;
    int left_index = left;
    int right_index = middle + 1;

    while (true)
    {
        if (data[left_index] < data[right_index])
        {
            merge_queue.push(data[left_index]);
            left_index++;
        }
        else
        {
            merge_queue.push(data[right_index]);
            right_index++;
        }

        if (left_index > middle)
        {
            for (int i = right_index; i <= right; i++)
                merge_queue.push(data[i]);
            break;
        }
        else if (right_index > right)
        {
            for (int i = left_index; i <= middle; i++)
                merge_queue.push(data[i]);
            break;
        }
    }
    for (int i = left; i <= right; i++)
    {
        data[i] = merge_queue.front();
        merge_queue.pop();
    }
}

void quick_sort(int *data, int left, int right)
{
    int node = data[left];
    int left_index = left;
    int right_index = right;
    while (left_index < right_index)
    {
        //右找小
        while (left_index < right_index && data[right_index] >= node)
            right_index--;
        if (left_index < right_index)
        {
            data[left_index] = data[right_index];
            left_index++;
        }

        //左找大
        while (left_index < right_index && data[left_index] < node)
            left_index++;
        if (left_index < right_index)
        {
            data[right_index] = data[left_index];
            right_index--;
        }
    }

    int node_index = left_index;
    data[node_index] = node;

    if ((left_index == left || right_index == right) && (right - left > 1000))
    {
        checker++;
    }

    bool change_condition = checker > 300 && right - left < 5000;

    if (node_index - left >= 2) //solve左区间
    {
        if (change_condition)
            insertion_sort(data, left, node_index - 1);
        else
        quick_sort(data, left, node_index - 1);
    }

    if (right - node_index >= 2) //solve右区间
    {
        if (change_condition)
            insertion_sort(data, node_index + 1, right);
        else
            quick_sort(data, node_index + 1, right);
    }
}

int main()
{
    int test_times = 50;

    for (int i = 1; i <= 5; i++)
    {
        int t = test_times;
        int len = i * 1000000 + 1;
        int *data1 = new int[len];
        int *data2 = new int[len];
        int *data3 = new int[len];
        int *data4 = new int[len];
        int *data5 = new int[len];
        double sum_time[5] = {0, 0, 0, 0, 0};
        while (t--)
        {
            for (int i = 1; i <= len; i++)
            {
                int num = rand() * rand();
                data1[i] = num;
                data2[i] = num;
                data3[i] = num;
                data4[i] = num;
                data5[i] = num;
            }

            double beginTime;
            double endTime;

            /*beginTime = clock();
            selection_sort(data1, len);
            ndTime = clock();
            sum_time[0] += endTime - beginTime;

            beginTime = clock();
            bubble_sort(data2, len);
            endTime = clock();
            sum_time[1] += endTime - beginTime;

            beginTime = clock();
            insertion_sort(data3, 1, len - 1);
            endTime = clock();
            sum_time[2] += endTime - beginTime;

            beginTime = clock();
            merge_sort(data4, 1, len - 1);
            endTime = clock();
            sum_time[3] += endTime - beginTime;*/

            beginTime = clock();
            quick_sort(data5, 1, len - 1);
            endTime = clock();
            sum_time[4] += endTime - beginTime;
        }
        cout << i << "*************************" << endl;
        for (int j = 0; j < 5; j++)
            cout << (sum_time[j] / test_times) / 1000 << endl;
    }
    return 0;
}
