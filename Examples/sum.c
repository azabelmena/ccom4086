#include<stdio.h>

long plus(long, long);

void sumstore(long x, long y, long *dest){
    
    long t = plus(x,y);
    *dest = t;

    return;
}


int main(int argc, char* argv[]){

    long int x = 0;
    long int y = 0;
    long int *t = 0x0;
    
    sumstore(x, y, t);

    return 0;
}

long plus(long x, long y){
    return x+y;
}
