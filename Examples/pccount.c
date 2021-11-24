#define WSIZE 8*sizeof(int)

long pccountDo(unsigned long x){
    long result = 0;

    do{
        result += x & 0x1;
        x >>= 1;
    }while(x);

    return result;
}

long pccountWhile(unsigned long x){
    long result = 0;

    while(x){
        result += x & 0x1;
        x >>= 1;
    }

    return result;
}

long pccountGoto(unsigned long x){
    long result = 0;

loop:
    result += x & 0x1;
    x >>= 1;

    if(x){
        goto loop;
    }

    return result;
}

long pccountGotoWhile(unsigned long x){
    long result = 0;

loop:
    result += x & 0x1;
    x >>= 1;

test:
    if(x){
        goto loop;
    }

    return result;
}

long pcountFor(unsigned long x){
    long result = 0;

    for(int i = 0; i < WSIZE ; i++){
        unsigned bit = (x >> i) & 0x1;

        result += bit;
    }

    return result;
}
