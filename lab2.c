/*******************************************************************************
 * Filename: lab2.c
 * Description: Lab 2: Prints out the binary form of any 32-bit integer number.
 ******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

void display(uint8_t bit) {
    putchar(bit + 48);
}

void display_32(uint32_t num) {
    for(uint i = 1u << 31; i != 0; i >>= 1) {
        if(i & num) {
            display(1);
        } else {
            display(0);
        }
    }
    
}

int main(int argc, char const *argv[]) {
    if(argc != 2) {
        printf("One argument expected.\n");
    } else {
        uint32_t inp = atoi(argv[1]);
        display_32(inp);
        printf("\n");
    }
    
    uint32_t x = 382;
    display_32(x);
    printf("\n");

    return 0;
}
