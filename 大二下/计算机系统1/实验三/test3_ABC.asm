	.ORIG x3000  ;		��ʼ��ַΪx3000
	;��ʼ��
	AND	R3,R3,#0; 	
	AND	R2,R2,#0;	
	AND	R3,R3,#0;	
	AND	R0,R0,#0;	
	AND	R1,R1,#0;
	AND	R4,R4,#0;
			
	;��ȡ����
BEGINN	ADD	R3,R4,#0;	ʹR3ΪR4��ȡ���ֵ���һλ��
	AND	R0,R0,#0;	R0��ʼ��	
	LD	R2,NUM;		ȡ��ַ
	ADD 	R2,R2,R4;	ȡ��ַ
	STI	R2,REC1;	���ַ
	LDR	R1,R2,#0;	ȡ����	
	ADD	R0,R0,R1;	ȡR1
	;	��ȡ����1  ����R1��R0	��
LOAD	ST	R3,STO3;	������
	LD	R2,NUM;		ȡ����
	ADD	R3,R3,R2;	ȡ��ַ
	ADD 	R2,R2,R4;	ȡ��ַ
	STI	R3,REC3;	���ַ
	AND	R2,R2,#0;	��ʼ��
	LDR	R2,R3,#0;	��ȡ����2��R2   	��
	LD	R3,STO3;	������
	ADD	R3,R3,#1;	++
	;�жϵڶ������
	ADD	R5,R3,#-16;	�Ƚ�
	BRp	ADD4	;
	;ִ�бȽ�
CMP	NOT	R7,R2;
	ADD	R7,R7,#1;	ȡ����һ
	ADD	R6,R0,R7;	R1-R2<0,�����
	BRp	LOAD	;
	AND	R0,R0,#0;
	ADD	R0,R0,R2;	
	LDI	R2,REC3;
	STI	R2,REC2;
	BRnzp	LOAD	;

	;����R0,����R4
ADD4	AND	R3,R3,#0;
	AND	R6,R6,#0;
	LDI	R6,REC1;
	LDR	R5,R6,#0;
	LDI	R3,REC2;
	LDR	R7,R3,#0;
	STR	R7,R6,#0;
	STR	R5,R3,#0;
	ADD	R4,R4,#1;
	;�жϵ�һ�����
	ADD	R7,R4,#-16;	����R4 			
	BRn	BEGINN	;	��R4-16>0,�����  �ж�R4�Ƿ�ȡ��
	;
	;����Ϊ����
	;
	;���°�����ת��
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
	;����Ϊ��AB
	;R0Ϊ�ɼ� R1��¼λ��  R6����A ,R7����B
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
REC2	.FILL	x4502		;��2���ֵ�ַ
REC1	.FILL	x4501		;��1���ֵ�ַ
STO3	.FILL	x4444		;
SAVEA	.FILL	x4100		;���ABC��4100 4101
NUM	.FILL	x3200		;��ȡ�������ֵĵ�ַ
FINNUM	.FILL	x4000		;�������ĵ�ַ
	.END