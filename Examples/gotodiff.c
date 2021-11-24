// Return the absolute value difference of two integers.

long ltCnt = 0;
long geCnt = 0;

long gotodiff(long x, long y){
    long result;

    if(x >= y){ // If x >= y, goto true.
        goto True;
    }

    ltCnt++; // increment leCnt and return y-x.
    
    result = y-x;
    
    return result;

True: // increment geCnt and return x-y.
    geCnt++;

    result = x-y;

    return result;
}

long diff(long x, long y){
    long result;

    if(x>= y){
        geCnt++;

        result = x-y;

        return result;
    }
    else{
        ltCnt++;

        result = y-x;

        return result;
    }
}
