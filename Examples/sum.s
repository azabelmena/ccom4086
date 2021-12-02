sum:
    irmovq  $8,         %r8     // Constant 8.
    irmovq  $1,         %r9     // Constant 1.
    xorq    %rax,       %rax    // sum = 0.
    andq    %rsi,       %rsi    // set condition code.
    jmp     test                // goto test.

loop:
    mrmovq  (%rdi),     %r10    // get *start
    addq    %r10,       %rax    // add *start to sum.
    addq    %r8,        %rdi    // increment start.
    subq    %r9,        %rsi    // decrement count.

test:
    jne     loop                // stop when 0.
    ret
