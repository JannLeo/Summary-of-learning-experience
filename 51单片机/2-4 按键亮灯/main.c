#include <REGX52.H>
void Delay(unsigned int xms)		//@12.000MHz
{
	unsigned char i, j;
	while(xms--){
		i = 2;
		j = 239;
		do
		{
			while (--j);
		} while (--i);
	}
	
}
void main(){
	int A1, A2, A3 = 0,i;
	while(1){
		if(P3_1==0){
			Delay(20);
			while(!P3_1);
			Delay(20);
			A3++;
			
		}
		else if(P3_0 == 0){
			Delay(20);
			while(!P3_0);
			Delay(20);
			A3--;
			if(A3<0)
				A3=0;
		}
			
		A1 = 0xFF;
		A2 = 0x01;
		for (i = 0; i < A3 % 8; i++) {
			A2 = A2 << 1;
		}
		P2 = A1 ^ A2;
	}
}
	
	