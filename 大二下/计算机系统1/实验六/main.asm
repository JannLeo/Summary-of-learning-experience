	.ORIG	X3000
	;��ʼ��ջ��Ĵ���
	AND	R0,R0,#0;
	AND	R1,R1,#0;
	AND	R2,R2,#0;
	AND	R3,R3,#0;
	AND	R4,R4,#0;
	AND	R5,R5,#0;
	AND	R7,R7,#0;
	LD	R6,RR6;
	;���ü����ն�������
	LD	R5,ZDD;
	STI	R5,KWORD;
	;ȷ�������ж�
	LD	R4,A;     R4������
	STI	R4,KBSR;
	;��ʼ���ICS����ʼdelay
LOP	AND	R1,R1,#0;
	ADD	R1,R1,#6;
LOOP	LEA	R0,ICS;
	PUTS
	JSR	DELAY
	ADD	R1,R1,#-1;
	BRp	LOOP;
	LEA	R0,HC;
	PUTS
	ADD	R1,R1,#6;
LOOP1	LEA	R0,ICS1;
	PUTS
	JSR	DELAY
	ADD	R1,R1,#-1;
	JSR	DELAY
	BRp	LOOP1
	LEA	R0,HC;
	PUTS
	BRnzp	LOP

DELAY   ST  	R1, SaveR1
        LD  	R1, COUNT
REP  	ADD 	R1,R1,#-1
	BRp 	REP
       	LD  	R1, SaveR1
        RET
HC	.stringz	"\n"
COUNT   .FILL 	#2500
SaveR1  .BLKW 	1				
ICS	.stringz	"ICS    "
ICS1	.stringz	"    ICS"
KBDR	.FILL	XFE02
KBSR	.FILL	XFE00;
A	.FILL	X4000
SIX	.FILL	X09C4;��2500 delay
ZDD	.FILL	X2000
KWORD	.FILL	X0180
RR6	.FILL	X3000
	.END