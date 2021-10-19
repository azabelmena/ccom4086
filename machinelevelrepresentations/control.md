## Control

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

```c
int greaterThan(long x, long y){
    return x > y;
}
```

```c
0x0000000000001139 <+0>:	cmp    %rsi,%rdi    // Compare x and y.
0x000000000000113c <+3>:	setg   %al          // Set when > is true.
0x000000000000113f <+6>:	movzbl %al,%eax     // Zero rest of rax.
0x0000000000001142 <+9>:	ret                 // Return.
```

```c 
long absdiff(long x, long y){
    long result;

    if(x>y){
        result = x-y;
    }
    else{
        result = y-x;
    }

    return result;
}
```

```c
// Compiled with gcc -Og -S -fno-if-conversion absdiff.c
absdiff:
.LFB0:
        .cfi_startproc
        cmpq    %rsi, %rdi      // x:y
        jle     .L2
        movq    %rdi, %rax
        subq    %rsi, %rax
        ret
.L2:                            // x <= y
        movq    %rsi, %rax
        subq    %rdi, %rax
        ret
        .cfi_endproc
```
