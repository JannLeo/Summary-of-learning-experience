//
//  while_over5.c
//
//  Prints out the array elements if their value is between 5 and 10
//
//  Created by M. Califano on 25/09/2015.

// include standard i/o library for scanf and printf
#include <stdio.h>

int main() {
    int array[] = { 1, 7, 4, 5, 9, 3, 5, 11, 6, 3 };
    int i = 0;

    while (i < 10) {
        /* your code goes here */
        if (array[i] < 5) {
            i++;
            continue;
        }
        else if (array[i] > 10) {
            break;
        }
        printf("%d\n", array[i]);
        i++;
    }

    return 0;
}