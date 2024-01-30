//
//  pointer1.c
//
//  Create a pointer to n and use it to increase its value by one
//
//  Created by M. Califano on 25/09/2015.

// include standard i/o library for scanf and printf
#include <stdio.h>

int main() {
	int n = 10;
	int* pointer_to_n = &n;
	*pointer_to_n += 1;
	/* your code goes here */

	/* testing code */
	if (pointer_to_n != &n) {
		printf("Something is wrong with the address\n");
	}
	if (*pointer_to_n != 11) {
		printf("Something is wrong with the value\n");
	}
	if ((pointer_to_n == &n) && (*pointer_to_n == 11)) {
		printf("Done!\n");
	}

	return 0;
}