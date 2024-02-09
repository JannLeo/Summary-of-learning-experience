//
//  for_list1_10.c
//
//  Prints out the numbers 1 to 10
//
//  Created by M. Califano on 25/09/2015.

// include standard i/o library for scanf and printf
#include <stdio.h>

int main(void) {

    int i;   // counter for the number of loops
    int sum = 0;
    int N;
    printf("Please input the number N\n");
    scanf("%d", &N);
    for (i = 1; i <= N; i++)
    {
        sum += i;
        printf("i = %d, sum = %d\n", i, sum);  // print out i
    }

    return 0;

}