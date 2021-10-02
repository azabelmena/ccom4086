# The GNU Debugger \(gdb\).

A **debugger** is a piece of software that is used to debug programs. To **debug**
is to find logical and semantic errors in one's code andremove them. We can go 
even a step further and degub the binary. To be clear, the word **program** and 
**binary** are analogous to eachother, hwoever when used coloquially, the word 
program also specifies the **source code**, which is what the programmer writes.
We then use program to mean either and leave the context to distinguish between 
the two uses.

The difference between debugging source code and debugging a program is that one
entails removing errors found in the source itself, and the other entails 
disassembling the program to find **runtime** errors and fix them, and to 
optimize and observe the code. For example, a debugger can be used to find 
out what is happening when a program encounters a **segmentation violation**,
which is an error that occurs when the program tries to access an illegal address
in memory. Another example is a hacker trying to overflow a buffer and insert 
shellcode; they then open a debugger to view the addresses that they need to 
execute the buffer overflow attack.

The principle debugger that is used, for this class, and in general in the field 
is the **GNU debugger**, more coloquially known as **`gdb`**. Below is typically 
what a `gdb` instance looks like when run through the terminal. Here we use `gdb`
on the `sum` program.

```bash
~/ccom4086/ > gcc -Og -g -o sum sum.c
~/ccom4086/ > gdb sum
GNU gdb (GDB) 11.1
Copyright (C) 2021 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "x86_64-pc-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<https://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from sum...
(gdb) list sumstore
1    #include<stdio.h>
2
3    long plus(long, long);
4
5    void sumstore(long x, long y, long *dest){
6
7       long t = plus(x,y);
8       *dest = t;
9
10       return;
(gdb) disassemble sumstore
Dump of assembler code for function sumstore:
   0x000000000000111e <+0>:    push   %rbx
   0x000000000000111f <+1>:    mov    %rdx,%rbx
   0x0000000000001122 <+4>:    call   0x1119 <plus>
   0x0000000000001127 <+9>:    mov    %rax,(%rbx)
   0x000000000000112a <+12>:    pop    %rbx
   0x000000000000112b <+13>:    ret
End of assembler dump.
(gdb) quit
A debugging session is active.

    Inferior 1 [process 41601] will be killed.

Quit anyway? (y or n) y
```

Here we compile `sum.c` with the debug flag `-g` which includes extra debugging 
information that we can use in `gdb`. It is not nessesary however. Notice that:

```text
~/ccom4086/ > gcc -Og -o sum sum.c
~/ccom4086/ > gdb -q sum
Reading symbols from sum...
(No debugging symbols found in sum)
(gdb) list
No symbol table is loaded.  Use the "file" command.
(gdb) disassemble sumstore
Dump of assembler code for function sumstore:
   0x000000000000111e <+0>:    push   %rbx
   0x000000000000111f <+1>:    mov    %rdx,%rbx
   0x0000000000001122 <+4>:    call   0x1119 <plus>
   0x0000000000001127 <+9>:    mov    %rax,(%rbx)
   0x000000000000112a <+12>:    pop    %rbx
   0x000000000000112b <+13>:    ret
End of assembler dump.
(gdb) quit
```

Notice how we can not get a view of the source code without the `-g` flag. Here 
the `-q` flag just suppresses the copyright information displayed upon running 
`gdb`. We will be running `gdb` with this flag to make examples consise.
