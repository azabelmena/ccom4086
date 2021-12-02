#include<stdio.h>

long plus(long, long);

void sumstore(long x, long y, long *dest){

    long t = plus(x,y);
    *dest = t;

    return;
}

int main(int argc, char* argv[]){

    long int x = 0x111e;
    long int y = 1;
    long int *t = &x;
    sumstore(x, y, t);

    return 0;
}

long plus(long x, long y){
    return x+y;
}

long sum(long *start, long count){
    long sum = 0;

    while(count){
        sum += *start;

        start++;
        count--;
    }

    return sum;
}
