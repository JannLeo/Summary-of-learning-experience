# Linux入门教程总结

1. ## 以下RTL代码有什么问题？



2. ## 如何编写一个Helloworld的c程序在CPU上面跑？

3. ## 流水线CPU比单周期CPU快多少？

4. ## CPU仿真超过了100000000周期后出错，如何调试？



### 芯片设计标准

   1. #### 正确：能够正确流片

   2. #### 软件支持：linux系统或嵌入式系统等

   3. #### 微结构复杂度：单周期，流水线，cache，分支预测

   4. #### PPA

         1. ##### performance 性能：关注IPC，主频等。

         2. ##### Power ：暂不关注

         3. ##### Area： 不超预算即可

   5. #### 可配置性

   6. #### 代码可读性

### linux常用指令

 1. ##### ping baidu.com

 2. ##### df / 查看磁盘分区情况

 3. ##### fdisk /dev/sdb 对磁盘进行分区

 4. ##### poweroff 关机

 5. ##### find . -name "*.[ch]" 找.c或.h文件

 6. ##### grep "\bint i\b" a.c 查找文件中定义变量i的位置

 7. ##### wc a.c 数单词个数 word count 返回： 行 单词数 字符数 路径

### 比较文件

1. ##### 文本文件： vimdiff file1 file2

2. ##### 非文本文件： diff file1 file2

3. ##### 大文件: md5sum file1 file2

#### 列出一个C语言项目中所有被包含过的头文件

​	GUI实现可能比较复杂，但是Linux实现只需要一行：

```bash
find . -name "*.[ch]" | xargs cat | grep "^#include" | sort | uniq
```

	1. |为管道，其左边为输入，右边根据输入输出结果
	2. 先找到所有的.c 与 .h文件 
	3. `xargs`: 从标准输入读取数据，然后将其作为参数传递给其他命令。它通常用于处理通过管道传递的数据。当你运行 `xargs cat`，它会接收从标准输入传递的文件名，并将它们传递给 `cat` 命令，从而显示这些文件的内容。这对于查看多个文件的内容非常有用。例如，你可以使用 `find` 命令查找文件，然后使用 `xargs cat` 查看它们的内容： 
	4. 查找所有跟 #include 有关内容 并且把#include 去掉
	5. 排序
	6. 去重

### Linux Filesystem Hierarchy Standard (FHS)

	1. / 表示根目录
	2. /bin 表示存放二进制文件目录
	3. /boot/ 存放boot loader的目录
	4. /dev/ 存放设备文件的目录
	5. /etc/ 存放用户系统配置文件的目录
	6. /home/ 存放用户文件的目录
	7. /lib/ 存放重要链接库和内核模块的目录
	8. /media/ 可移除媒体设备的挂载目录
	9. /mnt/ 临时挂载文件系统的挂载目录
	10. /opt/ 第三方应用软件包
	11. /sbin/ 系统二进制文件
	12. /srv/ 系统服务产生的数据
	13. /tmp/ 临时文件目录
	14. /usr/ 用户和系统相关共享文件
	   	1. `/usr/bin`: 存放系统用户使用的用户级别的可执行文件。
	  	2. `/usr/sbin`: 存放系统管理员使用的系统管理命令和程序。
	  	3. `/usr/lib`: 存放系统使用的共享库文件。
	  	4. `/usr/include`: 包含用于C和C++编程的头文件。
	  	5. `/usr/share`: 存放共享数据文件，如文档、图标、主题等。
	  	6. `/usr/local`: 用户自行安装的软件通常会放在这个目录下。
	15. /var/ 存放变化文件的目录，比如说系统日志，缓存文件
	16. /root/ root用户存放文件的目录
	17. /proc/ 虚拟文件系统内核与当前运行的程序状态

### Busybox套件

1. 包含常用的linux 命令行工具，是专门用于嵌入式系统的一个套件。

### strace工具

1. system call trace 记录程序运行过程中的系统调用信息
2. strace ls -l
3. strace -o strace.log 表示把输出输出到log文件中
4. tail -f strace.log 另一终端运行

write 1号文件表示当前终端

man readline 阅读手册

history  查看历史命令   ！n执行第几条命令  ！xxx执行以xxx开头的最近一条命令

通配符  ?表示任意字符 [...]表示集合中任意一个字符 {...}表示括号扩展

alias 为常用命令设置别名  例 alias ls="ls -- color"

##### 正则表达式：

![image-20231211231354890](%E7%AC%AC%E4%B8%80%E8%8A%82%E8%AF%BElinux%E5%85%A5%E9%97%A8%E6%80%BB%E7%BB%93.assets/image-20231211231354890.png)

ps aux | grep 进程名字 （ps aux:任务管理器）

kill -9 进程号

jobs 任务栏

最小化 ctrl+z   最大化  fg  %1 %2...

### 输入输出重定向

0号文件：标准输入（默认当前终端）

1号文件：标准输出

2号文件：标准错误

pgrep 名字   ：用来查看进程号

lsof -p 进程号 查看进程打开的文件

/dev/pts/21 虚拟终端目录

echo "string" > file1

xargs 可以把标准输入转换成参数

shuf 把输出重新排列

head -n 1 选择输出第一行

awk 处理文本

watch -n 1 "cat /proc/cpuinfo l grep MHz  awk '[print \ $1 NR  \ $3 \ $4 \ $2)'"

每1秒查看一次" cat/proc/cpuinfo 里面的MHz 的\ $1第一列 NR第几行 \ $3第三列 "

![image-20231211233725693](%E7%AC%AC%E4%B8%80%E8%8A%82%E8%AF%BElinux%E5%85%A5%E9%97%A8%E6%80%BB%E7%BB%93.assets/image-20231211233725693.png)

tr -t : '\n' 把冒号：替换成换行符

file  输出一个文件的文件类型

xargs -I{}  find {}  -maxdepth 1 -type f -executable | \ xargs file -b -e elf | sort | uniq -c | sort -nr 表示把 前面的输出塞入大括号中 只找一层目录 f为普通文件 可执行文件 -b省略了文件路径输出 -e elf 去掉哈希码等多余输出 排序 去重+计数 sort -nr 按数字大小逆序排列

![image-20231211234232275](%E7%AC%AC%E4%B8%80%E8%8A%82%E8%AF%BElinux%E5%85%A5%E9%97%A8%E6%80%BB%E7%BB%93.assets/image-20231211234232275.png)

#### RTFM

最重要linux命令：man

man man 学习如何RTFM

![image-20231213124854795](%E7%AC%AC%E4%B8%80%E8%8A%82%E8%AF%BElinux%E5%85%A5%E9%97%A8%E6%80%BB%E7%BB%93.assets/image-20231213124854795.png)