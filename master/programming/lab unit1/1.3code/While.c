//
//  While.c

//
//  Prints out the sum of numbers less than 10

//
//  Created by Craig A. Evans on 06/02/2014.


// include standard i/o library for scanf and printf

#include <stdio.h>

int
main(void) {


    int sum = 0;   // variable to store sum, initialised to 0

    int i = 0;     // counter for the number of loops, initialised to 0
    int N;
    printf("Please input the number N\n");
    scanf("%d", &N);

    while (i <= N) {

        sum = sum + i;  // add i to sum and store back in sum.  Can also do sum+=i;

        i = i + 1;  // increment i by 1.  Can also do i++;

        printf("i = %d sum = %d\n", i, sum);  // print out i and sum for debugging

    }


    printf("Sum = %d\n", sum);  // print final sum


    return 0;


}