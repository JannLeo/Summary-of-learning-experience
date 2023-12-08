#include <REGX52.H>
#include <STDIO.H>
void Delay500ms()		//@12.000MHz
{
	unsigned char i, j, k;

	i = 4;
	j = 205;
	k = 187;
	do
	{
		do
		{
			while (--k);
		} while (--j);
	} while (--i);
}

void main(){
	int A1, A2, A3 = 0,i;
	while(1){
		Delay500ms();
		A3++;
		A1 = 0xFF;
		A2 = 0x01;
		for (i = 0; i < A3 % 8; i++) {
			A2 = A2 << 1;
		}
		P2 = A1 ^ A2;
		Delay500ms();
	}
}