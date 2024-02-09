//
//  If.c

//
//  Demonstrates an if statement

//
//  Created by Craig A. Evans on 06/02/2014.


// include standard i/o library for scanf and printf

#include <stdio.h>

int main(void) {


    float N;   // variable to store number


    // print a prompt to the user

    printf("Enter an integer to test if it is negative:\n");

    scanf("%f", &N);  // read in a value from the keyboard and store in N

    // the %d is for reading in integers. Don't forget the & before the variable name

    // when reading in


    // check if N is less than 0

    if (N < 0) {

        // if it is, print a suitable message. Here we print the value of N to the console

        // the %d will be replaced by the value stored in the variable

        printf("%.2f is negative\n", N);

    }
    else if (N > 273.15) {
        printf("%.2f is greater or equal to 273.15", N);
    }
    else if (N >= 100) {
        printf("%.2f is greater or equal to 100", N);
    }
    else if (N >= 0) {
        printf("%.2f is positive\n", N);
    }


    return 0;

}