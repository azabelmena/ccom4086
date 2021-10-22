a# Control

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
