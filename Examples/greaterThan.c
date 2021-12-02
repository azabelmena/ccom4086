#include<stdio.h>

int greaterThan(long, long);


int main(){

    printf("%d\n", greaterThan(1, 2));

    return 0;
}

int greaterThan(long x, long y){
    return x > y;
}
