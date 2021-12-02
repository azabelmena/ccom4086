; helloWorld32.asm
; A helloWorld program written in 32 bit assembly.

section .data
    msg:    db      "Hello, world!", 0xa

section .text
    global _start

_start:
    mov     eax,    0x4     ; Set up SYS_write().
    mov     ebx,    0x1     ; Write to stdout in write arg 1.
    mov     ecx,    msg     ; Put the string in write arg 2.
    mov     edx,    0x14    ; Put string length in write arg 3.
    int     0x80            ; call SYS_write().

    mov     eax,    0x1     ; Set up SYS_exit().
    mov     ebx,    0x0     ; Exit code 0, success.
    int     0x80            ; Cal SYS_exit().
