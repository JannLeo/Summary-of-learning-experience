#Uart Reg Map:
#	read valid   0x10000000
#	read data    0x10000004
#	write ready  0x10000008
#	write data   0x1000000C

    .text                   # Define beginning of text section
    .global _start          # Define entry _start
_start:
#-------------addr Init----------------
li x1,0x10000000
li x2,0x10000004
li x3,0x10000008
li x4,0x1000000C
#------------ECHO----------------------
ECHO_Loop:
CheckReadValid:
	lb x5,0(x1)
    beq x5,x0,CheckReadValid
    lb x6,0(x2)					#if valid == 1 read data else loop
    beq x6,x0,ECHO_END			#if data == 0 EXIT else write to Uart
CheckWriteReady:
	lb x5,0(x3)
    beq x5,x0,CheckWriteReady	#if rady == 1 write data else loop
	sb x6,0(x4)
    j ECHO_Loop
ECHO_END:
