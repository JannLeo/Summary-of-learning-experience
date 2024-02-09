//  Average.c
//
//  Simple program to print the average of 3 marks.
//
//  Created by Marco Califano on 15/09/2015.

// we include the 'standard input/output' header file
// This library contains functions for reading/printing data 
#include <stdio.h>

int main() {
  
  int average;   // variable to store average

  grades[0] = 80;  // first mark
  grades[2] = 90;  // last mark
  // calculate the average
  average = (grades[0] + grades[1] + grades[2]) / 3;  
  // print it out
  printf("The average of the 3 grades is: %d", average);

  return 0;
}