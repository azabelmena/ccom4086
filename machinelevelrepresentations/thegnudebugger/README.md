# The GNU Debugger \(gdb\).

A **debugger** is a piece of software that is used to debug programs. To **debug** is to find logical and semantic errors in one's code andremove them. We can go even a step further and degub the binary. To be clear, the word **program** and **binary** are analogous to eachother, hwoever when used coloquially, the word program also specifies the **source code**, which is what the programmer writes. We then use program to mean either and leave the context to distinguish between the two uses.

The difference between debugging source code and debugging a program is that one entails removing errors found in the source itself, and the other entails disassembling the program to find **runtime** errors and fix them, and to optimize and observe the code. For example, a debugger can be used to find out what is happening when a program encounters a **segmentation violation**, which is an error that occurs when the program tries to access an illegal address in memory. Another example is a hacker trying to overflow a buffer and insert shellcode; they then open a debugger to view the addresses that they need to execute the buffer overflow attack.

The principle debugger that is used, for this class, and in general in the field is the **GNU debugger**, more coloquially known as **`gdb`**. Below is typically what a `gdb` instance looks like when run through the terminal. Here we use `gdb` on the `sum` program.

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

Here we compile `sum.c` with the debug flag `-g` which includes extra debugging information that we can use in `gdb`. It is not nessesary however. Notice that:

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

Notice how we can not get a view of the source code without the `-g` flag. What the `-g` flag does is preserve the identifiers and symbols of the program. This is what allows us to view the source of the program inside the debugger. Here the `-q` flag just suppresses the copyright information displayed upon running `gdb`. We will be running `gdb` with this flag to make examples consise.

What a typical debugger like `gdb` does is runs another program and allows you to pause executiion and continue it at any time, as well as set **break points** which are conditions to pause the execution, as to allow the programmer to view the state of the program. One can also view variable values and even step trhough a program.

Typically one runs `gdb` in the terminal by typing `gdb a.out`, where `a,out` is the program you wish to debug. If `a,out` takes command line arguments, then it can be run as `gdb a.out arg1 arg2 ...`, of course, one can also specify command line arguments within `gdb` itself. We list some typical commands that are most useful when using `gdb`.

* `run`
  * runs the program. Can also take command line arguments as: \`run arg1

    arg2...\`.

  * Can be abbreviated as `r` in the prompt.
* `list`
  * Lists the code.
  * Only effective if the progra was compiled with `gcc -g`.
* `break`
  * Sets a breakpoint at a specified address.
  * `break main` sets a breakpoint at the adddress of `main()` in the program.
  * Can be abrreviated as `b` in the prompt.
* `continue`
  * Continues program execution from the last break point.
  * Can also be run with arguments \(useful if attatching to an already running

    program\).

  * Can be abbreviated as `c` in the prompt.
* `print`
  * Print a variable's value, or address in memory.
  * Use: `print var` \(prints value\) `print &var` \(prints variable's address\).
  * Can print arrays with `print *arr@len`.
  * Can be abbreviated as `p` in the prompt.
* `next`
  * Steps through the source code instructions.
  * Goes to the next line in the immediate scope.
  * Can be abbreviated as `n` in the prompt.
* `step`
  * Steps inside of a function.
  * Useful for seeing what is going on inside of a function.
  * Can be abbreviated as `s`.

An additional cheatsheet will be provided.

We list the full `sum.c` program as:

```c
#include<stdio.h>

long plus(long, long);

void sumstore(long x, long y, long *dest){

    long t = plus(x,y);
    *dest = t;

    return;
}


int main(){

    long int x = 0;
    long int y = 0;
    long int *t = 0x0;

    sumstore(x, y, t);

    return 0;
}

long plus(long x, long y){
    return x+y;
}
```

Compiling with `gcc -Og -g -o sum sum.c` and running, we get:

```bash
~/ccom4086/ > gcc -Og -g -o sum sum.c
~/ccom4086/ > ./sum
zsh: segmentation fault (core dumped)  ./sum
~/ccom4086/ >
```

Which gives us a segmentation violation. Let us take a closer look with `gdb`.

```bash
~/ccom4086/ > gdb -q sum
Reading symbols from sum...
(gdb) list
6
7       long t = plus(x,y);
8       *dest = t;
9
10       return;
11    }
12
13
14    int main(int argc, char* argv[]){
15
(gdb) run
Starting program: /home/ccom4086/ccom4086/sum

Program received signal SIGSEGV, Segmentation fault.
sumstore (x=<optimized out>, y=<optimized out>, dest=0x0) at sum.c:8
8       *dest = t;
(gdb) quit
A debugging session is active.

    Inferior 1 [process 18857] will be killed.

Quit anyway? (y or n) y
```

Notice that running it the program recieves the `SIGSEGV`, and the program returns a segmentation violation. `SIGSEGV` is the signal for segmentation violations. What this tells us is that when running `sum`, the program tried to access a memory location that it was not allocated. A program has no read or write permisions for memory it has not been allocated, so `SIGSEGV` is sent to terminate the program in such an event to prevent data corruption. Let us step through the program to see what is happening.

Set a break point at `sumstore`, and disassemble the function.

```bash
(gdb) break sumstore
Breakpoint 1 at 0x111e: file sum.c, line 5.
(gdb) run
Starting program: /home/ccom4086/ccom4086/Examples/sum

Breakpoint 1, sumstore (x=0, y=0, dest=0x0) at sum.c:5
5    void sumstore(long x, long y, long *dest){
(gdb) disassemble sumstore
Dump of assembler code for function sumstore:
=> 0x000055555555511e <+0>:    push   %rbx
   0x000055555555511f <+1>:    mov    %rdx,%rbx
   0x0000555555555122 <+4>:    call   0x555555555119 <plus>
   0x0000555555555127 <+9>:    mov    %rax,(%rbx)
   0x000055555555512a <+12>:    pop    %rbx
   0x000055555555512b <+13>:    ret
End of assembler dump.
```

Now we see that `sumstore()` calls the function `plus()()`. Lets disasssemble `plus()` to see what is going on in that function:

```bash
(gdb) disassemble plus
Dump of assembler code for function plus:
   0x0000555555555119 <+0>:    lea    (%rdi,%rsi,1),%rax
   0x000055555555511d <+4>:    ret
End of assembler dump.
```

Here we see that `plus` just adds the value at `rdi`, and the value at `rsi` \(recall the calling convention for `64` bit\), and loads them is `rax` which will be the value that it returns, it then returns. Listing `plus` verifies this:

```bash
(gdb) list plus
21
22       return 0;
23    }
24
25    long plus(long x, long y){
26       return x+y;
27    }
```

Now let us step in to the `sumstore()` program.

```bash
Breakpoint 1, sumstore (x=0, y=0, dest=0x0) at sum.c:5
5    void sumstore(long x, long y, long *dest){
(gdb) next
7       long t = plus(x,y);
(gdb) print t
$1 = 
(gdb) step
plus (x=0, y=0) at sum.c:26
26       return x+y;
(gdb) next
sumstore (x=<optimized out>, y=<optimized out>, dest=0x0) at sum.c:8
8       *dest = t;
(gdb) print t
$2 = 0
(gdb) step

Program received signal SIGSEGV, Segmentation fault.
sumstore (x=<optimized out>, y=<optimized out>, dest=0x0) at sum.c:8
8       *dest = t;
```

Using `next`, we find the next instruction to be assigning `plus(x, y)` to `t`. When we `print` `t`, we get `$1 =`, nothin. That is because the value has been optimized out. Up until we actaully assign a value to `t`, `t` holds nothing. `step` shows us that `plus()` is called, and `x+y` is stored in `t`. `print` `t` again we get `$2 = 0`; that is $$x+y = 0$$. Once we `step` again, we reach the line `*dest = t`; this seems to be what is giving us our segmentation violation. Notice that `t` is holding the value `0`, so assigning `t` to `*dest` is actually assigning `0` to `*dest`. Now `*dest` is a pointer, so `*dest = 0` is actually declaring `*dest` to be the `null` address. What happens when we alter the code? Let us reinitilize `x` and `y` in `main()`.

```c
int main(){

    long int x = 5;
    long int y = 5;
    long int *t = 0x0;

    sumstore(x, y, t);

    return 0;
}
```

And run `gdb` as previously:

```bash
~/ccom4086/ > gcc -Og -g -o sum sum.c
~/ccom4086/ > gdb -q sum
Reading symbols from sum...
(gdb) break sumstore
Breakpoint 1 at 0x111e: file sum.c, line 5.
(gdb) run
Starting program: /home/ccom4086/ccom4086/sum

Breakpoint 1, sumstore (x=5, y=5, dest=0x0) at sum.c:5
5    void sumstore(long x, long y, long *dest){
(gdb) next
7       long t = plus(x,y);
(gdb) step
plus (x=5, y=5) at sum.c:26
26       return x+y;
(gdb) next
sumstore (x=<optimized out>, y=<optimized out>, dest=0x0) at sum.c:8
8       *dest = t;
(gdb) step

Program received signal SIGSEGV, Segmentation fault.
sumstore (x=<optimized out>, y=<optimized out>, dest=0x0) at sum.c:8
8       *dest = t;
(gdb) print t
$1 = 10
```

We still get a `SIGSEGV`, and `print t` gives that `t` is holding the value `10`. The problem also isn't alleviated when we reinitialize `*t = 0xa` in `main()`. This tells us that problem isn't with assigning the pointer, it is with how it is being accessed. Notice that when we assing `10` to `*dest`, what we are actually saying is that `*dest` _holds the memory address_ `10`. Then the program `sum` tries to access that address `10` for reading. However, there is no reason to believe that the address `10` has been allocated to `sum`, in fact, an object dump of `sum` \(`objdump -d sum`\) shows us that `sum` has been allocated the memory addresses `1000-11d4`. Nowhere are we allocated the address `10`. So what is happening is that we are trying to access memory we do not have permission to view. Why has this happened? Notice in main that we declare

```c
long int *t = 0x0
```

Which initializes the pointer to the `null` address. This in itself is fine, every program is allocated the address `0x0`. The problem is that when we store `x+y` in `t`, we overwrite the previous value, and since `t` is a pointer, it treats it's value as an address in memory. This is where we go wrong. Notice the following line in `main()`:

```c
sumstore(x, y, t);
```

Here `sumstore(long, long, long*)` takes a pointer as an argument. All is well and good until we try storing an illegal address into `*dest`, which here is `t` when it is called. In main `*t = 0x0`, and we are trying to deference the `null` pointer, which we can't do as `0x0` points nowhere in memory. But what it we initialized `t` to point to another value, say, `x`? That is let us declar in `main()`:

```c
long int *t = &x;
```

Now we compile and run the program:

```bash
~/ccom4086/ > gcc -Og -g -o sum sum.c
~/ccom4086/ > ./sum
~/ccom4086/ >
```

It seems the program terminated without any segmentation errors. Let's verify that.

```bash
~/ccom4086/ > gdb -q sum
Reading symbols from sum...
(gdb) break sumstore
Breakpoint 1 at 0x113e: file sum.c, line 5.
(gdb) run
Starting program: /home/eletrico/Desktop/primerSemestre2021-2022/ccom4086/ccom4086/Examples/sum 

Breakpoint 1, sumstore (x=4382, y=1, dest=0x7fffffffe320) at sum.c:5
5    void sumstore(long x, long y, long *dest){
(gdb) next
7       long t = plus(x,y);
(gdb) next
8       *dest = t;
(gdb) print t
$1 = 4383
(gdb) step
10       return;
(gdb) next
main (argc=<optimized out>, argv=<optimized out>) at sum.c:20
20       return 0;
(gdb) continue
Continuing.
[Inferior 1 (process 47220) exited normally]
(gdb)
```

We have successfully fixed the segmentation violating that `sum` was giving us.

This is only a taste of what `gdb` can do. As we saw, it is usefull for finding errors and allowing us to fix them. The real power of it is that it gave us _insight_ into what the program was doing. With `gdb` we were able to see what was causing the segmentation violation wich was a deferencing of the `null` pointer. Once we figured that out, we were able to patch the error and execute the program successfully.

Now the `sum` program wasn't a complicated one, so the error was relatively easy to find; moreover, we did it with just the commands outlined above; in practive with more realistic programs, we would have to make use of additional `gdb` commands not listed to be able to get the full picture. For example; in practive with more realistic programs, we would have to make use of additional `gdb` commands not listed to be able to get the full picture. For example:

```bash
 eletrico@garuda:../Examples main [!?] zsh> gdb -q sum
Reading symbols from sum...
(gdb) x sumstore
0x113e <sumstore>:    0xd3894853
(gdb) break sumstore
Breakpoint 1 at 0x113e: file sum.c, line 5.
(gdb) run
Starting program: /home/eletrico/Desktop/primerSemestre2021-2022/ccom4086/ccom4086/Examples/sum

Breakpoint 1, sumstore (x=4382, y=1, dest=0x7fffffffe320) at sum.c:5
5    void sumstore(long x, long y, long *dest){
(gdb) x sumstore
0x55555555513e <sumstore>:    0xd3894853
(gdb) x/i sumstore
=> 0x55555555513e <sumstore>:    push   %rbx
(gdb) x/16gx sumstore
0x55555555513e <sumstore>:    0xfffff2e8d3894853    0x8348c35b038948ff
0x55555555514e <main+2>:    0x2825048b486418ec    0x0824448948000000
0x55555555515e <main+18>:    0x111e2404c748c031    0x0001bee289480000
0x55555555516e <main+34>:    0xe80000111ebf0000    0x24448b48ffffffc4
0x55555555517e <main+50>:    0x002825042b486408    0x000000b80a750000
0x55555555518e <main+66>:    0x97e8c318c4834800    0x0000801f0ffffffe
0x55555555519e:    0x5741fa1e0ff30000    0x4100002c3b3d8d4c
0x5555555551ae <__libc_csu_init+14>:    0x89495541d6894956    0x4855fc89415441f5
```

makes use of the `x` command in `gdb`, which stands for **examine**. It allows us to examin memory addresses, particularly, what they hold. `x` also holds various subcommands, for example `x/i` tells `gdb` to examin the instructions at the specified address, and `x/16gx` tells us to examine the contents of the address, along with $$15$$ consecutive giant words, all displayed in hexadecimal. Again, this is just a glimpse into the `x` command. There exist other commands as well. A cheatsheet of the commands will be listed in the final subsection.

So we saw the functionality of `gdb`, and how it us used to gain granular control over the runtime of the program. Let us now see how it can be used to exploit a program.

