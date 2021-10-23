long absdiff(long x, long y){
    long result;

    if(x < y){
        result = y-x;
    }
    else{
        result = x-y;
    }

    return result;
}

long absdiffGoto(long x, long y){
    long result;
    int test = (x>y);

    if(test){
        goto Then;
    }
Else:
    result = y-x;
    goto Done;
Then:
    result = x-y;
Done:
    return result;
}

long absdiffSwitch(long x, long y){
    return (x>y) ? x-y : y-x;
}

long absdiffcmov(long x, long y){
    long rval = y-x;
    long eval = x-y;
    long test = (x >= y);

    if(test){
        rval = eval;
    }

    return rval;
}
