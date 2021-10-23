# Control

In `C`, constructs such as `if else` statements,and loops need conditional code
execution; the sequence of instructions performed depends on the outcome of
tests applied to the data. In machine code, two low level mechanisms are used to
implement conditional control structures. After testing the data values, one
mechanism changes the **control flow**, or the sequence of instructions, of the
program, and the other mechanism changes the **data flow**, or how data is
stored, based on the test results.

The first that should be examine is data flow control. Data dependent control
flow is the more general method of executing conditional structures. Since
instructions in `C` and machine code are executed sequentially, we implement
a conditional branch by using a jump instruction, that tells the machine to
execute an instruction that the jump points to. This essentially tells the
machine to pass onto some other part of the program, usually based on the result
of a test condition. Hence the compiler builds upon this low level mechanism to
implement the control structures of `C`.

### Condition Codes.

One of the way that the compile implements conditional operations is by the use
of **condition codes**, that is a set of codes that indicate the most recent
arithmetic or logical operation. These codes are maintained by a set of single
bit registers in the CPU.

These condition codes are then tested to perform conditional branching. The
following is a list of the most utilized condition codes: The following is
a list of the most utilized condition codes:

- `CF`
    - The **carry flag** indicates the most recent operation that generated
      a carry out of the most significant bit. Used to detect overflow in
      unsigned operations.
- `ZF`
    - The **zero flag** indicates the most recent operation that returned `0`.
- `SF`
    - The **sign flag** indicates the most recent operation that yielded
      a negative result.
- `OF`
    - The **overflow flag** indicate the most recent operation that yielded an
      two's complement overflow.

Some instructions do not alter condition codes, such as `lea`, since they are to
be used in address computations. All other operations however, will set the
condition codes of the program. Logical operations will set the carry and the
overflow flags to `0`, and shift operations will set the carry and overflow
flags to the last bit shifted out, and to `0`, respectively. The `inc` and `dec`
instructions set the overflow and zero flags, and leave the carry flag
unchanged.

More notably, there are a set of instructions used specifically to set condition
codes, and do not alter any registers. These are the `cmp` and `test`
instruction classes. They behave in the same way as the `sub` instruction,
except they set the condition code without updating the registers. Below is
a table describing the `cmp` and `test` instruction classes.

|Instruction            |           Base            |               Description|
|:---                   |           :---:           |                      ---:|
|`cmp  r, t`            |           `t-r`           |               Compare    |
|                       |                           |                          |
|`cmpb`                 |                           |         Compare Byte.    |
|`cmpw`                 |                           |         Compare Word.    |
|`cmpl`                 |                           |   Compare Double Word.   |
|`cmpq`                 |                           |   Compare Quad Word.     |
|                       |                           |                          |
|`test r, t`            |           `r & t`         |               Test       |
|                       |                           |                          |
|`testb`                |                           |         Test Byte.       |
|`testw`                |                           |         Test Word.       |
|`testl`                |                           |   Test Double Word.      |
|`testq`                |                           |   Test Quad Word.        |

### Accessing Condition Codes.

There are three common ways to use condition codes, and they are rarely read
directly:

1. Set a byte to `0` or `1` based on a combination of condition codes. 
2. Conditionally jump to another part of the program.
3. Conditionally transfer data.

In the first case, we make use of the `set` instruction class, which set the
desired byte. The instructions in the `set` class differ by how they set the
byte, and their suffixes, instead of denoting operand type, denote their
function.

|Instruction    |   Synonym     |  Effect           |                  Condition|
|:---           |   :---:       |  :---:            |                       ---:|
|`sete D`       |   `setz`      |  `D <- ZF`        |     Equal/Zero            |
|`setne D`      |   `setnz`     |  `D <- ~ZF`       |     Not Equal/Not Zero    |
|`sets D`       |               |  `D <- SF`        |     Negative              |
|`setns D`      |               |  `D <- ~SF`       |     Nonnegative           |
|`setg D`       |   `setnle`    |`D <- ~(SF^OF)&~ZF`|     Greater Than          |
|`setge D`      |   `setnl`     |`D <- ~(SF^OF)`    |     Greater Than or Equal |
|`setl D`       |   `setnge`    |`D <- SF^OF`       |     Less Than             |
|`setle D`      |   `setng`     |`D <- (SF^OF)&#124;ZF`|  Less Than or Equal    |
|`seta D`       |   `setnbe`    |`D <- ~CF & ~ZF`   |     Above                 |
|`setae D`      |   `setnb`     |`D <- ~CF`         |     Above Than or Equal   |
|`setb D`       |   `setnae`    |`D <- CF`          |     Below                 |
|`setle D`      |   `setng`     |`D <- CF &#124; ZF |     Below Than or Equal   |

We can notice that some of the `set` instructions have synonyms, that is some
`set` instructions are equivalent to others. It is important to note that the
compiler may use equivalent instructions interchangeably, and so it helps to
know all of them.

In the following assembly code, we note that we compare two quad words `a` and
`b`, stored in `rdi` and `rsi` respectively, and set the condition on whether
one of them is less than the other.

```c
// int comp(long a, long b);
comp:
    cmpq        %rsi,   %rdi    // compare a and b.
    setl        %al             // St the low order byte of eax to 0 or 1.
    movzbl      %al,    %eax    // Clear eax.
    ret                         // Return.
```

Like the arithmetic and logical operations, `set` sets the condition codes.
Unlike arithmetic and logical operations, the `set` instructions execute
specifically where a comparison is taking place. It sets the condition codes
accordingly to the computation `a-b`. It is also worth while to notice that all
the `set` instructions utilize the `ZF`, `SF`, `CF`  and `OF` flags in some
combination.

### Jump Instructions.

The third class of instructions to consider for control flow are the `jmp`
instructions. These are the instructions that point to some other instruction in
memeory, and hence can cause the execution of a program to jump to a completely
new location in memory. These positions are indicate by labels such as `.L1`
which tells the `jmp` instruction where to point to.

|Instruction    |   Synonym     |       Condition       |           Description|
|:---           |   :---:       |       :---:           |                  ---:|
|`jmp Label`    |               |       `1`             |  Direct Jump         |
|`jmp *Operand` |               |       `1`             |  Indirect Jump       |
|`je Label`     |   `jz`        |       `ZF`            |  Equal/Zero          |
|`jne Label`    |   `jnz`       |       `~ZF`           |  Not Equal/Not Zero  |
|`js Label`     |               |       `SF`            |  Negative            |
|`jns Label`    |               |       `~SF`           |  Nonnegative         |
|`jg Label`     |   `jnle`      |`~(SF ^ OF) & ~ZF`     |  Negative            |
|`jge Label`    |   `jnl`       |`~(SF ^ OF)`           |  Nonnegative         |
|`jl Label`     |   `jnge`      |`SF ^ OF`              |  Negative            |
|`jle Label`    |   `jng`       |`(SF ^ OF) &#124; ZF`  |  Nonnegative         |
|`ja Label`     |   `jnbe`      |`~CF & ~ZF`            |  Above               |
|`jae Label`    |   `jnb`       |`~CF`                  |  Above or Equal      |
|`jb Label`     |   `jnae`      |`CF`                   |  Below               |
|`jbe Label`    |   `jna`       |`CF &#124; ZF`         |  Below or Equal      |

In the assembly code:

```c
    movq        $0,         %rax    // Set rax to 0.
    jmp         .L1                 // Go to .L1.
    movq        (%rax),     %rdx    // Deference the null pointer.
.L1:
    popq        %rdx                // Pop rdx from the stack.
```

The dereferencing to the null pointer would cause a segmentation violation,
however it is not executed because the jump instruction above skips over it, and
pops `rdx` from the stack instead. We can alternatively call these labels **jump
targets**

There are two types of jumps. **direct jumps** which directly jump to an
instruction. In direct jumps, any instructions found below are never executed.
Direct jumps are encoded as part of the instruction. On the other hand,
**indirect jumps** are jumps which read from a register. The third kind of jump
instruction are the conditional jump instructions. These instructions come right
after a given test and only execute when the test conditions are satisfied. If
they don't execute, the control flow of the program proceeds as normal. The
`jmp` instruction class can be found in the above table.

#### Encodings for Jump Instructions.

In assembly, jump targets are written using symbolic labels. The assembler and
the linker then generate the proper encodings. The most common encoding form
`jmp` instructions are the **PC  relative** encodings. These encode the
difference between the address of the target instruction, and the address of
the instruction immediately after the jump. They are encoded in `1`, `2`, or `4`
bytes. Another encoding is **absolute encoding** where the jump target is
directly specified using `4` bytes. The encodings are chosen by the compiler and
the linker. One of the advantages of PC relative encoding is that the
instructions can be compactly encoded and the object code can be shifted to
different positions in memory without being altered.

### Conditional Branching and Control.

The general way to translate conditional structures and statements from `C` is
to use a combination of conditional and unconditional jumps. We illustrate this
by using the `goto` statement in `C`, which serves as an analog to `jmp`.
Consider the following code and its assembly translation:

```c 
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
```

In this code we test `x >= y`, if it returns true, `goto` jumps to the `True:`
label and executes everything underneath. On returning false, the `goto` is
skipped and the original control flow is preserved. We can see that it's not so
different from how the assembly code executes.

```c 
gotodiff:
.LFB0:
	.cfi_startproc
	cmpq    %rsi, %rdi              // Compare x and y.
	jge	.L4                         // If >=, go to True (.L4).
	addq	$1, ltCnt(%rip)         // Increment ltCnt 
	movq	%rsi, %rax              // Set y-x.
	subq	%rdi, %rax
	ret                             // Return.
.L4:
	addq	$1, geCnt(%rip)         // Increment geCnt by one.
	movq	%rdi, %rax              // Set x-y.
	subq	%rsi, %rax
	ret                             // Return.
    .cfi_endproc
```

The code implements taking the absolute value difference of two integers. here,
if `x` is greater than `y` , we jump to the `True:` condition, `.L4` in the
assembly code, and return `x-y` while incrementing `geCnt`. On the other hand,
if `y > x`, then we increment `ltCnt` and return `y-x`. Here we used `goto`,
however, similar results are similar when written with conventional `if`/`else`
statements. `goto` has the advantage of being low level and similar to the `jmp`
instruction, and hence can be used to under stand them more in depth; their down
side is that it can be difficult to read and debug.

### Implementing Conditional Branches.

The conventional way to implement conditional operations is through
**conditional transfer control**, where the program follows one execution path
when one condation holds, and another execution path otherwise. A simple as it
can be, it can also be inefficient on processors.

Alternatively, we can transfer data condtionally through **conditional data
control**, where both outcomes of a conditional branch are computed, and the one
that satisfies the test condition is selected. This startegy is effective only
in restricted cases, but can be impelemented by a **conditional move**
instruction. These instructions are better matched to the processor to improve
performance. Consider the following code:

```c
long absdiffcmov(long x, long y){
    long rval = y-x;
    long eval = x-y;

    if(x >= y){
        rval = eval;
    }

    return rval;
}
```

Here we store the values `x-y` and `y-x` which correspond to one of the possible
outcomes of testing `x < y`. Depending on which condition holds true 
(i.e. if `x >= y` or not) we overwrite `rval` with `eval` or not, and return 
`rval`. Using the optimization flag `Og` won't get us a view of the desired
insttruction, so we assemble with the `O1` flag and view below:

```c
// assembled with gcc -O1 -S absdiff.c
absdiffcmov:
.LFB3:
	.cfi_startproc
	movq	%rsi, %rdx
	subq	%rdi, %rdx
	movq	%rdi, %rax
	subq	%rsi, %rax
	cmpq	%rdi, %rsi
	cmovg	%rdx, %rax
	ret
	.cfi_endproc
```

Notice that before the return, the `cmovg` instruction is called. `cmovg`
transfers the data from the source to the destination only if `cmpq` above
returns true. Otherwise, the assembly code follows the same logic of the
original program.

Understanding why using conditional data control can be better in some cases
entails understanding the way modern processes operate. Porcessors achieve
performance through **pipelining**, where an instruction is processed in
a sequence of stages. Each stage performs a small portion of the operations,
such as fetching, or determining the instruction type. We can then achieve
higher perfomrance by overlapping the steps of successive instructions, instead
of doing each one seperately and sequentially. The requisite for this is that we
need to be able to predict the instructions to keep the pipeline full.

Modern processors deploy **branch prediciton logic** to be able to keep the
pieline full, and guesses whether or not a jump instruction will be followed. In
the best case, the pipeline is kept full, and in the worst case, the processor
needs to discard work that it has already done if it mispredicts a jump; which
can impact perfomrance on about `15-30` clock cycles.

#### Predicting Penalty.

Suppose the probability of a misprediction is $$p$$, and the the time to execute
the code without mispredictions is $$T_{OK}$$, and that the misprediction
penalty is $$T_{MP}$$. Then the average time to execute the code as a function
of $$p$$ is 

$$T_{avg}(p) = (1-p)T_{OK}+p(T_{OK}+T_{MP})=T_{OK}+pT_{MP}$$. 

Below is table of the `cmov` instruction class. The source and destination
values can be `16`, `32`, or `64` bits, and single byte conditional moves are
unsupported.

|Instruction    |   Synonym     |       Condition       |           Description|
|:---           |   :---:       |       :---:           |                  ---:|
|`cmove S, R`   |   `cmovz`     |       `ZF`            |Equal/Zero            |
|`cmovne S, R`  |   `cmovnz`    |       `~ZF`           |Not Equal/Not Zero    |
|`cmovs S, R`   |   `cmovz`     |       `SF`            |Negative              |
|`cmovns S, R`  |   `cmovnz`    |       `~SF`           |Nonnegative           |
|`cmovg S, R`   |   `cmovnle`   |`~(SF^OF) & ~ZF`       |Greater Than          |
|`cmovge S, R`  |   `cmovnl`    |`~(SF ^ OF)`           |Greater Than or Equal |
|`cmovl S, R`   |   `cmovnge`   |`SF ^ OF`              |Less Than             |
|`cmovle S, R`  |   `cmovng`    |`(SF ^ OF) &#124; ZF`  |Less Than or Equal    |
|`cmova S, R`   |   `cmovnbe`   |`~CF & ~ZF`            |Greater Than          |
|`cmovae S, R`  |   `cmovnb`    |`~CF`                  |Greater Than or Equal |
|`cmovb S, R`   |   `cmovnae`   |`CF`                   |Less Than             |
|`cmovbe S, R`  |   `cmovna`    |`CF &#124; ZF`         |Less Than or Equal    |

Unlike condtitional jumps, the processor can execute condtional move
instructions without predicting the outcome of a test, they just read the source
value, check the condition code, and then either updates the destination
register or keeps it the same.

However, not all conditional statements can be compiled with conditional moves.
The `else` and `then` statements cannot be compiled; if one of the were to
return an error, it would lead to undesirable behaviour on the part of the
processor. So code implemented like:

```c
return (xp ? *xp : 0);
```

should be avoided. In this particular example, we get a null pointer
dereferencing error.

It should also be noted that conditional moves only improve performance and
efficiancy under certain situations, and not in general, if a `then` or `else`
expression requires significant computation, conditional moves will be ill
advised, as if the relevant condition fails, the computation will be for naught.
Compilers must take into account the relative performance of wasted computation
versus the potential for performance penalty due to branch misprediction. In
reality, compilers do not have enough information to make a reliable decision.

### Loops.

In the foreground of most `C` programming are the loops: `for` loops, `while`
loops and `do-while` loops specifically. Unlike conditional moves or branching,
these loops have no corresponding machine instruction, the do not need it. Each
of the loops can be implemented in assembly using the previously mentioned
conditional instructions. In fact, combinations of conditional tests and jumps
are used. The `gcc` and other compilers generate loops based on the two basic
patters, `for` and `while`.

#### `do-while` Loops.

The general form of a `do-while` loop is:

```c
do{
    body-statement;
}while(test);
```

The `do-while` loop executes the body at least once, and then repeats the
execution as long as the test condtion is ture. We can translate this loop using
`goto` as:

```c
loop:
    body-statement;

    if(test){
        goto loop;
    }
```

On each iteration, the program evaluates the body, and then the test expression.
If the test succeeds, the program iterates again. In line with the `goto`
version of the loop, the assembly is turned into a combination of tests and
jumps.

#### `while` Loops.

The general form of a `while` loop in `C` is

```c
while(test){
    body-statement;
}
```

The only difference between the `while` and the `do-while` is that the `while`
loop will not necessarily execute the body. We can then translate this code
using `goto` in a similar manner:

```c
    goto test;
loop:
    body;
test:
    if(test){
        goto loop;
    }
```

Here the test is evaluated before the body is executed, hence the `while` loop
may not even execute the body.

There are a number of ways to translate `while` loops to machine code, two of
which are used by `gcc`. The first one, seen above, is the **jump to middle**
method, and perormfs the initial test by performing an uncondtional jump to the
test case at the end of the loop. The following method is the **gaurded do**,
seen below. it transforms the code into a `do-while` loop, by using conditional
branching to skip the loop if the initial test fails. `gcc` follows the guarded
do method if it is called with the `O1` flag; that wau the compiler can optimize
initial test.

```c
if(!test){
    goto done;
}

loop:
    body;

    if(t){
        goto loop;
    }
done:
```

#### `for` Loops.

The `for` loop in `C` has the form:

```c
for(init, test, update){
    body;
}
```

Where we first take an initial expression, test it, and update it. If the test
returns true, then the body is executed, and the loop iterates using the updated
expression as the new initial expression. This iteration continues until the
test returns false. This form is also equivalent to using a while loop:

```c 
init

while(test){
    body;

    update;
}
```

Here we can see the flow of the `for` loop more directly. Thus we can translate
it with `goto` using the jump to middle or gaurded do methods.

We see that all three loops can be translated using simple strategies and
generating code that uses conditional branching. Conditional transfer control
provides the basic mechanisms for translating loops into machine code.

### `switch` Statements.

A `switch` statement in `C` provides a multiway branching capability based on
the value of an integer index. In fact, they are useful for testing a large
number of possible outcomes. These statemens make the `C` code more readable,
but they also allow efficient implementation using a jump table data structure.
A **jump table** is an array based data structure where the $$i$$-th element  is
the address of a code segent impelementing execution of the program i case the
`switch` index equals $$i$$. The code then perfomes an array reference into the
jump table using the `switch` index to determine the target of a jump
instruction.

The advantage, opposed to long sequences of `if-else` statements, is that the
time taken to perform the `switch` is independent from the number of cases. The
`gcc` compiler selects the method of translating `swtich` depending on the
number of these cases, and the sparsity of the case values. Jump tables are
always used when there are a number of cases, and the span a small range of
values.

The following example of a `switch` statement along with its assembly
translation shows how the `gcc` compiler makes use of jump tables as an
extension. The entries defined by the array `jt` are defined by labels in
pointers to pointers (i.e. pointers to code locations), prefixed with `&&` (not
to be confuse with the logical and). The compiler first shifts the range to
between $$0$$ and $$6$$ by subtracting $$100$$ from `n`, and creating the new
program variable `index`. It then treates `index` as an unsigned int,
simplifying the branching possibilities. Thus it can test if `index` is outside
the $$0$$-$$6$$ range, by testing if it is greater than $$6$$. In the assembly,
there are five locations to jump to based on the index value; and one of them is
the `default` case. Eacho of these jump locations identifies a block of code
implementing one of the cases.

```c 
void switchEg(long x, long n, long *dest){

    long val = x;

    switch(n){
        case 100:
            val *= 13;
            break;

        case 102:
            val += 10;

        case 103:
            val += 11;
            break;

        case 104:

        case 106:
            val *= val;
            break;

        default:
            val = 0;
    }

    *dest = val;

    return;
}
```

```c
switchEg:
.LFB0:
	.cfi_startproc
	subq	$100, %rsi
	cmpq	$6, %rsi
	ja	.L8
	leaq	.L4(%rip), %rcx
	movslq	(%rcx,%rsi,4), %rax
	addq	%rcx, %rax
	jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L4:
	.long	.L7-.L4
	.long	.L8-.L4
	.long	.L6-.L4
	.long	.L5-.L4
	.long	.L3-.L4
	.long	.L8-.L4
	.long	.L3-.L4
	.text
.L7:
	leaq	(%rdi,%rdi,2), %rax
	leaq	(%rdi,%rax,4), %rdi
	jmp	.L2
.L6:
	addq	$10, %rdi
.L5:
	addq	$11, %rdi
.L2:
	movq	%rdi, (%rdx)
	ret
.L3:
	imulq	%rdi, %rdi
	jmp	.L2
.L8:
	movl	$0, %edi
	jmp	.L2
	.cfi_endproc
```

The idea behind `switch` statements is to access code locations through the jump
table. The `C` code declares the jump table as an array of $$7$$ elements. These
elements correspond to the values `100-106`. the jump table can handle duplicate
cases by just having the same code label. The jump table is indicated in the
assembly by `.L4`, and make declerations stating that within the segment of the
object code file called `.rodata` (read only), there is a sequence of `7` ling
words, whose values are an address in memory. These addresses are associated
with the code labels. This example is illustrative of how using jump tables
allow for very efficient ways to implement multiway branching.
