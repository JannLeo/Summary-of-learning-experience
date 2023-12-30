.data
str:  .asciiz "the data of matrix 3:\n"
mx1:   .space 512
mx2:   .space 512
mx3:   .space 512

.text
initial:     
			daddi r22,r0,mx1	#r22=矩阵1 这个initial模块是给三个矩阵赋初值
            daddi r23,r0,mx2	#r23=矩阵2
			daddi r21,r0,mx3	#r21=矩阵3
input:		
			daddi r9,r0,64		#r9=64
			daddi r8,r0,0		#r8=0
loop1:		
			dsll r11,r8,3		#r11=r8*8                   for(int i=0;i<64;i++){
			dadd r10,r11,r22	#r10=&矩阵1[r8]					mx1[i]=2
			dadd r11,r11,r23	#r11=&矩阵2[r8]					mx2[i]=3
			daddi r12,r0,2		#r12=2						}
			daddi r13,r0,3		#r13=3
			sd r12,0(r10)		#矩阵1[r8]=r12=2
			sd r13,0(r11)		#矩阵2[r8]=r13=3

			daddi r8,r8,1		#r8++
			slt r10,r8,r9		#if r8<64 r10=1
			bne r10,r0,loop1	#if r10!= 0 jump loop1

mul:		
			daddi r16,r0,8		#r16=8
			daddi r17,r0,0		#r17=0
loop2:		
			daddi r18,r0,0		# r18=0 这个循环是执行for(int i = 0, i < 8; i++)的内容
loop3:		
			daddi r19,r0,0		#  r19=0 这个循环是执行for(int j = 0, j < 8; j++)的内容
			daddi r20,r0,0		#  r20=0 r20存储在计算result[i][j]过程中每个乘法结果的叠加值
loop4:		
			dsll r8,r17,6		#r8=r17*64 这个循环的执行计算每个result[i][j]
			dsll r9,r19,3		#r9=r19*8
			dadd r8,r8,r9		#r8=r8+r9
			dadd r8,r8,r22		#r8=&mx1[r19]          for(int i=0;i<8;i++){
			ld r10,0(r8)		#取mx1[i][k]的值		for(int j=0;j<8;j++){
			dsll r8,r19,6		#r8=r19*64					for(int k=0;k<8;k++){
			dsll r9,r18,3		#r9=r18*8						result[i][j]=mx1[i][k]*mx2[k][j];
			dadd r8,r8,r9		#								}}}
			dadd r8,r8,r23
			ld r11,0(r8)		#取mx2[k][j]的值
			dmul r13,r10,r11	#mx1[i][k]与mx2[k][j]相乘
			dadd r20,r20,r13	#中间结果累加

			daddi r19,r19,1
			slt r8,r19,r16
			bne r8,r0,loop4

			dsll r8,r17,6
			dsll r9,r18,3
			dadd r8,r8,r9
			dadd r8,r8,r21	#计算result[i][j]的位置
			sd r20,0(r8)		#将结果存入result[i][j]中

			daddi r18,r18,1
			slt r8,r18,r16          #if r18<r16  r8=1
			bne r8,r0,loop3			#if r8!=0 jump loop3

			daddi r17,r17,1
			slt r8,r17,r16			#if r17<r16   r8=1
			bne r8,r0,loop2			#if r8!=0 jump to loop2

			halt
