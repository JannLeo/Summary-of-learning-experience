

一、编译运行程序

1、在riscv-mini目录下写下test.s文件。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130014200559-1013899649.png)

2、汇编程序编写完成后通过riscv32-unknown-elf-gcc进⾏编译。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130014201319-1756045852.png)

3、编译完成后我们便可得到elf⽂件，通过readelf -h我们可以看到，该elf文件的系统架构为riscv，并且入口点地址为0x200。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130014201913-2069904056.png)

4、使⽤riscv32-unknown-elf-objdump对elf⽂件进⾏反汇编，可以看到程序在start时，起始地址为0x200。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130014202880-955228926.png)

5、将elf⽂件转化为特定格式的hex⽂件，为了后面的仿真。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130014203968-2116920985.png)

6、执行./VTile ./test_jx3/test.hex test.vcd进行仿真，仿真过程会输出每个每个时钟周期的PC、执⾏指令以及相关的寄存器操作，也会生成.vcd的文件。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130014205652-1410661981.png)

7、使用vim书写factorial.c，并保存。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130014206521-1900607136.png)

8、使用riscv32-unknown-elf-gcc -nostdlib -Ttext=0x200 –march=RV32I -o factorial.elf factorial.c生成elf文件，警告不必理会。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130014207405-1645146892.png)

9、对生成的elf文件使用objdump获取反汇编代码。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130014209164-944541591.png)

10、通过以下指令生成hex文件，并且使用VTile仿真。

elf2hex 16 4096 factorial.elf \> factorial.hex

./VTile ./exampleCode/c/factorial.hex

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130014210744-1107300874.png)

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130014212039-759009272.png)

二、通过波形图观察指令的执行过程

1、使用vim书写exqmple1.S。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130014212879-796436561.png)

2、将example1.S编译后生成elf文件，对其objdump，观察每条指令所在的地址，并且生成其hex文件。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130014213778-1067790657.png)

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130014214761-1016794098.png)

3、对其进行VTile仿真并且生成vcd文件。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130014216007-1635859163.png)

4、使用GTKWave并选择exqmple1.vcd打开波形图，由于之前的objdump我们知道0x208是li t1,10指令的地址，并且我们发现在20ns前后req_addr=npc，所以此处若cache命中，则下一周期立即取得指令，我们在下一周期可以看到cache命中，因为其读取出了指令 00A00313 ，并将其写⼊到了fe_inst寄存器中以供执⾏阶段使⽤。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130014218880-942499257.png)

5、观察波形图，对于这⼀条指令 addi x6 x0 10 ，需要根据指令产⽣⽴即数10，从寄存器x0中读取数值，并使⽤ALU将⽴即数与读出的数值相加。从下⾯的波形图中可以观察到，⽴即数⽣成单元(immGen)、控制单元(ctrl)的输⼊均为流⽔寄存器中的inst。⽴即数⽣成单元给出对应的⽴即数0xA。同时寄存器⽂件也给出了x0寄存器读取的结果(x0寄存器始终为0)。alu中以寄存器读取的结果以及⽴即数作为输⼊，根据控制信号将其相加得到结果0xA，并将结果写⼊到流⽔线寄存器ew_alu中以供写回阶段使⽤。

![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130014222239-1214838239.png)

6、对于 addi x6 x0 10 指令便需要将ALU计算出的结果0xA写⼊到x6寄存器当中。观察如下的波形图，可以看到寄存器⽂件的写地址信号为06，写数据信号为ew_alu中的数值0xA，且写信号为⾼。查看寄存器⽂件中的x6寄存器，可以发现0xA已经被成功写⼊到x6寄存器当中。![](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130014224540-1051229050.png)

三、FPGA烧写

1、打开Vivado，导入实验所提供的.v文件，复制constraints于xdc文件中，并且设置Block Memory Generator（如下图所示）。

![C:\\Users\\11440\\AppData\\Local\\Temp\\WeChat Files\\452c1ab28e54d26a97ab5d06788c4d5.jpg](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130014234007-336229859.jpg)

![C:\\Users\\11440\\AppData\\Local\\Temp\\WeChat Files\\519926e254aaa73f805ab3b7f7aa32d.jpg](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130014241158-433290920.jpg)

2、连接板子，并且烧录程序并编译，然后用UART线根据ppt所提供的方法一次有序连接板子的VCC、RX、TX、GND口。

![C:\\Users\\11440\\AppData\\Local\\Temp\\WeChat Files\\319fad1c6c331607ad84066aa2ecb25.jpg](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130014248366-1459709001.jpg)

3、如下图所示，打开common串口工具，串口号选择COM4,选择字符模式，发送数据，窗口显示发送的信息，说明实验成功。

![C:\\Users\\11440\\AppData\\Local\\Temp\\WeChat Files\\26330b306fb9723b475d898ed048735.jpg](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130014254196-1628029216.jpg)

4、如上个实验一样的配置，只是文件与约束改了一点，其余一致，完成后打开common，我们输入1并发送（如下图）。

![C:\\Users\\11440\\AppData\\Local\\Temp\\WeChat Files\\dba941a34a30c7a09843d03211f20bc.jpg](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130014259442-1290868864.jpg)

5、发送1之后，我们发现板子的LD1上的灯亮起来了，说明试验成功。

![C:\\Users\\11440\\AppData\\Local\\Temp\\WeChat Files\\110dbca18d8fd4ab44f16ce7a3ed7a5.jpg](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130014308242-347521647.jpg)

6、我们再次尝试发送2（如下图）.

![C:\\Users\\11440\\AppData\\Local\\Temp\\WeChat Files\\1df3d3dae5a7d0822f51e13f2815228.jpg](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130014314873-348212915.jpg)

7、可以看到，板子的LD2灯亮了，我们的实验完美成功！

![C:\\Users\\11440\\AppData\\Local\\Temp\\WeChat Files\\1bcf8535aa6b37b568d8d9011416e99.jpg](https://img2023.cnblogs.com/blog/3334628/202311/3334628-20231130014322605-106154250.jpg)
