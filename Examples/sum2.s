    .pos    0x0                 # Begin program at address 0x0.
    irmovq  stack, %rsp         # Set up the stack pointer.
    call    main                # Execute the program.
    halt                        # Exit wit success.

# Array of 4 elements.
    .align  8
array:
    .quad   0x000d000d000d
    .quad   0x00c000c000c0
    .quad   0x0b000b000b00
    .quad   0xa000a000a000

main:
    irmovq  array,      %rdi
    irmovq  $4,         %rsi
    call    sum                 # sum(array, 4).
    ret

sum:
    irmovq  $8,         %r8     # Constant 8.
    irmovq  $1,         %r9     # Constant 1.
    xorq    %rax,       %rax    # sum = 0.
    andq    %rsi,       %rsi    # set condition code.
    jmp     test                # goto test.

loop:
    mrmovq  (%rdi),     %r10    # get *start
    addq    %r10,       %rax    # add *start to sum.
    addq    %r8,        %rdi    # increment start.
    subq    %r9,        %rsi    # decrement count.

test:
    jne     loop                # stop when 0.
    ret

    .pos    0x200               # Begin the stack at address 0x200.
stack:

