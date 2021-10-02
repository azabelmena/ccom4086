#include<stdio.h>
#include<unistd.h>

int main(){

    char* shell[2];

    shell[0] = "/bin/sh";
    shell[1] = 0x0;

    execve(shell[0], shell, 0x0);

    return 0;
}
