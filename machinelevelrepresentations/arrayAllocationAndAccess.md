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
the array, `A[0]`. Denoting `A[0]` as $$x\_A$$, any array element $$i$$ is
stored in the address $$x\_A+iL$$ where $$0 \leq i < N$$. If we declare the
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
|`A`        |   $$1$$           |   $$12$$      |   $$x\_A$$    |   $$x\_A+i$$   |
|`B`        |   $$8$$           |   $$64$$      |   $$x\_B$$    |   $$x\_A+8i$$  |
|`C`        |   $$4$$           |   $$24$$      |   $$x\_C$$    |   $$x\_A+4i$$  |
|`D`        |   $$8$$           |   $$40$$      |   $$x\_D$$    |   $$x\_A+8i$$  |

As we saw when working with buffer overflows, memory allocation in `x86_64`
instructions make array allocation easy. If `E` is an `int` array, and we wish to
access the element `E[i]` stored in `rdx`, if `i` is stored in `rcx`, then the
instruction `movl (%rdx, %rcx,4), %eax` perfors the computation $$x\E+4i$$. The
scaling factors for assembly cover for the primitive data types.

### Pointer Arithmetic.

In pointer arithmetic, the computed value is scaled according to the size of
the referrenced data type. If `p` is a pointer to data of data type `T` of $$L$$,
and if `p` has the value $$x\_p$$, then `p+i` has the value $$x\_p+iL$$. Now
the `&` and `*` unary operations allow for cration and the dereferrencing of
pointers. If `a` is some data pointed to by `p`, then `&a` gives the value of
`p` which gives the address in which `a` is stored in, and `*p` gives the value
`a` which is stored in the reference address. Thus `a` and `*&a` are equivalent
expressions. Likewise, the array subscripting is applied to pointers, so `A[i]`
is equivalent to `*(A+i)`.

|Expression |   type    |       Value       |                       Assembly|
|:---       |   :---:   |   :---:           |                           ---:|
|`E`        |   `int*`  |   $$x\_E$$        |   `movl %rdx, %rax`           |
|`E[0]`     |   `int`   |   $$M[X\_E]$$     |   `movl (%rdx), %rax`         |
|`E[i]`     |   `int`   |   $$M[X\_E+4i]$$  |`movl (%rdx,%rcx,4), %rax`     |
|`&E[2]`    |   `int*`  |   $$x\_E+8$$      |`leaq 8(%rdx), %rax`           |
|`E+i-1`    |   `int*`  |   $$x\_E+4i-4$$   |`leaq -4(%rdx,%rcx,4, %rax`    |
|`*(E+i-1)` |   `int`   | $$M[x\_E+4i-4]$$  |`movl -12(%rdx,%rcx,4, %eax`   |
|`&E[i]-E`  |   `long`  | $$i$$             |`movq %rcx, %rax`              |

If we take suppose that the starting address of `E` and the value `i` are
stored in the registers `rdx` and `rcx`, respectively, then we can generate the
above expressions for `E` found in the table, along with their corresponding
assembly instructions.

### Nested Arrays.
