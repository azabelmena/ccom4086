## Control

In `C`, consturcts such as `if else` statements,and loops need conditional code
execution; the sequence of instructions performed depends on the outcome of
tests applied to the data. In machine code, two low level mechanisms are used to
implement conditional control structures. After testing the data values, one
mechanism changes the **control flow**, or the sequence of instructions, of the
program, and the other mechanism changes the **data flow**, or how data is
stored, based on the test results.

The first that should be examiine is data flow control. Data dependent control
flow is the more general method of executing conditional structures. Since
instructions in `C` and machine code are executed sequentially, we implement
a conditional branch by using a jump instruction, that tells the machine to
execute an instruction that the jump points to. This essentially tells the
machine to pass onto some other part of the program, usually based on the result
of a test condition. Hence the compiler builds upon this low level mechanism to
impelemt the control structures of `C`.

### Condition Codes.

One of the way that the compile implements conditioanl operations is by the use
of **condition codes**, that is a set of codes that indicate the most recent
arithmetic or logical operation. These codes are maitained by a set of single
bit registers in the CPU.

These condition codes are then tested to perform coditional branching. THe
following is a list of the most utilized condtion codes: THe following is a list
of the most utilized condtion codes:

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
    - The **overflow flag** indcates the most recent operation that yielded an
      two's complement overflow.

Some instructions do not alter condition codes, such as `lea`, since they are to
be used in address computations. ALl other operations however, will set the
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

<!--```c-->
<!--int greaterThan(long x, long y){-->
    <!--return x > y;-->
<!--}-->
<!--```-->

<!--```c-->
<!--0x0000000000001139 <+0>:	cmp    %rsi,%rdi    // Compare x and y.-->
<!--0x000000000000113c <+3>:	setg   %al          // Set when > is true.-->
<!--0x000000000000113f <+6>:	movzbl %al,%eax     // Zero rest of rax.-->
<!--0x0000000000001142 <+9>:	ret                 // Return.-->
<!--```-->

<!--```c -->
<!--long absdiff(long x, long y){-->
    <!--long result;-->

    <!--if(x>y){-->
        <!--result = x-y;-->
    <!--}-->
    <!--else{-->
        <!--result = y-x;-->
    <!--}-->

    <!--return result;-->
<!--}-->
<!--```-->

<!--```c-->
<!--// Compiled with gcc -Og -S -fno-if-conversion absdiff.c-->
<!--absdiff:-->
<!--.LFB0:-->
        <!--.cfi_startproc-->
        <!--cmpq    %rsi, %rdi      // x:y-->
        <!--jle     .L2-->
        <!--movq    %rdi, %rax-->
        <!--subq    %rsi, %rax-->
        <!--ret-->
<!--.L2:                            // x <= y-->
        <!--movq    %rsi, %rax-->
        <!--subq    %rdi, %rax-->
        <!--ret-->
        <!--.cfi_endproc-->
<!--```-->
