1. 操作系统的共同目的
   1. 对硬件的抽象
   2. 在应用程序中复用硬件  多路复用
   3. 不同的活动不应该互相干涉  隔离性
   4. 共享
   5. 安全系统  权限系统
   6. 给程序更好的性能
   7. 支持不同的应用程序
2. 计算机硬件：CPU 内存 硬盘  网络接口
3. 用户空间运行应用程序
4. 内核有一个kernel程序一直运行 它是计算机资源的守护者
   1. 内核的内置服务
      1. 文件系统：实现了文件名、文件内容和文件夹，并且知道如何将文件存储在磁盘上
      2. 进程有自己的内存还有共享CPU时间
      3. 内核将进程作为内核服务进行管理，管理内存的分配：内核复用、划分内存，给不同的进程分配内存
      4. 文件系统通常有个安全策略叫做access control
5. 系统调用
   1. fd=open("out",1); fd就是文件描述符
   2. write(fd(文件描述符),"hello\n",6 );