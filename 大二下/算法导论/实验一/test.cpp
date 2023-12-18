#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include<math.h>
int main()
{
	int t=10000,i=0;
	char str[]="";
	sprintf(str,"aabb%d",t);
	printf("%s\n",str);
	if(t==10000)
	{
		printf("no wrong");
	}
	else
	{
		printf("%d",t);
	}
}
