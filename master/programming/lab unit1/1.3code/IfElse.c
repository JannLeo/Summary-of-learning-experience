//
//  IfElse.c

//
//  Demonstrates an if..else statement

//
//  Created by Craig A. Evans on 06/02/2014.


// include standard i/o library for scanf and printf

#include <stdio.h>


int main(void) {


    int N;   // variable to store number


    // print a prompt to the user

    printf("Enter an integer to test if it is positive or negative:\n");

    scanf("%d", &N);  // read in a value from the keyboard and store in N

    // the %d is for reading in integers. Don't forget the & before the variable name

    // when reading in


    // check if N is less than 0

    if (N < 0) {

        // if it is, print a suitable message. Here we print the value of N to the console

        // the %d will be replaced by the value stored in the variable

        printf("%d is negative\n", N);

    }
    else if (N % 2 == 0) {
        printf("%d is even number\n", N);
    }
    else if (N % 2 == 1) {
        printf("%d is odd number\n", N);
    }
    else {

        // if it not less than 0, it must be positive, so print out a suitable message

        printf("%d is positive\n", N);

    }


    return 0;

}