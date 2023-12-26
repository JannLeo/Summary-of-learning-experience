

**一、实验目的：**

1.  了解DBMS系统的功能、软件组成；

    2、掌握利用SQL语句定义、操纵数据库的方法。

**二、实验要求：**

1、在课外安装相关软件并浏览软件自带的帮助文件和功能菜单，了解DBMS的功能、结构；  
 2、创建一个有两个关系表的数据库；

3、数据库、关系表定义；

4、学习定义关系表的约束(主键、外键、自定义)；

5、了解SQL的数据定义功能；

6、了解SQL的操纵功能；

7、 掌握典型的SQL语句的功能；

8、 了解视图的概念；

**三、实验设备：**

计算机、数据库管理系统如SQL SERVER, DB2，Oracle 等软件。

**四、实验内容**

**EMP:**

| **EMPNO** |  **ENAME**  |  **JOB**       |  **MGR（经理）** | **HIREDATE**    | **SAL**   | **COMM**  | **DEPTNO** |
|-----------|-------------|----------------|------------------|-----------------|-----------|-----------|------------|
| **7369**  | **SMITH**   | **CLERK**      | **7902**         | **17-Dec-90**   | **13750** |           | **20**     |
| **7499**  | **ALLEN**   | **SALESMAN**   | **7698**         |  **20-FEB-89**  | **19000** | **6400**  | **30**     |
| **7521**  | **WARD**    | **SALESMAN**   | **7698**         |  **22-FEB-93**  | **18500** | **4250**  | **30**     |
| **7566**  | **JONES**   | **MANAGER**    | **7839**         |  **02-APR-89**  | **26850** |           | **20**     |
| **7654**  | **MARTIN**  | **SALESMAN**   | **7698**         |  **28-SEP-97**  | **15675** | **3500**  | **30**     |
| **7698**  | **BLAKE**   | **MANAGER**    | **7839**         |  **01-MAY-90**  | **24000** |           | **30**     |
| **7782**  | **CLARK**   | **MANAGER**    | **7839**         |  **09-JUN-88**  | **27500** |           | **10**     |
| **7788**  | **SCOTT**   | **ANALYST**    | **7566**         |  **19-APR-87**  | **19500** |           | **20**     |
| **7839**  | **KING**    | **PRESIDENT**  |                  |  **17-NOV-83**  | **82500** |           | **10**     |
| **7844**  | **TURNER**  | **SALESMAN**   | **7698**         |  **08-SEP-92**  | **18500** | **6250**  | **30**     |
| **7876**  | **ADAMS**   | **CLERK**      | **7788**         |  **23-MAY-96**  | **11900** |           | **20**     |
| **7900**  | **JAMES**   | **CLERK**      | **7698**         |  **03-DEC-95**  | **12500** |           | **30**     |
| **7902**  | **FORD**    | **ANALYST**    | **7566**         |  **03-DEC-91**  | **21500** |           | **20**     |
| **7934**  | **MILLER**  | **CLERK**      | **7782**         |  **23-JAN-95**  | **13250** |           | **10**     |
| **3258**  | **GREEN**   | **SALESMAN**   | **4422**         | **24-Jul-95**   | **18500** | **2750**  | **50**     |
| **4422**  | **STEVENS** | **MANAGER**    | **7839**         | **14-Jan-94**   | **24750** |           | **50**     |
| **6548**  | **BARNES**  | **CLERK**      | **4422**         | **16-Jan-95**   | **11950** |           | **50**     |

**DEPT:**

| **DEPTNO** |  **DNAME**       | **LOC**        |
|------------|------------------|----------------|
| **10**     | **ACCOUNTING**   |  **LONDON**    |
| **20**     | **RESEARCH**     |  **PRESTON**   |
| **30**     |  **SALES**       |  **LIVERPOOL** |
| **40**     |  **OPERATIONS**  |  **STAFFORD**  |
| **50**     | **MARKETING**    |  **LUTON**     |

按照实验指导讲义完成老师要求的练习题目，必须写出sql语句以及运行结果。（示例如Exercise2 q4,后面按照这个格式完成练习。）

**一、CentOS7安装**

1、下载好centos7的iso文件后，在vmware点击新建虚拟机（图1-1），点击自定义配置，点击下一步。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020609812-159241574.png)

图1-1

1.  继续点击下一步（图1-2），然后选择安装程序光盘镜像文件（图1-3），点击下一步。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020610762-52218784.png)

图1-2

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020611957-1298782245.png)

图1-3

3、定义好虚拟机名称与路径后（图1-4），点击下一步。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020612818-61118546.png)

图1-4

4、定义处理器数量与内核数量，尽量往内核总数8设置（图1-5）。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020613836-1894584794.png)

图1-5

5、定义虚拟机内存，选择最大内存（图1-6）。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020615161-211714045.png)

图1-6

6、选择虚拟机网络类型为桥接网络（图1-7），点击下一步。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020616983-572180647.png)

图1-7

7、接下来三个选择默认，下一步（图1-8、图1-9、图1-10）。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020617908-1530650724.png)

图1-8

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020618890-17035122.png)

图1-9

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020619800-594398912.png)

图1-10

8、设置磁盘容量为80G，点击下一步（图1-11），默认再点击下一步（图1-12），点击完成即可（图1-13）。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020621149-1118981751.png)

图1-11

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020622046-1819190365.png)

图1-12

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020622942-2077402584.png)

图1-13

9、为了让虚拟机启动更快，删除掉原本不需要使用的硬件，编辑虚拟机设置--删-USB控制器、声卡、打印机（图1-14）。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020624085-358065787.png)

图1-14

10、点击开启虚拟机后，按两次回车，开始安装（图1-15），等待即可。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020624854-281763384.png)

图1-15

11、选择中文-\>简体中文，点击continue（图1-16）（这里是后来改的，因为中文更方便点，下面步骤都是英文的，本人已经重装好几回了QAQ）。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020629290-1385705504.png)

图1-16

12、选择installation destination，因为不选就不能进行下一步（图1-17），而且我们直接采用默认安装方式，即没有图形化界面的centos7。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020634061-952212209.png)

图1-17

13、选择自己创建的磁盘，然后选择I will configure partitioning，最后点击Done（图1-18）。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020636787-687745292.png)

图1-18

14、点击左下角的＋号，在mount point中分别选择/boot、/、swap，拟按一下配置配置虚拟机（图1-19、图1-20）：

/boot：1024M，标准分区格式创建。

swap：4096M，标准分区格式创建。

/：剩余所有空间，采用lvm卷组格式创建。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020638740-635831458.png)

图1-19

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020641518-1319014463.png)

图1-20

15、点击accept changes（图1-21）。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020644018-102268064.png)

图1-21

16、点击host name选项，设置主机名（图1-22、图1-23）。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020647566-1865108876.png)

图1-22

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020649692-592034949.png)

图1-23

17、最后点击begin installation即可开始安装（图1-24），在安装时可以设置root密码（图1-25）。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020653418-380958919.png)

图1-24

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020658020-2035019714.png)

图1-25

18、完成后，重启虚拟机，输入账号root 与密码，最后成功安装centos7（图1-26）！

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020658689-1055909714.png)

图1-26

**二、CentOS7内PostgreSQL安装**

1、在安装完本地npm后，在postgre官网运行脚本即可安装postgresql（图2-1、图2-2）。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020659870-520553273.png)

图2-1

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020702777-2018942845.png)

图2-2

2、安装完成后，输入su – postgres即可进入bash界面，然后通过使用psql语句登录postgres的用户，即可进入数据库（图2-3）。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020703378-348300636.png)

图2-3

3、vi /var/lib/pgsql/13/data/postgresql.conf ,然后修改如下（图2-4），并在/var/lib/pgsql/13/data/pg_hba.conf 下修改添加信任，后重启服务并关闭防火墙（图2-5）。设置环境变量（图2-6）。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020704226-1745275250.png)

图2-4

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020704778-839257009.png)

图2-5

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020705334-2033643960.png)

图2-6

4、利用netstat –tunlp发现5432端口已启用，且为postmaster（图2-7）。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020706013-992569715.png)

图2-7

5、进入postgres，创建用户jannleo，并创建数据库，设置密码（图2-8）。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020706967-1292528320.png)

图2-8

6、通过bash输入psql –U jannleo –d myfirstdb –h 127.0.0.1 –p 5432 即可进入数据库（图2-9）。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020707829-1370055692.png)

图2-9

**三、数据导入**

1、建立表Department，以此来存放部门（图3-1）。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020708385-791308947.png)

图3-1

2、插入数据如下（图3-2），依次插入即可，但是略显麻烦，如图3-3，显示插入成功！图3-4为插入完成后Department表的表项。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020708988-1707214008.png)

图3-2

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020709555-910448212.png)

图3-3

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020710132-545866311.png)

图3-4

3、创建Employment表（图3-5），并导入数据（图3-6）。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020710684-761742360.png)

图3-5

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020712546-1550860390.png)

图3-6

4、修改表名Employment为Employment2017303010（图3-7），修改表名Department为Department2017303010（图3-8）。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020713392-1158009517.png)

图3-7

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020714359-1280148847.png)

图3-8

5、确认Department2017303010表主键为DEPTNO，确认Employment2017303010表主键为EMPNO，外键为DEPTNO与Department2017303010(DEPTNO)链接，由于我在建表的时候就已经设置了主键，故在此只用设置外键。

-   外键：如果公共关键字在一个关系中是主关键字，那么这个公共关键字被称为另一个关系的外键。由此可见，外键表示了两个关系之间的相关联系。以另一个关系的外键作主关键字的表被称为主表，具有此外键的表被称为主表的从表。外键又称作外关键字。
-   主键：是被挑选出来，作表的行的惟一标识的候选关键字。一个表只有一个主关键字。主关键字又可以称为主键。 主键可以由一个字段，也可以由多个字段组成，分别成为单字段主键或多字段主键。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020715545-903761752.png)

图3-9

6、为表添加约束（图3-10），经过分析得知，EMP表中的EMPNO为主键，不用约束，ENAME为唯一约束，JOB、HIREDATE、SAL、DEPTNO为非空约束。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020716408-1956344619.png)

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020716924-1066486265.png)

图3-10

**四、做题**

1、List all information about the employees.

语句：

Select \* from Employment2017303010;

返回：（图4-1）

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020717809-1878152590.png)

图4-1

2、List only the following information from the EMP table ( Employee name, employee number, salary, department number)

语句：

Select ENAME,EMPNO,SAL,DEPTNO from Employment2017303010;

结果：（图4-2）

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020718686-2086068847.png)

图4-2

3、List all the jobs in the EMP table eliminating duplicates.

语句：

select distinct JOB from Employment2017303010;

结果：（图4-3）

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020719216-1195037105.png)

图4-3

4、What is the name, job title and employee number of the person in department 20 who earns more than £25000?

语句：

select ENAME,JOB,EMPNO from Employment2017303010 where SAL \>= 25000 and DEPTNO = 20 order by SAL desc;

结果：（图4-4）

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020719777-1284041093.png)

图4-4

5、Find any Clerk who is not in department 10.

语句：

select \* from Employment2017303010 where JOB = ‘CLERK’ and DEPTNO \<\> 10;

结果：（图4-5）

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020720324-1376589657.png)

图4-5

6、Find all the employees who earn between £15,000 and £20,000.

Show the employee name, department and salary.

语句：

select Employment2017303010.ENAME,Department2017303010.DNAME,Employment2017303010.SAL from Employment2017303010 inner join Department2017303010 on Employment2017303010.DEPTNO = Department2017303010.DEPTNO where SAL between 15000 and 20000;

结果：（图4-6）

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020720868-1145891823.png)

图4-6

7、Find all the employees whose last names end with S

语句：

select \* from Employment2017303010 where ENAME like ‘%S’;

结果：（图4-7）

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020721441-259144249.png)

图4-7

8、List only those employees who receive commission.

语句：（由于我前面对COMM项进行了默认约束为0，所以COMM不等于0即可）

select \* from Employment2017303010 where COMM \<\> 0;

结果：（图4-8）

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020722018-1526706036.png)

图4-8

9、Find the name, job, salary , hiredate and department number of all

employees in ascending order by their salaries.

语句：

select ENAME,JOB,SAL,HIREDATE,DEPTNO from Employment2017303010 order by SAL asc;

结果：（图4-9）

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020722602-1517011482.png)

图4-9

10、Order employees in department 30 who receive commision, in

ascending order by commission.

语句：

select \* from Employment2017303010 where COMM \<\> 0 and DEPTNO = 30 order by COMM asc;

结果：（图4-10）

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020723248-1065251017.png)

图4-10

11、Find all the salesmen in department 30 who have a salary greater than

or equal to £18000.

语句：

select \* from Employment2017303010 where DEPTNO = 30 and job = ‘SALESMAN’ and sal \>= 18000;

结果：（图4-11）

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020724011-1803231521.png)

图4-11

**五.问题分析（碰到什么问题，如何解决）**

1、在配置centos磁盘分区时，遇到了小键盘无法输入数字的问题，换了台式电脑的键盘，按了NumLock才修好。

2、在配置centos最后一步，配网时遇到了问题，不管是桥接模式还是NAT模式，都ping不上网址（图5-1）。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020725050-1423378839.png)

图5-2

3、配置本地yum时，发现没有local.repo（图5-3），后来发现，需要切换国内的npm源，我先利用本地yum下载了wget（图5-4），备份一下之前的配置文件mv ./CentOS-Base.repo ./CentOS-Base.repo.bak（图5-5）。然后通过用wget下载163的源，且将其设置为默认源（图5-6），最后重新生成缓存即可（图5-7）。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020725632-2051345083.png)

图5-3

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020726460-1413682634.png)

图5-4

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020727034-564391308.png)

图5-5

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020727565-751188034.png)

图5-6

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020728823-211006800.png)

图5-7

4、由于我安装设置的桥接模式，但是无论安装的时候还是安装完成都连接不上以太网（图5-4），最后终于让我找到了破绽，打开任务管理器，查看到以太网能上网的网卡是叫USB的而不是无线网的网卡（图5-6）！

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020729416-1960326097.png)

图5-4

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020730683-1062610025.png)

图5-5

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020732075-1387296515.png)

图5-6

5、在设置好4之后，我开始设置静态地址，由于我的ip地址是172.29.15.28，所以不能和教程一样，但是配置完后出现以下情况（图5-7），最后是把虚拟机改成NAT模式就行了。。。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020733065-1263350119.png)

图5-7

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020734830-133278656.png)

图5-8

6、在进入创建好的用户的数据库时，显示previous connection kept（图5-9），后面才知道，当时根本没有创建成功用户！因为我少了个分号（图5-10），真的很无语。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020735436-1925643405.png)

图5-9

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130020735995-1346154271.png)

图5-10

**六.实验心得**

1、mysql配置环境一直都是十分复杂麻烦的步骤，尤其是当电脑里有两个mysql的软件时，配置环境发生的冲突就显得十分的不可理解。

2、通过上老师的课了解到，mysql虽然目前免费，但是他们想卡你脖子就卡你脖子，因为已经被oracle商业化了，所以开发一个数据库势在必行，而且学习mysql已经有点晚了，所以我非常认同老师说的改革数据库课程。

3、在这个实验报告中，最让我头疼，最花时间的不是做题，而是postgresql的环境配置，为了实现centos的postgre-13，我甚至花了三天来进行配环境，一是因为我对centos完全陌生，导致安装过程复杂而且还重复了好多次，二是我对postgresql的陌生，导致重装了postgre-12又重装了postgre-13。

4、通过这个实验，我深刻体会到了环境搭建时的心态的重要性，不要动不动就重装，会导致很多环境冲突，并且深刻了解了centos在vmware上面的配网，熟悉了桥接模式与NAT模式的配置，并知道了他们的区别。

5、明白了主键与外键的区别，如果要设置外键，主键是必须要先设置的，然后外键也只能设置其他表的主键，否则不成功。

6、在这个实验进行时，我也深刻体会到了官方文档的重要性，什么csdn都不如一个官方文档，只要你会看官方文档，你什么都能学会。

7、这个实验至少耗费了我一个星期的学习时间，但是我觉得值，因为我不仅学会了postgresql的相关语句，也学会了搭配centos与基于centos的postgre环境的搭配，更明白了postgre作为开源数据库需要改进的许多地方，比如说没加冒号（；）不会报错等等。



|      |
| ---- |
|      |
