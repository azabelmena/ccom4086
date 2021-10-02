#include<string.h>
#include<stdio.h>
#include<unistd.h>

// Copies a string to a buffer of size 16.
void copy(char*);

int main(int argc, char* argv[]){

    static char input[1024];

    while(read(STDIN_FILENO, input, 1024)>0){
        copy(input);
    }

    return 0;
}

void copy(char* str){

    char buffer[128];
    strcpy(buffer, str);
    printf("%s\n");

    return;
}
