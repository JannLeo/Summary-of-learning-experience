	.ORIG x3000  ;		起始地址为x3000
	;初始化
	AND	R3,R3,#0; 	
	AND	R2,R2,#0;	
	AND	R3,R3,#0;	
	AND	R0,R0,#0;	
	AND	R1,R1,#0;
	AND	R4,R4,#0;
			
	;读取数字
BEGINN	ADD	R3,R4,#0;	使R3为R4读取数字的下一位√
	AND	R0,R0,#0;	R0初始化	
	LD	R2,NUM;		取地址
	ADD 	R2,R2,R4;	取地址
	STI	R2,REC1;	存地址
	LDR	R1,R2,#0;	取数字	
	ADD	R0,R0,R1;	取R1
	;	读取数字1  放入R1与R0	√
LOAD	ST	R3,STO3;	存数字
	LD	R2,NUM;		取数字
	ADD	R3,R3,R2;	取地址
	ADD 	R2,R2,R4;	取地址
	STI	R3,REC3;	存地址
	AND	R2,R2,#0;	初始化
	LDR	R2,R3,#0;	读取数字2于R2   	√
	LD	R3,STO3;	读数字
	ADD	R3,R3,#1;	++
	;判断第二层结束
	ADD	R5,R3,#-16;	比较
	BRp	ADD4	;
	;执行比较
CMP	NOT	R7,R2;
	ADD	R7,R7,#1;	取反加一
	ADD	R6,R0,R7;	R1-R2<0,则调换
	BRp	LOAD	;
	AND	R0,R0,#0;
	ADD	R0,R0,R2;	
	LDI	R2,REC3;
	STI	R2,REC2;
	BRnzp	LOAD	;

	;存入R0,增加R4
ADD4	AND	R3,R3,#0;
	AND	R6,R6,#0;
	LDI	R6,REC1;
	LDR	R5,R6,#0;
	LDI	R3,REC2;
	LDR	R7,R3,#0;
	STR	R7,R6,#0;
	STR	R5,R3,#0;
	ADD	R4,R4,#1;
	;判断第一层结束
	ADD	R7,R4,#-16;	调出R4 			
	BRn	BEGINN	;	若R4-16>0,则继续  判断R4是否取完
	;
	;以上为排序
	;
	;以下把数据转移
	;
	AND	R0,R0,#0;
	AND	R1,R1,#0;
	AND	R2,R2,#0;
SSS	LD	R0,NUM;
	LD	R1,FINNUM;
	ADD	R0,R0,R2;
	ADD	R1,R1,R2;
	LDR	R3,R0,#0;
	LDR	R4,R1,#0;
	STR	R3,R1,#0;
	ADD	R2,R2,#1;
	ADD	R5,R2,#-16;
	BRn	SSS;
	;
	;以下为排AB
	;R0为成绩 R1记录位数  R6计数A ,R7计数B
	AND	R0,R0,#0;
	AND	R1,R1,#0;
	AND	R6,R6,#0;
	AND	R6,R6,#0;
KKK	LD	R2,FINNUM;
	ADD	R2,R2,R1;
	LDR	R0,R2,#0;
	AND	R5,R5,#0;
	ADD	R1,R1,#1;
	ADD	R4,R1,#-4;
	BRp	B;
	ADD	R5,R0,#-16;
	ADD	R5,R5,#-16;
	ADD	R5,R5,#-16;
	ADD	R5,R5,#-16;
	ADD	R5,R5,#-16;
	ADD	R5,R5,#-5;
	BRn	B;
A	ADD	R6,R6,#1;
B	ADD	R4,R1,#-8;
	BRp	aaa;
	ADD	R5,R0,#-16;
	ADD	R5,R5,#-16;
	ADD	R5,R5,#-16;
	ADD	R5,R5,#-16;
	ADD	R5,R5,#-11;
	BRn	KKK;
	ADD	R7,R7,#1;
	BRnzp	KKK;
aaa	LD	R0,SAVEA;
	STR	R6,R0,#0;
	STR	R7,R0,#1;	
REC4	.FILL	x4504	
REC3	.FILL	x4503
REC2	.FILL	x4502		;存2数字地址
REC1	.FILL	x4501		;存1数字地址
STO3	.FILL	x4444		;
SAVEA	.FILL	x4100		;存放ABC于4100 4101
NUM	.FILL	x3200		;读取输入数字的地址
FINNUM	.FILL	x4000		;输出排序的地址
	.END