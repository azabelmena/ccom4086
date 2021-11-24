##Array Allocation

### Base principle

- `T A[L]`
- Array of data type `T` and length `L`
- Contiguously allocated region of `L*sizeof(T)` bytes in memory.
- The concept of an array does not exist in assembly language
    - look for patterns in the assembly to spot an array.

|Reference      |   Type    |   Value   |
|:---           |   :---:   |   ---:    |
|`val[4]`       |   `int`   |       `3` |
|`val`          |   `int*`  |   $x$     |
|`val+1`        |   `int *` |   $x+4$   |

```c
int get digi(zip_dig z, int digit){
    return z[digit];
}
```

```c
movl    (%rdi, %rsi, 4), %eax
```

- The register `rdi` contains the starting address.
- The register `rsi` contains the index.
- We get the desired digit at `%rdi+%rsi*4`.
    - Use the memory reference: `(%rdi, %rsi, 4)`
    - If the destination register is preappended by the `32` bit `e`, i.e
      `eax`, `ebx`,  then it is likely we arre storing an `int`.
- Endianness does not matter (for `int`).

```c
void zincr(zip_dig z){
    size_t i
    for(i = 0; i < ZLEN; i++){
        z[i]++;
    }
}
```
```c
    movl    $0, %eax                // i = 0.
    jmp     .L3                     // goto middle.

.L4                                 // loop:
    addl    $1, (%rdi, %rax,4)      // z[i]++
    addq    $1, %rax                // i++

.L3                                 // middle
    cmpq    $4, %rax                // i:4
    jbe     .L4                     // if <=, goto loop.
    rep
    ret
```


## Multidimensional arrays.
###Declration
- `T A[R][C]`
- $2$d array of data type `T`.
- `R` rows, `C` columns.
- Type `T` elements requires $K$ bytes.

### Array Size
- `R*C`.

### Nested Row Access Code
```c
    leaq    (%rdi, %rdi, 4),    %rax        // index*5
    addl    %rax,               %rsi        // index*5+dig
    movl    phg(,%rsi,4),       %eax        // M[phg+(index*5+dig)*4]
```

- `pgh[index][dig]` is `int`
- Address: `phg+20*index+index*4`
    - $=$ `phg+(index*5+dig)*4`

### Structure Representation.

Take the structure.

```c
struct rec{
    int a[4];
    size_t i;
    struct rec *next;
};
```

- Structure represented as a block of meory.
    - big enough to hold all the fields.
- Fields ordered according to declaration.
    - Evin if another ordering could yield a more compact representation.
- The compiler determines the overall size, plus the positions of fields.
    - Machine level programs have no understanding of the structures in the
      source code.

#### A linked list Example.
```c
void set_val(struct rec *r, int val){
    while(r){
        int i = r -> i;
        r -> a[i] = val;
        r = r -> next;
    }
}
```
```c
.L11                                            // do-while loop.
    movslq      16(%rdi),   $rax                // i = M[r+16]
    movl        %esi,       (%rdi, %rax, 4)     // M[r+i*4] = val
    movq        24(%rdi),   %rdi                // r = M[r+24]
    testq       %rdi,       %rdi                // test r.
    jne         .L11                            // if != 0, goto loop.
```
