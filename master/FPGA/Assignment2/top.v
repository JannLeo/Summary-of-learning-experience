module top(input clock,  // 时钟信号
	input rstn,  //复位信号的输入,将电路初始化到一个已知的状态
	input [15:0]SW, //十六位宽度输入信号，代表开关或其他用户的输入数据
	input ps2_clk, //键盘的时钟输入信号
	input ps2_data,  // 键盘的数据输入信号
	output SEGLED_CLK,  //七段显示器的时钟输出信号
	output SEGLED_CLR,  //七段显示器的清除输出信号
	output SEGLED_DO,   //七段显示器的数据输出信号
	output SEGLED_PEN,  //七段显示器的使能输出信号
	output LED_CLK,     //LED的时钟输出信号
	output LED_CLR,		//LED的清除输入信号
	output LED_DO,		//LED的使能输入信号
	output LED_PEN,		//LED的使能输出信号
	output VS,			//视频输出的垂直同步信号
	output HS,			//视频输出的水平同步信号
	output [3:0]R,G,B	//RGB三通道输出信号
);
reg [31:0]scores;		//存储分数
wire [31:0]BCD;			//存储BCD码
reg [31:0] clkdiv;		//时钟分频
wire clk,clk_cover;		//时钟信号,时钟覆盖
reg cover;				//覆盖信号,当1的时候显示背景，0的时候显示游戏
reg finish;				//结束信号
reg spark;				//控制闪烁效果
//初始化，将cover和finish赋值为0
initial begin
	cover=0;
	finish=0;
end
//  封面和非封面的时钟信号
assign clk= clock&cover;
assign clk_cover=clock&(~cover)&(~finish);
//  封面模块相关的变量
reg[18:0] first;
wire[11:0] spo_first;

//  产生系统中其他模块不同频率的时钟信号
always@(posedge clock)begin
	clkdiv <= clkdiv+1'b1;
end//时钟信号
//  抖动模块相关变量与函数
wire [15:0] SW_OK;
AntiJitter #(4) a0[15:0](.clk(clkdiv[15]),.I(SW),.O(SW_OK));//防抖动

//  七段数码显示管相关代码
wire [31:0] segTestData;
// 生成七段显示器的输出信号
wire [3:0]  sout;
Seg7Device
segDevice(.clkIO(clkdiv[3]),.clkScan(clkdiv[15:14]),.clkBlink(clkdiv[25]),
.data(segTestData),.point(8'h0),.LES(8'h0),
.sout(sout));
assign SEGLED_CLK = sout[3];
assign SEGLED_DO =  sout[2];
assign SEGLED_PEN = sout[1];
assign SEGLED_CLR = sout[0];
reg [11:0] vga_data;//vga 颜色显示
wire [9:0] col_addr;//x 的值
wire [8:0] row_addr;//y 的值
wire rst;
// 画画
vgac
v0(.vga_clk(clkdiv[1]),.clrn(SW_OK[0]),.d_in(vga_data),.row_addr(row_addr),.col_addr(col_addr),.r(R),.g(G),.b(B),.hs(HS),.vs(VS));
reg [12:0] a1;//我方飞机
wire [11:0] spo1;
reg [14:0] gameover;//gameover
wire [11:0] spo_finish;
reg [12:0] a3;//敌方飞机
wire [11:0] spo3;
reg [12:0] a4;//敌方飞机
wire [11:0] spo4;
reg [12:0] a5;//敌方飞机
wire [11:0] spo5;
reg [12:0] a6;//敌方飞机
wire [11:0] spo6;
reg [12:0] a7;//敌方飞机
wire [11:0] spo7;
reg [18:0] bg1;//背景
wire [11:0] spob;
reg[18:0] iPad;//ipad 边框
wire [11:0] spoi;
reg[12:0] Boom0;//爆炸图片
wire [11:0] spo_boom;
reg[12:0] Boom1;//爆炸图片
wire [11:0] spo_boom1;
reg[12:0] Boom2;//爆炸图片
wire [11:0] spo_boom2;
reg[12:0] Boom3;//爆炸图片
wire [11:0] spo_boom3;
reg[12:0] Boom4;//爆炸图片
wire [11:0] spo_boom4;
/////////ip 核模块调用//////////////////////////
begining f1(.addra(first),.douta(spo_first),.clka(clkdiv[1])); //调用封面模块
MyPlane P1(.a(a1),.spo(spo1)); //调用我方飞机模块
game_over g1(.a(gameover),.spo(spo_finish)); //调用游戏结束模块
EnemyPlane e1(.a(a3),.spo(spo3)); //调用敌方飞机模块
EnemyPlane e2(.a(a4),.spo(spo4));
EnemyPlane e3(.a(a5),.spo(spo5));
EnemyPlane e4(.a(a6),.spo(spo6));
EnemyPlane e5(.a(a7),.spo(spo7));
boom B2(.addra(Boom0),.douta(spo_boom),.clka(clkdiv[1]));//调用爆炸模块
boom B3(.addra(Boom1),.douta(spo_boom1),.clka(clkdiv[1]));
boom B4(.addra(Boom2),.douta(spo_boom2),.clka(clkdiv[1]));
boom B5(.addra(Boom3),.douta(spo_boom3),.clka(clkdiv[1]));
boom B6(.addra(Boom4),.douta(spo_boom4),.clka(clkdiv[1]));
ipad i1(.addra(iPad),.douta(spoi),.clka(clkdiv[1])); //调用 ipad 边框模块
background b1(.addra(bg1),.douta(spob),.clka(clkdiv[1])); //调用背景模块
//////////给 ip 核模块的输入赋值///////////////
always @(posedge clk_cover)begin
	first<=(col_addr>=0&&col_addr<=639&&row_addr>=0&&row_addr<=479)?col_addr*480+row_addr:0; //给封面赋值
end
always@(posedge clock)begin
	a1<=(col_addr>=MyP_x&&col_addr<=MyP_x+79&&row_addr>=MyP_y&&row_addr<=MyP_y+79)?(col_addr-MyP_x)*80+(row_addr-MyP_y):0;//给我方飞机赋值
	//给敌方飞机赋值
	a3<=(col_addr>=e_x&&col_addr<=e_x+63&&row_addr>=e_y&&row_addr<=e_y+79)?(col_addre_x)*80+(row_addr-e_y):0;
	a4<=(col_addr>=e_x1&&col_addr<=e_x1+63&&row_addr>=e_y1&&row_addr<=e_y1+79)?(col_addr-e_x1)*80+(row_addr-e_y1):0;
	a5<=(col_addr>=e_x2&&col_addr<=e_x2+63&&row_addr>=e_y2&&row_addr<=e_y2+79)?(col_addr-e_x2)*80+(row_addr-e_y2):0;
	a6<=(col_addr>=e_x3&&col_addr<=e_x3+63&&row_addr>=e_y3&&row_addr<=e_y3+79)?(col_addr-e_x3)*80+(row_addr-e_y3):0;
	a7<=(col_addr>=e_x4&&col_addr<=e_x4+63&&row_addr>=e_y4&&row_addr<=e_y4+79)?(col_addr-e_x4)*80+(row_addr-e_y4):0;
	//给爆炸效果赋值
	Boom0<=(col_addr>=bo_x&&col_addr<=bo_x+67&&row_addr>=bo_y&&row_addr<=bo_y+63)?(col_addr-bo_x)*64+(row_addr-bo_y):0;
	Boom1<=(col_addr>=bo_x1&&col_addr<=bo_x1+67&&row_addr>=bo_y1&&row_addr<=bo_y1+63)?(col_addr-bo_x1)*64+(row_addr-bo_y1):0;
	Boom2<=(col_addr>=bo_x2&&col_addr<=bo_x2+67&&row_addr>=bo_y2&&row_addr<=bo_y2+63)?(col_addr-bo_x2)*64+(row_addr-bo_y2):0;
	Boom3<=(col_addr>=bo_x3&&col_addr<=bo_x3+67&&row_addr>=bo_y3&&row_addr<=bo_y3+63)?(col_addr-bo_x3)*64+(row_addr-bo_y3):0;
	Boom4<=(col_addr>=bo_x4&&col_addr<=bo_x4+67&&row_addr>=bo_y4&&row_addr<=bo_y4+63)?(col_addr-bo_x4)*64+(row_addr-bo_y4):0;
	iPad<=(col_addr>=0&&col_addr<=639&&row_addr>=0&&row_addr<=479)?col_addr*480+(row_addr):0; //给 ipad 输入赋值
	gameover<=(col_addr>=g_x&&col_addr<=g_x+191&&row_addr>=g_y&&row_addr<=g_y+39)?(col_addr-g_x)*40+row_addr-g_y:0;//给 gameover 输入赋值
	//判定背景移动到何处来对背景进行赋值
	if(row_addr>=BG_Y[8:0])
	bg1<=(col_addr>=0&&col_addr<=639&&row_addr>=BG_Y[8:0]&&row_addr<=BG_Y[8:0]+479)?col_addr*480+(row_addr-BG_Y):0;
	else bg1<=(col_addr>=0&&col_addr<=639)?col_addr*480+480-(BG_Yrow_addr):0;
end
/////////////////////////////显示部分//////////////////////////////
always@(posedge clock)begin
	if(cover==1)begin
	//背景显示
	if(col_addr>=0&&col_addr<=639&&row_addr>=0&&row_addr<=479)
		vga_data<=spob[11:0];
	//我方飞机显示
	if(flash == 1)begin
		if(col_addr>=MyP_x&&col_addr<=MyP_x+79&&row_addr>=MyP_y&&row_addr<=MyP_y+79)begin
			if(spo1[11:0]!=12'hfff)begin
				vga_data<=spo1[11:0];
			end
		end
	end
//我方子弹显示
if(col_addr>=B_xl[ 9: 0]&&col_addr<=B_xl[ 9:0]+3&&row_addr>=B_yl[ 8: 0]&&row_addr<=B_yl[ 8: 0]+19)
vga_data<=12'b1111_1110_0000;
if(col_addr>=B_xr[ 9: 0]&&col_addr<=B_xr[ 9:0]+3&&row_addr>=B_yr[ 8: 0]&&row_addr<=B_yr[ 8: 0]+19)
vga_data<=12'b1111_1110_0000;
if(col_addr>=B_xl[19:10]&&col_addr<=B_xl[19:10]+3&&row_addr>=B_yl[17:9]&&row_addr<=B_yl[17: 9]+19) vga_data<=12'b1111_1110_0000;
if(col_addr>=B_xr[19:10]&&col_addr<=B_xr[19:10]+3&&row_addr>=B_yr[17:9]&&row_addr<=B_yr[17: 9]+19) vga_data<=12'b1111_1110_0000;
if(col_addr>=B_xl[29:20]&&col_addr<=B_xl[29:20]+3&&row_addr>=B_yl[26:18]&&row_addr<=B_yl[26:18]+19) vga_data<=12'b1111_1110_0000;
if(col_addr>=B_xr[29:20]&&col_addr<=B_xr[29:20]+3&&row_addr>=B_yr[26:18]&&row_addr<=B_yr[26:18]+19) vga_data<=12'b1111_1110_0000;
if(col_addr>=B_xl[39:30]&&col_addr<=B_xl[39:30]+3&&row_addr>=B_yl[35:27]&&row_addr<=B_yl[35:27]+19) vga_data<=12'b1111_1110_0000;
if(col_addr>=B_xr[39:30]&&col_addr<=B_xr[39:30]+3&&row_addr>=B_yr[35:27]&&row_addr<=B_yr[35:27]+19) vga_data<=12'b1111_1110_0000;
if(col_addr>=B_xl[49:40]&&col_addr<=B_xl[49:40]+3&&row_addr>=B_yl[44:36]&&row_addr<=B_yl[44:36]+19) vga_data<=12'b1111_1110_0000;
if(col_addr>=B_xr[49:40]&&col_addr<=B_xr[49:40]+3&&row_addr>=B_yr[44:36]&&row_addr<=B_yr[44:36]+19) vga_data<=12'b1111_1110_0000;
if(col_addr>=B_xl[59:50]&&col_addr<=B_xl[59:50]+3&&row_addr>=B_yl[53:45]&&row_addr<=B_yl[53:45]+19) vga_data<=12'b1111_1110_0000;
if(col_addr>=B_xr[59:50]&&col_addr<=B_xr[59:50]+3&&row_addr>=B_yr[53:45]&&row_addr<=B_yr[53:45]+19) vga_data<=12'b1111_1110_0000;
if(col_addr>=B_xl[69:60]&&col_addr<=B_xl[69:60]+3&&row_addr>=B_yl[62:54]&&row_addr<=B_yl[62:54]+19) vga_data<=12'b1111_1110_0000;
if(col_addr>=B_xr[69:60]&&col_addr<=B_xr[69:60]+3&&row_addr>=B_yr[62:54]&&row_addr<=B_yr[62:54]+19) vga_data<=12'b1111_1110_0000;
if(col_addr>=B_xl[79:70]&&col_addr<=B_xl[79:70]+3&&row_addr>=B_yl[71:63]&&row_addr<=B_yl[71:63]+19) vga_data<=12'b1111_1110_0000;
if(col_addr>=B_xr[79:70]&&col_addr<=B_xr[79:70]+3&&row_addr>=B_yr[71:63]&&row_addr<=B_yr[71:63]+19) vga_data<=12'b1111_1110_0000;
if(col_addr>=B_xl[89:80]&&col_addr<=B_xl[89:80]+3&&row_addr>=B_yl[80:72]&&row_addr<=B_yl[80:72]+19) vga_data<=12'b1111_1110_0000;
if(col_addr>=B_xr[89:80]&&col_addr<=B_xr[89:80]+3&&row_addr>=B_yr[80:72]&&row_addr<=B_yr[80:72]+19) vga_data<=12'b1111_1110_0000;
if(col_addr>=B_xl[99:90]&&col_addr<=B_xl[99:90]+3&&row_addr>=B_yl[89:81]&&row_addr<=B_yl[89:81]+19) vga_data<=12'b1111_1110_0000;
if(col_addr>=B_xr[99:90]&&col_addr<=B_xr[99:90]+3&&row_addr>=B_yr[89:81]&&row_addr<=B_yr[89:81]+19) vga_data<=12'b1111_1110_0000;
//敌方炮弹显示
if(col_addr>=eb_x[9:0]&&col_addr<=eb_x[9:0]+7&&row_addr>=eb_y[8:0]&&row_addr<=eb_y[8:0]+9) vga_data<=12'b0000_0111_1111;
if(col_addr>=eb_x1[9:0]&&col_addr<=eb_x1[9:0]+7&&row_addr>=eb_y1[8:0]&&row_addr<=eb_y1[8:0]+9) vga_data<=12'b0000_0111_1111;
if(col_addr>=eb_x2[9:0]&&col_addr<=eb_x2[9:0]+7&&row_addr>=eb_y2[8:0]&&row_addr<=eb_y2[8:0]+9) vga_data<=12'b0000_0111_1111;
if(col_addr>=eb_x3[9:0]&&col_addr<=eb_x3[9:0]+7&&row_addr>=eb_y3[8:0]&&row_addr<=eb_y3[8:0]+9) vga_data<=12'b0000_0111_1111;
if(col_addr>=eb_x4[9:0]&&col_addr<=eb_x4[9:0]+7&&row_addr>=eb_y4[8:0]&&row_addr<=eb_y4[8:0]+9) vga_data<=12'b0000_0111_1111;
//敌方飞机显示
if(col_addr>=e_x&&col_addr<=e_x+63&&row_addr>=e_y&&row_addr<=e_y+79)begin
if(spo3[11:0]!=12'hfff)begin
vga_data<=spo3[11:0];
end
end
if(col_addr>=e_x1&&col_addr<=e_x1+63&&row_addr>=e_y1&&row_addr<=e_y1+79)begin
if(spo4[11:0]!=12'hfff)begin
vga_data<=spo4[11:0];
end
end
if(col_addr>=e_x2&&col_addr<=e_x2+63&&row_addr>=e_y2&&row_addr<=e_y2+79)begin
if(spo5[11:0]!=12'hfff)begin
vga_data<=spo5[11:0];
end
end
if(col_addr>=e_x3&&col_addr<=e_x3+63&&row_addr>=e_y3&&row_addr<=e_y3+79)begin
if(spo6[11:0]!=12'hfff)begin
vga_data<=spo6[11:0];
end
end
if(col_addr>=e_x4&&col_addr<=e_x4+63&&row_addr>=e_y4&&row_addr<=e_y4+79)begin
if(spo7[11:0]!=12'hfff)begin
vga_data<=spo7[11:0];
end
end
//爆炸显示
if(col_addr>=bo_x&&col_addr<=bo_x+67&&row_addr>=bo_y&&row_addr<=bo_y+63)begin
if(spo_boom[11:0]!=12'hfff)begin
vga_data<=spo_boom[11:0];
end
end
if(col_addr>=bo_x1&&col_addr<=bo_x1+67&&row_addr>=bo_y1&&row_addr<=bo_y1+63)b
egin
if(spo_boom1[11:0]!=12'hfff)begin
vga_data<=spo_boom1[11:0];
end
end
if(col_addr>=bo_x2&&col_addr<=bo_x2+67&&row_addr>=bo_y2&&row_addr<=bo_y2+63)b
egin
if(spo_boom2[11:0]!=12'hfff)begin
vga_data<=spo_boom2[11:0];
end
end
if(col_addr>=bo_x3&&col_addr<=bo_x3+67&&row_addr>=bo_y3&&row_addr<=bo_y3+63)b
egin
if(spo_boom3[11:0]!=12'hfff)begin
vga_data<=spo_boom3[11:0];
end
end
if(col_addr>=bo_x4&&col_addr<=bo_x4+67&&row_addr>=bo_y4&&row_addr<=bo_y4+63)b
egin
if(spo_boom4[11:0]!=12'hfff)begin
vga_data<=spo_boom4[11:0];
end
end
//当前生命值显示
if(hp >2) begin
if(col_addr>=blood_x2[9:0]&&col_addr<=blood_x2[9:0]+15&&row_addr>=blood_y[8:0
]&&row_addr<=blood_y[8:0]+25) vga_data<=12'b0000_0000_1100;
end
if(hp >1) begin
if(col_addr>=blood_x1[9:0]&&col_addr<=blood_x1[9:0]+15&&row_addr>=blood_y[8:0
]&&row_addr<=blood_y[8:0]+25) vga_data<=12'b0000_0000_1100;
end
if(hp >0) begin
if(col_addr>=blood_x[9:0]&&col_addr<=blood_x[9:0]+15&&row_addr>=blood_y[8:0]&
&row_addr<=blood_y[8:0]+25) vga_data<=12'b0000_0000_1100;
end
//ipad
if(col_addr>=0&&col_addr<=639&&row_addr>=0&&row_addr<=479)begin
//ipad
if(spoi[11:0]!=12'hfff)begin
vga_data<=spoi[11:0];
end
end
//game over 后多显示字符图片
if(finish==1)begin
if(col_addr>=g_x&&col_addr<=g_x+191&&row_addr>=g_y&&row_addr<=g_y+39)begin//gameo
ver
vga_data<=spo_finish[11:0];
end
end
end//对应 cover==1 时的 always
else begin //对应 cover==0 的情况，也就是显示封面
if(col_addr>=0&&col_addr<=639&&row_addr>=0&&row_addr<=479)
vga_data<=spo_first;
if(spark == 1)begin
if(col_addr>=253&&col_addr<=398&&row_addr>=251&&row_addr<=255)
vga_data<=12'b0001_0001_0011;
end
end
end//结束显示部分
/////////////////////////////////////////////////////////////////////////////////
//用于检测敌方飞机是否撞到我方飞机
wire check;
wire check1;
wire check2;
wire check3;
wire check4;
//用于检测我方飞机是否被敌方炮弹击中
wire hit_check;
wire hit_check1;
wire hit_check2;
wire hit_check3;
wire hit_check4;
wire clk_10ms;
wire clock_20ms;
clk_10ms c1(clock,clk_10ms);
clk_20ms c2(clock,clock_20ms);
//游戏结束条件
always@(posedge clock)begin
if(hp>0)
finish=(check | check1 | check2 | check3 | check4);
else finish = 1;
end
reg[9:0] blood_x;
reg[9:0] blood_x1;
reg[9:0] blood_x2;
reg[8:0] blood_y;
reg[9:0] MyP_x; //飞机的横坐标
reg[8:0] MyP_y; //飞机的纵坐标
reg[9:0] g_x; //gameover 的横坐标
reg[8:0] g_y; //gameover 的纵坐标
reg[9:0] e_x; //敌方飞机横坐标
reg[8:0] e_y; //敌方飞机纵坐标
reg[9:0] e_x1;
reg[8:0] e_y1;
reg[9:0] e_x2;
reg[8:0] e_y2;
reg[9:0] e_x3;
reg[8:0] e_y3;
reg[9:0] e_x4;
reg[8:0] e_y4;
reg[9:0] eb_x; //敌方炮弹横坐标
reg[8:0] eb_y; //敌方炮弹纵坐标
reg[9:0] eb_x1;
reg[8:0] eb_y1;
reg[9:0] eb_x2;
reg[8:0] eb_y2;
reg[9:0] eb_x3;
reg[8:0] eb_y3;
reg[9:0] eb_x4;
reg[8:0] eb_y4;
reg[9:0] bo_x; //爆炸横坐标
reg[8:0] bo_y; //爆炸纵坐标
reg[9:0] bo_x1;
reg[8:0] bo_y1;
reg[9:0] bo_x2;
reg[8:0] bo_y2;
reg[9:0] bo_x3;
reg[8:0] bo_y3;
reg[9:0] bo_x4;
reg[8:0] bo_y4;
reg[99:0] B_xr; //100 右子弹的横坐标
reg[89:0] B_yr; //100 右子弹的从坐标
reg[99:0] B_xl; //100 左子弹的横坐标
reg[89:0] B_yl; //100 左子弹的从坐标
reg[8:0] BG_Y; //背景的纵坐标
reg[5:0] Counter; //飞机受到攻击次数
reg[5:0] Counter1;
reg[5:0] Counter2;
reg[5:0] Counter3;
reg[5:0] Counter4;
reg flash; //飞机闪烁
integer i=0;
integer cnt=0;
integer count = 0;
integer j=0;
integer j1=0;
integer j2=0;
integer j3=0;
integer j4=0;
integer hp=3;
localparam Left = 15;
localparam Right = 60;
localparam Ini = 9'b111_111_111; //子弹初始不可见位置
localparam Zero = 6'b000_000; //飞机未被攻击的状态
localparam Height = 500;
//调用 我方飞机是否被地方飞机撞上 模块
IsCrash modu(clock, e_x, e_y, MyP_x, MyP_y , check);
IsCrash modu1(clock, e_x1, e_y1, MyP_x, MyP_y , check1);
IsCrash modu2(clock, e_x2, e_y2, MyP_x, MyP_y , check2);
IsCrash modu3(clock, e_x3, e_y3, MyP_x, MyP_y , check3);
IsCrash modu4(clock, e_x4, e_y4, MyP_x, MyP_y , check4);
//调用 我方飞机是否被敌方飞机导弹击中 模块
IsHit hit (clock, eb_x, eb_y, MyP_x, MyP_y , hit_check);
IsHit hit1(clock, eb_x1,eb_y1, MyP_x, MyP_y , hit_check1);
IsHit hit2(clock, eb_x2,eb_y2, MyP_x, MyP_y , hit_check2);
IsHit hit3(clock, eb_x3,eb_y3, MyP_x, MyP_y , hit_check3);
IsHit hit4(clock, eb_x4,eb_y4, MyP_x, MyP_y , hit_check4);
always @(posedge clock_20ms)begin
if(cover==0) BG_Y<=0;
else begin
if(BG_Y<480&&finish==0) BG_Y<=BG_Y+1;
else if(BG_Y>=480&&finish==0) BG_Y<=0;
end
end
always@(posedge clk_10ms)begin
if (cover == 0) begin
//敌方飞机初始化
e_x <= 100;
e_y <= Ini;
e_x1 <= 200;
e_y1 <= Ini;
e_x2 <= 300;
e_y2 <= Ini;
e_x3 <= 400;
e_y3 <= Ini;
e_x4 <= 500;
e_y4 <= Ini;
//初始化敌人炮弹
eb_x = 128;
eb_x1= 228;
eb_x2= 328;
eb_x3= 428;
eb_x4= 528;
eb_y = Ini;
eb_y1= Ini;
eb_y2= Ini;
eb_y3= Ini;
eb_y4= Ini;
//初始化爆炸
bo_x <=100;
bo_y <=Ini;
bo_x1 <=200;
bo_y1 <=Ini;
bo_x2 <=300;
bo_y2 <=Ini;
bo_x3 <=400;
bo_y3 <=Ini;
bo_x4 <=500;
bo_y4 <=Ini;
//初始化 gameover 坐标
g_x <=224;
g_y <=180;
//血量
hp=3;
blood_x = 65;
blood_x1 =85;
blood_x2 =105;
blood_y = 410;
//将子弹初始化在屏幕看不到的地方
B_yr[ 8: 0] <= Ini;
B_yl[ 8: 0] <= Ini;
B_yr[17: 9] <= Ini;
B_yl[17: 9] <= Ini;
B_yr[26:18] <= Ini;
B_yl[26:18] <= Ini;
B_yr[35:27] <= Ini;
B_yl[35:27] <= Ini;
B_yr[44:36] <= Ini;
B_yl[44:36] <= Ini;
B_yr[53:45] <= Ini;
B_yl[53:45] <= Ini;
B_yr[62:54] <= Ini;
B_yl[62:54] <= Ini;
B_yr[71:63] <= Ini;
B_yl[71:63] <= Ini;
B_yr[80:72] <= Ini;
B_yl[80:72] <= Ini;
B_yr[89:81] <= Ini;
B_yl[89:81] <= Ini;
//将敌方飞机血量初始化
Counter =Zero;
Counter1 = Zero;
Counter2 = Zero;
Counter3 = Zero;
Counter4 = Zero;
//分数初始化
scores=64'd00000000;
if(count<100) begin
count = count + 1;
if(count <50) spark =1;
else spark =0;
end
else count = 0;
end
else begin
if (finish==0)begin
cnt=0;
i=i+1;
flash = 1;
if(i==100) i=0;
case(i)
0:begin B_xr[ 9: 0] <= MyP_x+Right;
B_yr[ 8: 0] <= MyP_y+20;
B_xl[ 9: 0] <= MyP_x+Left;
B_yl[ 8: 0] <= MyP_y+20;
end
10:begin B_xr[19:10] <= MyP_x+Right;
B_yr[17: 9] <= MyP_y+20;
B_xl[19:10] <= MyP_x+Left;
B_yl[17: 9] <= MyP_y+20;
end
20:begin B_xr[29:20] <= MyP_x+Right;
B_yr[26:18] <= MyP_y+20;
B_xl[29:20] <= MyP_x+Left;
B_yl[26:18] <= MyP_y+20;
end
30:begin B_xr[39:30] <= MyP_x+Right;
B_yr[35:27] <= MyP_y+20;
B_xl[39:30] <= MyP_x+Left;
B_yl[35:27] <= MyP_y+20;
end
40:begin B_xr[49:40] <= MyP_x+Right;
B_yr[44:36] <= MyP_y+20;
B_xl[49:40] <= MyP_x+Left;
B_yl[44:36] <= MyP_y+20;
end
50:begin B_xr[59:50] <= MyP_x+Right;
B_yr[53:45] <= MyP_y+20;
B_xl[59:50] <= MyP_x+Left;
B_yl[53:45] <= MyP_y+20;
end
60:begin B_xr[69:60] <= MyP_x+Right;
B_yr[62:54] <= MyP_y+20;
B_xl[69:60] <= MyP_x+Left;
B_yl[62:54] <= MyP_y+20;
end
70:begin B_xr[79:70] <= MyP_x+Right;
B_yr[71:63] <= MyP_y+20;
B_xl[79:70] <= MyP_x+Left;
B_yl[71:63] <= MyP_y+20;
end
80:begin B_xr[89:80] <= MyP_x+Right;
B_yr[80:72] <= MyP_y+20;
B_xl[89:80] <= MyP_x+Left;
B_yl[80:72] <= MyP_y+20;
end
90:begin B_xr[99:90] <= MyP_x+Right;
B_yr[89:81] <= MyP_y+20;
B_xl[99:90] <= MyP_x+Left;
B_yl[89:81] <= MyP_y+20;
end
endcase
//飞机产生&敌人炮弹产生
if( clkdiv[20:13]==0 && e_y>Height) begin
e_y<=0;
if(eb_y >Height) begin
eb_y = 45;
end
end
if( clkdiv[17:10]==50 && e_y1>Height) begin
e_y1<=0;
if(eb_y1 >Height) begin
eb_y1 = 30;
end
end
if( clkdiv[19:12]==100 && e_y2>Height) begin
e_y2<=0;
if(eb_y2 >Height) begin
eb_y2 = 13;
end
end
if( clkdiv[18:11]==150 && e_y3>Height) begin
e_y3<=0;
if(eb_y3 >Height) begin
eb_y3 = 27;
end
end
if( clkdiv[21:14]==200 && e_y4>Height) begin
e_y4<=0;
if(eb_y4 >Height) begin
eb_y4 = 40;
end
end
//让子弹飞
if(eb_y < Height+1) begin
if(hit_check==0)
eb_y = eb_y +2;
else begin
eb_y =Ini;
hp = hp - 1;
end
end
if(eb_y1 < Height+1) begin
if(hit_check1==0)
eb_y1 = eb_y1 +2;
else begin
eb_y1 =Ini;
hp = hp - 1;
end
end
if(eb_y2 < Height+1) begin
if(hit_check2==0)
eb_y2 = eb_y2 +2;
else begin
eb_y2 =Ini;
hp = hp - 1;
end
end
if(eb_y3 < Height+1) begin
if(hit_check3==0)
eb_y3 = eb_y3 +2;
else begin
eb_y3 =Ini;
hp = hp -1;
end
end
if(eb_y4 < Height+1) begin
if(hit_check4==0)
eb_y4 = eb_y4 +2;
else begin
eb_y4 =Ini;
hp= hp - 1;
end
end
//敌方飞机状态检测 0
if(Counter >=10)begin
bo_y <= e_y;
if(j<30) begin
j=j+1;
end
else begin
bo_y <= Ini;
e_y <=Ini;
Counter =0;
scores=scores+100;
j=0;
end
end
else if(e_y[8:0]< Ini && Counter <10)begin
e_y[8:0]<=e_y[8:0]+1;
end
//敌方飞机状态检测 1
if(Counter1 >=10)begin
bo_y1 <= e_y1;
if(j1<30) begin
j1=j1+1;
end
else begin
bo_y1 <= Ini;
e_y1 <=Ini;
Counter1 =0;
scores=scores+100;
j1=0;
end
end
else if(e_y1[8:0]< Ini && Counter1 <10) begin
e_y1[8:0]<=e_y1[8:0]+1;
end
//敌方飞机状态检测 2
if(Counter2 >=10)begin
bo_y2 <= e_y2;
if(j2<30) begin
j2=j2+1;
end
else begin
bo_y2 <= Ini;
e_y2 <=Ini;
Counter2 =0;
scores=scores+100;
j2=0;
end
end
else if(e_y2[8:0]< Ini && Counter2 <10) begin
e_y2[8:0]<=e_y2[8:0]+1;
end
//敌方飞机状态检测 3
if(Counter3 >=10)begin
bo_y3 <= e_y3;
if(j3<30) begin
j3=j3+1;
end
else begin
bo_y3 <= Ini;
e_y3 <=Ini;
Counter3 =0;
scores=scores+100;
j3=0;
end
end
else if(e_y3[8:0]< Ini && Counter3 <10) begin
e_y3[8:0]<=e_y3[8:0]+1;
end
//敌方飞机状态检测 4
if(Counter4 >=10)begin
bo_y4 <= e_y4;
if(j4<30) begin
j4=j4+1;
end
else begin
bo_y4 <= Ini;
e_y4 <=Ini;
Counter4 =0;
scores=scores+100;
j4=0;
end
end
else if(e_y4[8:0]< Ini && Counter4 <10)begin
e_y4[8:0]<=e_y4[8:0]+1;
end
if(B_yl[8:0]<9'b111_111_100)begin
if(B_yl[8:0]<=3)begin
B_yl[8:0] <= Ini;
end
else if((MyP_y[8:0]>e_y[8:0])&&(B_xl[9:0]<e_x[9:0]+64 &&
B_xl[9:0]>e_x[9:0])&& (B_yl[8:0]<e_y[8:0]+40)) begin
Counter = Counter +1;
B_yl[8:0] <= Ini;
end
else if((MyP_y[8:0]>e_y1[8:0])&&(B_xl[9:0]<e_x1[9:0]+64 &&
B_xl[9:0]>e_x1[9:0])&& (B_yl[8:0]<e_y1[8:0]+40)) begin
Counter1 = Counter1 +1;
B_yl[8:0] <= Ini;
end
else if((MyP_y[8:0]>e_y2[8:0])&&(B_xl[9:0]<e_x2[9:0]+64 &&
B_xl[9:0]>e_x2[9:0])&& (B_yl[8:0]<e_y2[8:0]+40)) begin
Counter2 = Counter2 +1;
B_yl[8:0] <= Ini;
end
else if((MyP_y[8:0]>e_y3[8:0])&&(B_xl[9:0]<e_x3[9:0]+64 &&
B_xl[9:0]>e_x3[9:0])&& (B_yl[8:0]<e_y3[8:0]+40)) begin
Counter3 = Counter3 +1;
B_yl[8:0] <= Ini;
end
else if((MyP_y[8:0]>e_y4[8:0])&&(B_xl[9:0]<e_x4[9:0]+64 &&
B_xl[9:0]>e_x4[9:0])&& (B_yl[8:0]<e_y4[8:0]+40)) begin
Counter4 = Counter4 +1;
B_yl[8:0] <= Ini;
end
else begin
B_yl[8:0]<=B_yl[8:0]-9'd6;
end
end
if(B_yr[8:0]<9'b111_111_100)begin
if(B_yr[8:0]<=3)begin
B_yr[8:0] <= Ini;
end
else if ((MyP_y[8:0]>e_y[8:0])&&(B_xr[9:0]<e_x[9:0]+64 &&
B_xr[9:0]>e_x[9:0])&& (B_yr[8:0]<e_y[8:0]+40))begin
Counter =Counter +1;
B_yr[8:0] <= Ini;
end
else if ((MyP_y[8:0]>e_y1[8:0])&&(B_xr[9:0]<e_x1[9:0]+64 &&
B_xr[9:0]>e_x1[9:0])&& (B_yr[8:0]<e_y1[8:0]+40))begin
Counter1 =Counter1 +1;
B_yr[8:0] <= Ini;
end
else if ((MyP_y[8:0]>e_y2[8:0])&&(B_xr[9:0]<e_x2[9:0]+64 &&
B_xr[9:0]>e_x2[9:0])&& (B_yr[8:0]<e_y2[8:0]+40))begin
Counter2 =Counter2 +1;
B_yr[8:0] <= Ini;
end
else if ((MyP_y[8:0]>e_y3[8:0])&&(B_xr[9:0]<e_x3[9:0]+64 &&
B_xr[9:0]>e_x3[9:0])&& (B_yr[8:0]<e_y3[8:0]+40))begin
Counter3 =Counter3 +1;
B_yr[8:0] <= Ini;
end
else if ((MyP_y[8:0]>e_y4[8:0])&&(B_xr[9:0]<e_x4[9:0]+64 &&
B_xr[9:0]>e_x4[9:0])&& (B_yr[8:0]<e_y4[8:0]+40))begin
Counter4 =Counter4 +1;
B_yr[8:0] <= Ini;
end
else begin
B_yr[8:0]<=B_yr[8:0]-9'd6;
end
end
//finish
//判断一共十次，限于篇幅，只展示一次的
//finish 10
end// end if row:449
else begin
if(cnt < 200)begin
cnt=cnt+1;
if(cnt <50) flash =0;
else if(cnt <100) flash = 1;
else if(cnt <150) flash = 0;
else flash =1;
end
end
end
end//end always row:448
wire [9:0] data_out;
wire ready;
ps2_ver2 ps2(.clk(clock),.rst(SW[15]),.ps2_clk(ps2_clk),.ps2_data(ps2_data),
.data_out(data_out[9:0]),.ready(ready));
always@(posedge clock_20ms)begin
if(cover==0) begin
MyP_x <=250;
MyP_y <=340;
if(data_out[8]==1'b0)begin
if(data_out[7:0]==8'h5a)begin
cover=1;
end
end
end
else begin
if(data_out[8]==1'b0)begin
if(finish ==0) begin
if(data_out[7:0]==8'h1c&&MyP_x>60)
MyP_x <= MyP_x - 10'd5;
if(data_out[7:0]==8'h23&&MyP_x<510)
MyP_x <= MyP_x + 10'd5;
if(data_out[7:0]==8'h1d &&MyP_y>10)
MyP_y <= MyP_y - 9'd5;
if(data_out[7:0]==8'h1b &&MyP_y<360)
MyP_y <= MyP_y + 9'd5;
end
else begin
if(data_out[7:0]==8'h29)begin
cover = 0;
end
end
end
end
end
BCD b9(scores,BCD);
assign segTestData={BCD};
wire [15:0]ledData;
assign ledData = SW_OK;
ShiftReg
#(.WIDTH(16))ledDevice(.clk(clkdiv[3]),.pdata(~ledData),.sout({LED_CLK,LED_DO,
LED_PEN,LED_CLR}));
endmodule