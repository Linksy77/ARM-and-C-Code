/*******************************************************************************
 * Filename: lab3.c
 * Description: Lab 3: Approximates the integral of f(x) over [a,b] using the midpoint rule.
 ******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
// #include <libm/math.h>
#include <stdbool.h>

double valAtPoint(double x) {
    return (1.5 * pow(x, 3)) + (3.2 * pow(x, 2)) - (4 * x) + 13;
}

void rieSum(float a, float b, int numOfRec) {
    double pastApprox, newApprox, rectWidth, currMidPoint;

    rectWidth = (b - a)/numOfRec;
    currMidPoint = a + (rectWidth/2);
    pastApprox = 0;
    newApprox = 10; // Random value so as to initiate the while loop

    bool firstRun = true;
    while(newApprox - pastApprox > 1e-4) {
        // Double num of rec until diff btwn two consecutive approximations <= 1e-4
        if(!firstRun) {
            numOfRec *= 2;
            rectWidth = (b - a)/numOfRec;
            currMidPoint = a + (rectWidth/2);
        }
        
        pastApprox = newApprox;
        newApprox = 0;

        for(int i = 1; i <= numOfRec; i++) {
            newApprox += valAtPoint(currMidPoint) * rectWidth; // Summation of each rectangle using valAtPoint function
            currMidPoint += rectWidth;
        }

        if(firstRun) {
            firstRun = false;
        }
    }

    // Print out number of rectangles needed for newApprox - pastApprox <= 1e-4 to be true.
    // Print out the last two approximate values of the integral
    printf("Number of rectangles: %d.\n", numOfRec);
    printf("Last two approximate values of integral: %f and %f.\n", pastApprox, newApprox);

    
}

int main(int argc, char const *argv[]) {
    float a, b;
    int initNumOfRec;

    // Checking if the interval is valid
    if(argc != 4) {
        printf("Three arguments expected.\n");
    } else if(atof(argv[1]) > atof(argv[2])) {
        printf("Invalid interval; greater value must be last.\n");
    } else if(a < 0 || b < 0) {
        printf("Invalid interal; all values must be positive.\n");
    } else {
        // If interval is valid:
        a = atof(argv[1]);
        b = atof(argv[2]);
        initNumOfRec = atoi(argv[3]);

        // Actual code call
        rieSum(a, b, initNumOfRec);
    }

    return 0;

}