//  string_comp.c
//
//  Simple program to work on strings.
//
//  Created by Marco Califano on 15/09/2015.

// we include the 'standard input/output' header file
// This library contains functions for reading/printing data
#include <stdio.h>
#include <string.h>

int main() {
    /* define first_name */
    /* define last_name */
    char name[100];
    char first_name[20] = "John";
    char last_name[20] = "Doe";
    /* testing code */
    if (strncmp(first_name, "John", 4) != 0) return 1;
    if (strncmp(last_name, "Doe", 3) != 0) return 1;

    last_name[0] = 'B';
    sprintf(name, "%s %s", first_name, last_name);
    if (strncmp(name, "John Boe", 100) == 0) {
        printf("Done!\n");
    }

    return 0;
}