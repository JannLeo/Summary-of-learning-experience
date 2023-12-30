.text
.global _start     
_start: 
    li t0,0x10000000    #read valid   0x10000000
    li t1,0x10000004    #read data    0x10000004
    li t2,0x10010000    #LED state 

    #init
    addi t6,x0,15
    sw t6,0(t2)

LOOP:
CheckReadValid:
    lb t3,0(t0)
    beq t3,x0,CheckReadValid
    lb t4,0(t1)                  #if valid == 1 read data else loop
    # change led state
    addi t4,t4,-48               #char to int
    addi t5,x0,1                 #select led
    sll  t5,t5,t4
    sw t5,0(t2)
    j LOOP
