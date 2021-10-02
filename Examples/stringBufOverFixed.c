/*
A simple program to demonstrate how stack based buffer overflows works.
To understand what is happening, the code should be run through an assembler.
*/
#include<string.h>
#include<stdio.h>

// Copies a string to a buffer of size 16.
void copy(char*);

int main(int argc, char* argv[]){

    copy(argv[1]);

    printf("Program returned 0.\n");

    return 0;
}

void copy(char* str){

    char buffer[16]; // declare a string of size 16.

    strncpy(buffer, str, 16);
    printf("%s\n", buffer);

    return;
}
