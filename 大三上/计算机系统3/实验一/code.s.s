.data   
array: .word 1,2,3,4,5,6,7,8,9,10 #��ʼ������   
.text   
la a0 , array #a0 = array   
li a1 , 10    #a1 = 10 (len)   
call calSum   #����calsum����   
j STOP  
	  
#int calSum(int *array ,int len);   
calSum:   
 andi a2,a2,0
 andi a3,a3,0
Loop:
    slti t5,a3,0
    bne t5,zero,8
    slt t6,a3,a1
    beq t6,zero,6
    slli t4,a3,2
    add t4,t4,a0
    lw t3,0(t4)
    add a2,a2,t3
    addi a3,a3,1
    j Loop
Exit:
    andi a0,a0,0
    addi a0,a2,0
    ret
STOP:  
    nop #��ָ��,��ʲô������(�൱��addi x0 , 0)
