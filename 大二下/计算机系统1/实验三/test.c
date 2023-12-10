#include<stdio.h>
int main(){
	int exam[16];
	int i,j;
	for(i=0;i<16;i++){
		scanf("%d",&exam[i]);

	}
	for( i=0;i<16;i++){
		for( j=i+1;j<16;j++){
			if(exam[i]<exam[j]){
				int k=0;
				k=exam[i];
				exam[i]=exam[j];
				exam[j]=k;
			}
		}
	}
	int goal[2]={0,0};
	for( i=0;i<16;i++){
		if(exam[i]>=85&&i<4)
		{
			goal[0]++;
		}
		else if(exam[i]>=75&&i<8){
			goal[1]++;
		}
		
	}
	for(i=0;i<16;i++){
		printf("%d ",exam[i]);
	}
	printf("\n%d\n%d ",goal[0],goal[1]);
}
