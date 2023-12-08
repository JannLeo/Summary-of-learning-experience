#include <REGX52.H>
void Delay(int time)		//@12.000MHz
{
	unsigned char i, j;
	while(time--){
		i = 2;
		j = 239;
		do
		{
			while (--j);
		} while (--i);
	}
}

unsigned char delight_num [10]= {0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f};

void Led_numset(unsigned int led_num, unsigned int screen_num){
	switch(led_num)
	{
		case 1: P2_2 = 1; P2_3 = 1; P2_4 = 1; break;
		case 2: P2_2 = 1; P2_3 = 1; P2_4 = 0; break;
		case 3: P2_2 = 1; P2_3 = 0; P2_4 = 1; break;
		case 4: P2_2 = 1; P2_3 = 0; P2_4 = 0; break;
		case 5: P2_2 = 0; P2_3 = 1; P2_4 = 1; break;
		case 6: P2_2 = 0; P2_3 = 1; P2_4 = 0; break;
		case 7: P2_2 = 0; P2_3 = 0; P2_4 = 1; break;
		case 8: P2_2 = 0; P2_3 = 0; P2_4 = 0; break;
		default:break;
	}
	P0=delight_num[screen_num];
	Delay(1);
	P0=0x00;
}
void Show_number(int* num){
	int i=1;
	for(i=1;i<9;i++){
		Led_numset(i,num[i]);
	}
}


void main(){
	int j;
	int l=1000;
	unsigned int bignum = 999999999;
	unsigned int num2;
	int number[10] = {9,9,9,9,9,9,9,9,9,9};
	while(1){
		
		
			
			bignum--;
			num2=bignum;
			for(j=1;j<=9;j++){
				
				number[10-j]=num2%10;
				num2/=10;
			}
			while(l--){
				Show_number(number);
			}
			l=100;
			
		
	}
}