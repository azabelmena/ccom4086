caller:
    subq    $16,        %rsp    // set up the stack frame.

    movq    $534,       (%rsp)  // move arg1 into rsp.
    movq    $1057,      8(%rsp) // move arg2 into rsp+8.

    leaq    8(%rsp),    %rsi    // store &arg2 in rsi as the second argument.
    movq    %rsp,       %rdi    // store &arg1 in rdi as the first argument.

    call    swap_add            // call swap_add.
    movq    (%rsp),     %rdx    // store arg1 in rsp.
    subq    8(%rsp),    %rdx    // subtract rsp+2 (arg2) from rdx (arg1).
    imulq   %rdx,       %rax    // compute sum*diff.

    addq    $16,        %rsp    // restore the stack frame.
    ret                         // return.
