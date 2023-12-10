#include <stdio.h>
#include <stdlib.h>
#include "variance.h"

int main(int argc , char ** argv)
{
   if(4 != argc || NULL == argv)
	{
		printf("error, you need put 3 parameters\n");
		return -1;
    }
	char flag = atoi(argv[1]);
	double first = atof(argv[2]);
	double second = atof(argv[3]);
	printf("first = %f, second = %f",first,second);
	if(1 == flag){
        printf("variance ceil is %d ",variance_ceil(first,second));
	}
	else if(-1 == flag){
		printf("variance floor is %d ",variance_floor(first,second));
	}
	return 0;
}
