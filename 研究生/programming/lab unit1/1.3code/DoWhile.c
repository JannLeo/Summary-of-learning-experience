//
//  DoWhile.c

//
//  Prints out the sum of numbers less than 10

//
//  Created by Craig A. Evans on 06/02/2014.


// include standard i/o library for scanf and printf

#include <stdio.h>


int main(void) {


    int factorials = 1;   // variable to store sum, initialised to 0

    int i = 1;     // counter for the number of loops, initialised to 0

    int N;
    printf("Please input the number N\n");
    scanf("%d", &N);
    do {
        i = i + 1;
        factorials = factorials * i;  // add i to sum and store back in sum.  Can also do sum+=i;

        // increment i by 1.  Can also do i++;

        printf("i = %d factorials = %d\n", i, factorials);  // print out i and sum for debugging

    } while (i < N);


    printf("factorials = %d\n", factorials);  // print final sum


    return 0;


}