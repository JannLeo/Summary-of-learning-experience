// for scanf/printf
#include <stdio.h>
// for pow
#include <math.h>

// here we define PI - if we use PI in our code, the compiler will directly replace it by the number
#define PI 3.1415926536

// function prototypes - all functions must be listed at the top of the program to help the compiler
float areaOfSquare(float length);  // remember to add the ; at the end of the declaration
float areaOfCircle(float radius);
float areaOfRectangle(float width, float height);
void printRectangle(int width, int height);
float areaOfTriangle(float width, float height);
float volumeOfCube(float width);
float volumeOfSphere(float radius);

// main function - start of the program
int main(void) {

    // create variables for the length and area of a sqaure
    float squareArea;
    float lengthOfSide;
    float anotherSquareArea;
    float radius;   // variables for radius and area of the circle
    float circleArea;
    float rectangleHeight;  // variables for height, width and area of a rectangle
    float rectangleWidth;
    float rectangleArea;
    int width, height;

    // set length of side
    lengthOfSide = 2.5;
    // call function and store result in variable
    squareArea = areaOfSquare(lengthOfSide);
    printf("The area of a square of length %f m is %f m2\n", lengthOfSide, squareArea);


    anotherSquareArea = areaOfSquare((float)0.1);
    printf("The area of a square of length 0.1 m is %f m2\n", anotherSquareArea);


    radius = 1.5; // circle radius of 1.5 m
    circleArea = areaOfCircle(radius);  // call area function
    printf("The area of a circle of radius %f m is %f m2\n", radius, circleArea);

    printf("\nEnter the radius of a circle:\n");
    scanf("%f", &radius);  // read from stdin (keyboard input) into radius variable (remember the &)
    circleArea = areaOfCircle(radius);  // call area function
    printf("The area of a circle of radius %f m is %f m2\n", radius, circleArea);

    // define values for height and width of a rectangle
    rectangleHeight = 3.0;
    rectangleWidth = 1.0;
    // calculate the area
    rectangleArea = areaOfRectangle(rectangleWidth, rectangleHeight);
    printf("The area of a rectangle of width %f m and height %f m is %f m2\n", rectangleWidth, rectangleHeight, rectangleArea);


    printf("\nPrint a rectangle below\n");
    // read in values
    printf("Enter units width (integer)\n");
    scanf("%d", &width);
    printf("Enter units height (integer)\n");
    scanf("%d", &height);
    // and print rectangle
    printRectangle(width, height);
    width = 0;
    height = 0;
    printf("Input a triangle's width and height.\n");
    printf("Enter triangle width (integer)\n");
    scanf("%d", &width);
    printf("Enter triangle height (integer)\n");
    scanf("%d", &height);
    printf("The area of a rectangle of width %d m and height %d m is %f m2\n", width, height, areaOfTriangle(width, height));
    width = 0;
    height = 0;
    printf("Input a cube width.\n");
    printf("Enter cube width (integer)\n");
    scanf("%d", &width);
    printf("The area of a cube of width %d m  is %f m2\n", width, volumeOfCube(width));
    radius = 0;
    printf("Input a sphere radius.\n");
    printf("Enter sphere radius (integer)\n");
    scanf("%f", &radius);
    printf("The area of a sphere of radius %f m  is %f m2\n", radius, volumeOfSphere(radius));

    return 0;  // end of main

}

// returns the area of a square - the units are metres
float areaOfSquare(float length) {

    // square the length and return
    return length * length;

}

// returns the area of a circle - radius in metres
float areaOfCircle(float radius) {

    // PI is defined at the top of the program
    float area = PI * pow(radius, 2.0);  // calculate the area - note we cannot do radius^2 like MATLAB
    // we can either do radius*radius or else use the pow() function from math.h

    return area;  // return the variable
}

// calculates the area of a rectangle - takes in the width and height
float areaOfRectangle(float width, float height) {

    return width * height;

}

// calculates the area of a triangle - takes in the width and height
float areaOfTriangle(float width, float height) {
    return width * height / 2;
}

//calculates the volume of a cube - takes in the width 
float volumeOfCube(float width) {
    return width * width * width;
}

//calculates the volume of a Sphere - takes in the width 
float volumeOfSphere(float radius) {
    return radius * radius * radius * 4 * PI / 3;
}


// 'prints' a rectangle in the console - takes in width and height in arbitrary units
void printRectangle(int width, int height) {

    int i, j;  // counters for loops
    printf("\n");  // print a new line

    for (i = 0; i < height; i++) {  // loop through rows
        for (j = 0; j < width; j++) {  // loop across columns
            printf("#");  // print a block for each column
        }
        printf("\n");  // start a new line at the end of first row
    }

    printf("\n"); // leave a blank line for neatness
    // is a void so no need to return
}
