long Q(long x){
    return -x;
}
long P(long x, long y){
    long u = Q(y);
    long v = Q(x);

    return u+v;
}


int main(){

    P(2,5);

    return 0;
}
