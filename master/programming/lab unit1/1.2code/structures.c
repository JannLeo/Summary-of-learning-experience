//
//  structures.c
//
//  Demonstrates the use of a structure
//
//  Created by Marco Califano on 10/10/2015.

// include standard i/o library for scanf and printf
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/* define the person struct here using the typedef syntax */

typedef struct {
    char* name;
    int age;
    char* status;
}person;

struct threedpoint {
    float x;
    float y;
    float z;
};

int main() {

    person john;
    john.name = (char*)malloc(50);  // Assuming a maximum length for the name
    john.status = (char*)malloc(20);  // Assuming a maximum length for the status

    /* testing code */
    strcpy(john.name, "John");
    john.age = 27;
    strcpy(john.status, "single");
    printf("%s is %d years old and is %s.\n", john.name, john.age, john.status);
    threedpoint threed;
    threed.x = 0.001;
    threed.y = 0.72;
    threed.z = 13.5;
    printf("The 3D point coordinates is (%.3f,%.2f,%.1f)", threed.x, threed.y, threed.z);
    free(john.name);
    free(john.status);
}