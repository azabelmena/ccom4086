#include<stdio.h>

#define N 16
typedef int fix_matrix[N][N];

int fix_prod(fix_matrix A, fix_matrix B, long i, long j){
    long k;
    int result = 0;

    for(k = 0; k < N; k++){
        result += A[i][j]*B[j][k];
    }

    return result;
}

int fix_prod_opt(fix_matrix A, fix_matrix B, long i, long j){
    int *Aptr = &A[i][0];
    int *Bptr = &B[0][j];
    int *Bend = &B[N][j];

    int result = 0;

    do{
        result += *Aptr * *Bptr;
        Aptr++;
        Bptr += N;
    }while(Bptr != Bend);

    return result;
}

int var_ele(long n, int A[n][n], long i, long j){
    return A[i][j];
}

int var_prod(long n, int A[n][n], int B[n][n], long i, long j){
    long k;
    int result = 0;

    for(k = 0; k < n ; k++){
        result += A[i][j]*B[j][k];
    }

    return result;
}

int var_prod_opt(long n, int A[n][n], int B[n][n], long i, long j){
    int *Arow = &A[i][0];
    int *Bptr = &B[0][j];
    long k;

    int result = 0;

    for(int k = 0; k < n; k++){
        result += Arow[j] * *Bptr;
        Bptr += n;
    }

    return result;
}
