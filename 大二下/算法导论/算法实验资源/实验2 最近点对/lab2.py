import matplotlib.pyplot as plt
import matplotlib.animation as animation
import matplotlib.patches as patches
import numpy as np
import math

'''
Author   :  RuoLongLi 2018171028 SZU CSSE 
time     : 2020/4/7
function : A graphic demo of 'closest point pair' algorithm 
input    : the first line input the number of points (n), following 
            n lines, in each line, you should input the x and y value of points[i] 
output   : min distance and it's generation process

作    者 :  李若龙 2018171028 深大计软
时    间 : 2020 年 4 月 7 号
功    能 : 最近点对实验的图形演示
输    入 : 第一行输入一个数字n表示有n个点，接下来的n行每行输入点xy坐标
输    出 : 最近点对距离，以及他们生成的图形演示
'''

'''
10
0 8
17 80
6 81
26 43
63 14
32 48
41 33
28 70
50 0
68 87
'''

class point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

# 两点x距离
def cmpx(p1, p2):
    if(p1.x==p2.x):
        return (p1.y<p2.y)
    return (p1.x<p2.x)

# y升序比较函数
def cmpy(p1, p2):
    return (p1.y<p2.y)

# x升序比较函数
def getPseq():
    seq = []
    for p in points:
        seq += plt.plot(p.x, p.y, "o")
    return seq

# 排序，需要选择比较函数
def sort(points, cmp):
    n = points.__len__()
    for i in range(n):
        for j in range(n-1):
            if cmp(points[j], points[j+1]) == False:
                points[j],points[j+1] = points[j+1], points[j]

# 两点距离
def dis(p1, p2):
    return math.sqrt((p1.x-p2.x)*(p1.x-p2.x)+(p1.y-p2.y)*(p1.y-p2.y))

# 根据坐标在frame帧上绘制矩形
def getRectangle(frame, x1, y1, x2, y2, c):
    frame += plt.plot([x1, x2], [y1, y1], color=c)
    frame += plt.plot([x1, x2], [y2, y2], color=c)
    frame += plt.plot([x1, x1], [y1, y2], color=c)
    frame += plt.plot([x2, x2], [y1, y2], color=c)
    return frame

# 根据点数组points在frame帧上绘制点
def getPoints(frame, points):
    for p in points:
        frame += plt.plot(p.x, p.y, "o")
    return frame

# 根据points的顺序在frame帧上绘制箭头表示排序顺序
def getQuiver(frame, points, l, r, c):
    for i in range(l,r,1):
        dx = points[i + 1].x - points[i].x
        dy = points[i + 1].y - points[i].y
        q = plt.quiver(points[i].x, points[i].y, dx, dy, angles='xy', scale=1.03, scale_units='xy', width=0.005, color=c)
        frame += [q]
    return frame

artists = []
stack = []
colors = ['red', 'green', 'blue', 'black', 'yellow']


'''
function closest points 

param points : the array(list) of points
param l      : the left boundary of the sub array
param r      : the right boundary of the sub array
dep          : the depth of recursive tree,for graphic print

param points : 点的数组
param l      : 当前区间在数组中的左边界
param r      : 当前区间在数组中的右边界
dep          : 递归树深度，方便打印图形和递归路径
'''
def cp(points, l, r, dep):
    if l>=r :
        return 1145141919.810
    if l+1==r:
        return dis(points[l], points[r])
    mid, h = int((l+r)/2), 0

    lx = (points[mid].x+points[mid+1].x)/2

    frame = stack[-1].copy()
    frame = getRectangle(frame, points[l].x - 1, -5+dep, lx, 95-dep, colors[dep])
    artists.append(frame)
    stack.append(frame)
    d1 = cp(points, l, mid, dep+1)

    frame = stack[-1].copy()
    frame = getRectangle(frame, lx+1, -5+dep, points[r].x + 1, 95-dep, colors[dep])
    artists.append(frame)
    stack.append(frame)
    d2 = cp(points, mid+1, r, dep+1)
    stack.pop()
    stack.pop()

    d = min(d1, d2)

    ll, rr = [], []
    for i in range(l, r+1, 1):
        if points[i].x<points[mid].x and points[i].x+d>=points[mid].x:
            ll.append(points[i])
        if points[i].x>=points[mid].x and points[i].x-d<=points[mid].x:
            rr.append(points[i])

    frame = stack[-1].copy()
    la = stack[-1].copy()
    artists.append(frame)

    if ll.__len__()>0 and rr.__len__()>0:
        frame = stack[-1].copy()
        frame = getRectangle(frame, ll[0].x-1, -5+dep+1, rr[-1].x+1, 95-dep-1, 'yellow')
        artists.append(frame)
        ye = frame

        # 原顺序
        frame = artists[-1].copy()
        frame = getQuiver(frame, ll, 0, ll.__len__()-1, 'black')
        frame = getQuiver(frame, rr, 0, rr.__len__()-1, 'black')
        artists.append(frame)

        sort(ll, cmpy)
        sort(rr, cmpy)

        # 按y排序后
        frame = ye.copy()
        frame = getQuiver(frame, ll, 0, ll.__len__()-1, 'blue')
        frame = getQuiver(frame, rr, 0, rr.__len__()-1, 'blue')
        artists.append(frame)

        # 去掉箭头
        artists.append(ye)

        # 更新答案
        for p1 in ll:
            frame = ye.copy()
            frame += [plt.annotate('i ->', xy=[p1.x-5, p1.y])]
            while h<rr.__len__() and rr[h].y+d<p1.x:
                th = frame.copy()
                th += [plt.annotate('<- h', xy=[rr[h].x+1, rr[h].y])]
                artists.append(th)
                h += 1
            for j in range(h,min(h+6, rr.__len__()),1):
                th = frame.copy()
                th += [plt.annotate('<- j', xy=[rr[j].x+1, rr[j].y])]
                th += plt.plot([p1.x, rr[j].x], [p1.y, rr[j].y], color='blue')
                artists.append(th)
                d = min(d, dis(p1, rr[j]))
            artists.append(frame)

        # 去掉黄框
        artists.append(la)

    return d

if __name__ == '__main__':
    points = []
    n = int(input())
    for i in range(n):
        x, y = map(int,input().split(' '))
        points.append(point(x, y))

    fig = plt.figure()
    plt.xlim(-10, 90)
    plt.ylim(-10, 100)
    mngr = plt.get_current_fig_manager()  # 获取当前figure manager
    mngr.window.wm_geometry("+380+50")  # 调整窗口在屏幕上弹出的位置

    # 原始数据
    frame = []
    frame = getPoints(frame, points)
    frame = getQuiver(frame, points, 0, n - 1, 'black')
    artists.append(frame)

    sort(points, cmpx)

    # 排序后数据
    frame = []
    frame = getPoints(frame, points)
    frame = getQuiver(frame, points, 0, n - 1, 'blue')
    artists.append(frame)

    frame = []
    frame = getPoints(frame, points)
    artists.append(frame)
    stack.append(frame)

    print(cp(points, 0, n-1, 0))
    ain = animation.ArtistAnimation(fig=fig, artists=artists, interval=1000)
    plt.show()
    # ain.save('a.gif', fps=2)
