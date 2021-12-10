The `C` programming language uses a particularly simple implementation for
arrays which lends itself nicely to machine language translation. `C` also has
the additional property that it can generate pointers to array elements and
perform arithmetic on them; these are of course translated into machine code
addresses.

### Principles.

Let `T` be an arbitrary data type of size $$L$$ bytes, and let $N$ be an integer
constant. Then we can decalare an array in `C` in the following way:

```c
T A[N]
```

This decleration first allocates a block of memory $$LN$$ bytes large, and then
introduces an identifier `A` that serves as a pointer to starting location of
the array, `A[0]`. Denoting `A[0]` as $$x_A$$, any array element $$i$$ is
stored in the address $$x_A+iL$$ where $$0 leq i < N$$. If we declare the
following arrays:

```c
char        A[12];
char*       B[8];
int         C[6]
double*     D[5];
```

Then we can observe how their respective arrays are allocated in the table
Below. Recall the sizes of the data types `char`, `int`, and `double` as well
as their pointer counterparts.

|Array      |   Element Size    |Total Size     |Start Address  |   Element $$i$$|
|:---       |   :---:           |   :---:       |   :---:       |   ---:         |
|`A`        |   $$1$$           |   $$12$$      |   $$x_A$$    |   $$x_A+i$$   |
|`B`        |   $$8$$           |   $$64$$      |   $$x_B$$    |   $$x_A+8i$$  |
|`C`        |   $$4$$           |   $$24$$      |   $$x_C$$    |   $$x_A+4i$$  |
|`D`        |   $$8$$           |   $$40$$      |   $$x_D$$    |   $$x_A+8i$$  |

As we saw when working with buffer overflows, memory allocation in `x86_64`
instructions make array allocation easy. If `E` is an `int` array, and we wish to
access the element `E[i]` stored in `rdx`, if `i` is stored in `rcx`, then the
instruction `movl (%rdx, %rcx,4), %eax` perfors the computation $$x_E+4i$$. The
scaling factors for assembly cover for the primitive data types.

### Pointer Arithmetic.

In pointer arithmetic, the computed value is scaled according to the size of
the referrenced data type. If `p` is a pointer to data of data type `T` of $$L$$,
and if `p` has the value $$x_p$$, then `p+i` has the value $$x_p+iL$$. Now
the `&` and `*` unary operations allow for cration and the dereferrencing of
pointers. If `a` is some data pointed to by `p`, then `&a` gives the value of
`p` which gives the address in which `a` is stored in, and `*p` gives the value
`a` which is stored in the reference address. Thus `a` and `*&a` are equivalent
expressions. Likewise, the array subscripting is applied to pointers, so `A[i]`
is equivalent to `*(A+i)`.

|Expression |   type    |       Value       |                       Assembly|
|:---       |   :---:   |   :---:           |                           ---:|
|`E`        |   `int*`  |   $$x_E$$        |   `movl %rdx, %rax`           |
|`E[0]`     |   `int`   |   $$M[X_E]$$     |   `movl (%rdx), %rax`         |
|`E[i]`     |   `int`   |   $$M[X_E+4i]$$  |`movl (%rdx,%rcx,4), %rax`     |
|`&E[2]`    |   `int*`  |   $$x_E+8$$      |`leaq 8(%rdx), %rax`           |
|`E+i-1`    |   `int*`  |   $$x_E+4i-4$$   |`leaq -4(%rdx,%rcx,4, %rax`    |
|`*(E+i-1)` |   `int`   | $$M[x_E+4i-4]$$  |`movl -12(%rdx,%rcx,4, %eax`   |
|`&E[i]-E`  |   `long`  | $$i$$             |`movq %rcx, %rax`              |

If we take suppose that the starting address of `E` and the value `i` are
stored in the registers `rdx` and `rcx`, respectively, then we can generate the
above expressions for `E` found in the table, along with their corresponding
assembly instructions.

### Nested Arrays.

An array is simply a data srcuture that holds more than one element of the
same data type, it can even hold more arrays. So the general principles of
array allocation and refrencing hold for creating arrays of arrays. The array
will symply treat its array elements as another data type. For example, the
following declarations are equivalent:

```c
typedef int row3_t[3];
row3_t A[5];

int A[5][3];
```

In any case, the ammount of storage one allocates for an array of arrays
`A[N][M]` becomes $$4 \cdot N \cdot M$$. We can also view the array `A[N][M]`
as a two dimensional array with `N` rows and `M` columns, so we write `A[1][5]`
to reference the data value stored in row `1`, column `5`. In this convention,
we say that the elements of the array `A` are stored in **row major** order.
This is alos coincidently how matrices are declared in programming.

To access elements of multidimensional arrats, the compiler generates code to
calculate the offset of the desired element, and then uses the `mov`
instruction class with the start of the array as the base address, and the
(possibly scaled) offest as an index. In general, if `T` is an arbitrary
data type, and we declare the array:

```c
T A[N][M];
```

Then the element `A[i][j]` is stored at the memory address:

$$\&A[i][j] = x_A+L \cdot (M \cdot i+j)$$

Where $$L$$ is the size of the data type `T`. Define `int A[5][3]` to be a $$5
\times 3$$ `int` array, and suppose that $$x_A$$, $$i$$, and $$j$$ are stored
in the registers `rdi`, `rsi`, and `rdx` respectively. Then we can copy the
array element `A[i][j]` to `eax` with:

```c
    leaq    (%rsi,%rsi,2),  %rax    // Compute 3i.
    leaq    (%rdi,%rax,4),  %rax    // compute x_A+12i.
    leaq    (%rax,%rdx,4),  %eax    // Read M[x_A+12i+4].
```

which computes the elemets address as $$x_A+12i+4=x_A+4(3i+j)$$.

### Fixed Array Sizes.

The `C` compiler can make optimizations for code operating with
multidimensional arrays of fixed size. If one sets the `-O1` flag when
compiling, the `gcc` compiler will fix array sizes. Suppose we take to
following code:

```c
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
```

Which computes the product of the $$ij$$-th element of the product of the
arrays `A` and `B`. `gcc` generates the code that we can then rewrite into a
more optimixed version of the above function:

```c
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
```

The optimized code has the advantage of removing ovehead. First it removes the
index `k`, and then uses the dereferencing of pointers to make array
references. We generate `Aptr` and `Bptr`, which point to the successive
elements in row $$i$$ of `A`, and successive elements in column $j$$ of `B`.
The final step is declaring `Bend` to point to the end of `B` so that the
`do-while` loop can terminate. The optimized code bears a resemblance to the
assembly code compiled with the `-O1` flag.

```c
fix_prod:
	salq    $6,             %rdx
	addq	%rdx,           %rdi
	movl	(%rdi,%rcx,4),  %edi
	salq	$6,             %rcx
	addq	%rcx,           %rsi
	leaq	64(%rsi),       %rcx
	movl	$0,             %eax
.L2:
	movl	%edi,           %edx
	imull	(%rsi),         %edx
	addl	%edx,           %eax
	addq	$4,             %rsi
	cmpq	%rcx,           %rsi
	jne	    .L2
	ret
```

### Variable Sized Arrayes.

Hostorically, `C` only supported multidimensional arrays where the sizes (with
the possible of the firs dimension) are determined at compile time. If one
required variable size arrays, they had to allocate storage for these arrays
through the use of the `malloc` and `calloc` finctions. One also had to
explicitly encode the mapping of multidimensional arrays into single
dimensional arrays with row-major indexing. The ISO `C99` standard introduced
the capability of having array dimension expressions that are computed as the
array is allocated. We can declare the array `int A[expr1][expr2]` either as a
local variable or as an argument to a function, and then dimensions are
calculated by computing `expr1` and `expr2` once the decleration is
encountered. For example, the function for accessing an array element can be
written as follws with its correspoding disassembly:

```c
int var_ele(long n, int A[n][n], long i, long j){
    return A[i][j];
}
--------------------------------------------------------------------------------
var_ele:
	imulq   %rdi,               %rdx    // compute ni.
	leaq    (%rsi,%rdx,4),      %rax    // compute x_A+4(ni).
	movl    (%rax,%rcx,4),      %eax    // read M[x_A+4(ni)+4j].
	ret
```

The parameter `n` is declared before the array so that the array dimensions can
be calculared. Notice that the address computation is similar to that of fixed
size allocation. The only exceptions are that the registe usage changes due to
the added parameter `n`, and the `imul` instruction is used to calculate `ni`
instead of using `lea`. This use of the `imul` instruction can incur performance
penalty. Other than that, the referencing of variable size arrays requires a
generalization of fixed size arrays.

Now, when variable size arrays are referenced within a loop, the compiler can
optimize the index computations by exploiting the regularity of the access
patterns. Consider the following code:

```c
int var_prod(long n, int A[n][n], int B[n][n], long i, long j){
    long k;
    int result = 0;

    for(k = 0; i < n ; k++){
        result += A[i][j]*B[j][k];
    }
}
```

We can optimize this into:

```c
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
```

The `gcc` compiled assembly differes from the optimized code for the fixed size
array, which happnes to be an artefact of the choices made by the compiler.
First, the code retains the loop variable to detect when the loop terminates,
and an index into an array consisting of the elements of row $$i$$ of array
`A`. Compiling it with the `-O1` flag, the assembly code lookes like:

```c
var_prod:
	testq   %rdi,           %rdi
	jle     .L11
	imulq	%rdi,           %rcx
	leaq	0(,%r8,4),      %rax
	leaq	(%rax,%rcx,4),  %rax
	movl	(%rsi,%rax),    %r9d
	imulq	%rdi, %r8
	leaq	(%rdx,%r8,4),   %rsi
	movl	$0,             %eax
	movl	$0,             %edx
.L10:
	movl	%r9d,           %ecx
	imull	(%rsi,%rax,4),  %ecx
	addl	%ecx,           %edx
	addq	$1,             %rax
	cmpq	%rax,           %rdi
	jne	    .L10
.L8:
	movl	%edx,           %eax
	ret
.L11:
	movl	$0,             %edx
	jmp	    .L8
```

So with optimizations on, `gcc` can recognize patterns that arise when programs
step through elements of a multi dimensional array, and can generate code that
avoids any multiplication that may result. Whether or not it generates pointer
or array based code, the performance is improved with these optimizations.
