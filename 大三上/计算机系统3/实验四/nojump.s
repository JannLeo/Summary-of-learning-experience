.data
array: 	.word 8,6,3,7,1,0,9,4,5,2
.text
main:
	daddi r1,r0,array	#r1=&mx[0]
	
	daddi r2,r0,-1		#r2=i
	daddi r3,r0,10		#r3=length(mx)
	daddi r4,r0,1		#r4用于比较奇偶
Loop:
	daddi r2,r2,1		#r2++
	slt	  r9,r2,r3		#if r2<r3  r9=1
	beq	  r9,r0,exit
	and   r5,r4,r2		#if r2=奇数 r5=1,else r5=0
	dsll  r6,r2,3		#r6=r2*8
	dadd  r7,r1,r6		#r7=&mx[i]
	ld	  r8,0(r7)		#r8=mx[i]
	beq	  r5,r0,Loop	#if r5==0 jump to Loop
	nop
	j 	  Loop
exit:
	halt