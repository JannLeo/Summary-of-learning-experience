//
//  IfElseifElse.c

//
//  Prints out the degree classification depending on mark

//
//  Created by Craig A. Evans on 06/02/2014.


// include standard i/o library for scanf and printf

#include <stdio.h>


int main(void) {


    float height, weight;   // variable to store number


    // print a prompt to the user

    printf("Enter your height(m):\n");

    scanf("%f", &height);  // read in a value from the keyboard and store in height variable
    printf("Enter your weight(kg):\n");

    scanf("%f", &weight);  // read in a value from the keyboard and store in weight variable

    // the %d is for reading in integers. Don't forget the & before the variable name

    // when reading in
    float bmi = weight / (height * height);

    // check the value of grade and print out the relevant degree classification

    if (bmi > 24) {

        printf("overweight.\n");

    }
    else if (bmi >= 18.5) {

        printf("normal.\n");

    }
    else if (bmi > 0) {

        printf("underweight.\n");

    }

    else {

        printf("Fail.\n");

    }



    return 0;


}