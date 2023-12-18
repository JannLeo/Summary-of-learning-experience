import random
import time


def selection_sort(data_list):
    list_len = len(data_list)
    start_time = time.time()
    for i in range(1, list_len - 1):
        min_i = i
        for j in range(i + 1, list_len):
            if data_list[j] < data_list[min_i]:
                min_i = j
            j += 1
        data_list[min_i], data_list[i] = data_list[i], data_list[min_i]
        i += 1
    end_time = time.time()
    return end_time - start_time


def bubble_sort(data_list):
    list_len = len(data_list)
    start_time = time.time()
    for i in range(1, list_len):
        swap_flag = False
        for j in range(1, list_len - i):
            if data_list[j] > data_list[j + 1]:
                swap_flag = True
                data_list[j], data_list[j + 1] = data_list[j + 1], data_list[j]
            j += 1
        if (swap_flag):
            i += 1
        else:
            break
    end_time = time.time()
    return end_time - start_time


def insertion_sort(data_list):
    list_len = len(data_list)
    start_time = time.clock()
    for i in range(1, list_len):
        node = data_list[i]
        j = i - 1
        while j >= 1:
            if data_list[j] > node:
                data_list[j + 1] = data_list[j]
            else:
                break
            j -= 1
        data_list[j + 1] = node
        i += 1
    end_time = time.clock()
    return end_time - start_time


def merge_sort(data_list, left, right):
    list_len = len(data_list)

    if left == right:
        return

    middle = (left + right) // 2
    merge_sort(data_list, left, middle)
    merge_sort(data_list, middle + 1, right)

    # merge
    merge_list = []
    left_index = left
    right_index = middle + 1

    while True:
        if data_list[left_index] < data_list[right_index]:
            merge_list.append(data_list[left_index])
            left_index += 1
        else:
            merge_list.append(data_list[right_index])
            right_index += 1
        if left_index == middle + 1:
            merge_list += data_list[right_index:right + 1]
            break
        elif right_index == right + 1:
            merge_list += data_list[left_index:middle + 1]
            break

    for i in range(right, left - 1):
        data_list[i] = merge_list.pop()
        i -= 1


checker = None


def quick_sort(data_list, left, right):
    node = data_list[left]
    left_index = left
    right_index = right
    while left_index < right_index:
        while left_index < right_index and \
                data_list[right_index] >= node:
            right_index -= 1
        if left_index < right_index:
            data_list[left_index] = data_list[right_index]
            left_index += 1
        while left_index < right_index and \
                data_list[left_index] < node:
            left_index += 1
        if left_index < right_index:
            data_list[right_index] = data_list[left_index]
            right_index -= 1

    node_index = left_index
    data_list[node_index] = node

    '''global checker
    if (left_index == left or right_index == right) and \
            (right - left > 1000):
        checker += 1
'''
    if node_index - left >= 2:
        if (checker > 300) and (right - left < 5000):
            insertion_sort(data_list, left, node_index - 1)
        else:
            quick_sort(data_list, left, node_index - 1)

    if right - node_index >= 2:
        if (checker > 300) and (right - left < 5000):
            insertion_sort(data_list, node_index + 1, right)
        else:
            quick_sort(data_list, left, node_index + 1, right)


def main():
    test_times = 1
    # list_len = [n * 1000 for n in range(1, 100)]
    # for i in range(0, 99):
    sum_time1 = sum_time2 = 0
    t = test_times
    while t:
        data_list = []
        for j in range(1000001):
            data_list += [random.randint(0, 1000000)]
            j += 1
        list_copy = data_list.copy()
        start_time = time.clock()
        merge_sort(data_list, 1, 1000000)
        end_time = time.clock()
        sum_time1 += end_time - start_time
        start_time = time.clock()
        list_copy.sort()
        end_time = time.clock()
        sum_time2 += end_time - start_time
        t -= 1

    print("{}".format(sum_time1 / test_times))
    print("{}".format(sum_time2 / test_times))


main()
