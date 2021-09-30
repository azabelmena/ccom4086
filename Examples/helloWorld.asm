; helloWorld.asm
; A helloWorld program in 64 bit assembly.

section .data
    msg:    db      "Hello , world!", 10

section .text
    global _start

_start:
    mov     rax,    1   ;  set up SYS_write().
    mov     rdi,    1   ; wrtie to stdout in write arg 1.
    mov     rsi,    msg ; write our sting in write arg 2. 
    mov     rdx,    14  ; write string length in write arg 3.
    syscall             ; call SYS_write().

    mov     rax,    60  ; setup SYS_exit().
    mov     rdi,    0   ; Exit status 0 for success.
    syscall             ; call SYS_exit()
