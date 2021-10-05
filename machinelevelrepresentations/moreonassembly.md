# More on Assembly.

We would like to go more in depth on assembly language, as it will be essential
to understanding computer architecture and how programs are executed in
a particular architecture. As we have mentioned before, different architectures
produce different assembly for the same source code. Assembly of one program
compiled on an `x86` machine will have assembly different to that of the same
program compiled on an `ARM` processor. Actually, assembly produced under
different flavors of `x86` will also be different. We focus on the `x86`
architecture and the assembly for it.

## Registers.

We went over one type of register previously, and that is the `rip`/`eip`
register. We call it the **instruction pointer** because it points to the next
instruction in memory. This is what the program counter uses to keep track of
instructions. In `x86_64` machines, the instruction pointer is denoted by `rip`,
in assembly where as for `x86_32` machines, it is denoted as `eip` in assembly.
Modern computers now usually use `64` bit addressing, so we will refer to this
register as `rip`. `rip` is very important in assembly because it will tell the
machine which instruction to execute next. When we call a register a **pointer**
that means the register stores a memory address, in the case of the instruction
pointer, it contains the address of the next instruction in memory. There are
other pointers such as the stack pointer which contains an address at the top of
a stack \(more on these registers below\).

Typically, when a pointer contains an address, we say that the pointer
**points** to the address. It is no surprise that there is a `1-1`
correspondence between pointers in assembly and pointers in `C/C++`.

The instruction pointer isn't the only register that assembly uses. `x86`
typically has several registers, and they act as internal variables for the
processor \(we make the distinction now, in order to avoid it later; registers
in `x86_64` are preappended by an `r`, such as that in `rip`, while `x86_32` are
preappended by an `e`, like in `eip`. Since we will be considering largely
`x86_64` we will for the most part consider registers preappened by `r`\).
Consider the following `helloWorld.c` program:

```c
#include<stdio.h>

int main(){

    printf("Hello, world!\n");

    return 0;
}
```

compile it with `gcc -g -o hello helloWorld.c` and consider the following list
of registers extracted from the `hello` binary with the `gdb` debugger \(which
will be discussed next section\):

```c
rax            0x555555555139      93824992235833
rbx            0x555555555160      93824992235872
rcx            0x7ffff7f88598      140737353647512
rdx            0x7fffffffe3e8      140737488348136
rsi            0x7fffffffe3d8      140737488348120
rdi            0x1                 1
rbp            0x7fffffffe2e0      0x7fffffffe2e0
rsp            0x7fffffffe2e0      0x7fffffffe2e0
r8             0x0                 0
r9             0x7ffff7fdcfd0      140737353994192
r10            0x7ffff7dd7798      140737351874456
r11            0x206               518
r12            0x555555555040      93824992235584
r13            0x0                 0
r14            0x0                 0
r15            0x0                 0
rip            0x55555555513d      0x55555555513d <main+4>
eflags         0x246               [ PF ZF IF ]
cs             0x33                51
ss             0x2b                43
ds             0x0                 0
es             0x0                 0
fs             0x0                 0
gs             0x0                 0
```

The first `4` registers are the **general purpose registers**. They are called
\(in order of appearance\) the **accumulator**, **base**, **counter**, and
**data** registers, and are denoted as `rax`, `rbx`, `rcx`, and `rdx`
respectively. These registers are the main registers that will be used as
temporary variables for the CPU, they can also be used for other purposes. The
second `4` registers are the **source index**, **destination index**, **base
pointer**, and **stack pointer**registers and are `rsi`, `rdi`, `rbp`, and `rsp`
respectively. These are also general purpose registers and are used for indexing
data and pointing to addresses in memory. For example `rbp` and `rsp` are used
for setting up a stack. So these registers are important for memory management
within the program. There are load and store instructions that use these
registers, but they can mainly be used as general purpose registers. The
remaining registers `r9-r15` can also be considered general purpose, though they
are not as important as the first `8` registers. Next comes the instruction
pointer `rip`. Next we have the `eflag` registers, which just serve to make
comparisons and to keep track of segmented memory. These can be ignored as they
rarely need to be accessed directly.

`x86_64` also has the ability to reference lower order registers such as `ebx`
and so one. We give a table below:

| `64` bit | `32` bit | `16` bit | `15`-`8` bits | `7`-`0` bits |
| :--- | :---: | :---: | :---: | ---: |
| %rax | %eax | %ax | %ah | %al |
| %rbx | %ebx | %bx | %bh | %bl |
| %rcx | %ecx | %cx | %ch | %cl |
| %rdx | %edx | %dx | %dh | %dl |
| %rsi | %esi | %si |  |  |
| %rdi | %edi | %di |  |  |
| %rsp | %esp | %sp |  |  |
| %rbp | %ebp | %bp |  |  |

We clarify that the registers in the `15`-`8`, and `7-0` ranges are encompassed
by the `16` bit registers, hence there are some blank spaces, when it concerns
the index and pointer registers. We call these registers the **high** and
**low** registers respectively.

## Assembly Syntax.

Assembly syntax varies, however there are two syntaxes that we will consider.
The first is the `AT&T` syntax and the second is the `intel` syntax. Both have
their differences. Typically, `intel` syntax looks like:

```text
intel
------------------------------------
operation   <destination>   <source>
------------------------------------
```

whereas `AT&T` syntax looks like:

```text
AT&T
------------------------------------
operation   %<source>       %<desitination>
------------------------------------
```

Here the % in `AT&T` assembly syntax is used to denote registers. It is also
the syntax that is used by most compilers, hence we will consider it more than
the `intel` syntax. The following is a disassembly of the `main()` procedure in
the `helloWorld.c` program above:

```c
Dump of assembler code for function main:
   0x0000000000001139 <+0>:    push   %rbp
   0x000000000000113a <+1>:    mov    %rsp,%rbp
   0x000000000000113d <+4>:    lea    0xec0(%rip),%rax        # 0x2004
   0x0000000000001144 <+11>:    mov    %rax,%rdi
   0x0000000000001147 <+14>:    call   0x1030 <puts@plt>
   0x000000000000114c <+19>:    mov    $0x0,%eax
   0x0000000000001151 <+24>:    pop    %rbp
   0x0000000000001152 <+25>:    ret
```

Operations in assembly can be **unary**, taking one argument, such as the above
instruction `push %rbp`, or they could be **binary** taking two arguments, such
as `mov %rsp, %rbp`; the can also take no arguments, such as a `ret`
instruction, which signifies a return. Operations in assembly are usually
intuitive mnemonics, for example `mov` moves the data from one register into the
other \(overwriting the previous data in the process\), and `push` pushes the
value of a register onto a stack. Operations beginning with a `j` usually denote
a **jump** from one instruction to another; for example `jle` stands for "jump
if less than or equal", and jumps to a location in memory if the current value
is less than or equal to the one it is being compared too. `jle` is usually
preceded by a `cmp` instruction which compares the relevant values.

What is important to keep kin mind is that the first few instructions form what
is called the **function prologue** \(or **procedure prologue**\) and are called
to set up the memory for what comes after. The last few instructions likewise
are called the **function epilogue** \(**procedure epilogue**\) and returns the
memory to the state it was before the function prologue was called. In the above
disassembly:

```c
Dump of assembler code for function main:
   0x0000000000001139 <+0>:    push   %rbp
   0x000000000000113a <+1>:    mov    %rsp,%rbp
   0x000000000000113d <+4>:    lea    0xec0(%rip),%rax        # 0x2004
```

sets up the memory to call the `main()` function while

```c
   0x0000000000001151 <+24>:    pop    %rbp
   0x0000000000001152 <+25>:    ret
```

returns the memory to how it was before the prologue was called. Notice how the
function epilogue effectively inverses the function prologue.

If we take an object dump of a typical binary, we get output like:

```bash
00000000000010c0 <__do_global_dtors_aux>:
    10c0:       f3 0f 1e fa             endbr64
    10c4:       80 3d 5d 2f 00 00 00    cmpb   $0x0,0x2f5d(%rip)        # 4028 <__TMC_END__>
    10cb:       75 33                   jne    1100 <__do_global_dtors_aux+0x40>
    10cd:       55                      push   %rbp
    10ce:       48 83 3d 22 2f 00 00    cmpq   $0x0,0x2f22(%rip)        # 3ff8 <__cxa_finalize@GLIBC_2.2.5>
```

Here we see that there are instructions with added suffixes. These are size
designations that indicate the size of the variables the operations are working
with. For example `cmpb` compares a byte, and `cmpq` compares a _quad_ (defined
in the next section). These are default in AT&T syntax, and are omitted in
Intel syntax. Typically, these suffixes can be ignored until you care about the
size of the operands. Below is a table for each suffix.

|`C` declaration     |   Data type          |     Assembly suffix     |   Size| 
|:---                |   :---:              |     :---:               |   ---:|
|`char`              |   Byte               |     `b`                 |    `1`|
|`short`             |   Word               |     `w`                 |    `2`|
|`int`               |   Double Word        |     `l`                 |    `4`|
|`long`              |   Quad Word          |     `q`                 |    `8`|
|`char*`             |   Quad Word          |     `q`                 |    `8`|
|`float`             |   Single Precision   |     `s`                 |    `4`|
|`double`            |   Double Precision   |     `l`                 |    `8`|

## Words, DWORDS, and QWORDS .

Integer data types, like in `C` are stored in `4` bytes in assembly. In this
instance, we say that the `int` data type is one "word" in memory. The basic
unit of data is a `byte`, and assembly organizes these data units in `4` byte
units called **words**. We call a **halfword** something that is `2` bytes in
size, hence the name, and data presented in `8` bytes is called a **giant**, so
`double`s in `C` are stored in giants in assembly code.

There are other conventions for words. Most notably `dwords` and `qword`. Like
the mnemonic suggests, a `dword` is a **double word**, that is, it is a unit of
two words. A `qword` is mnemonic for **quad word** and encompasses a unit of
four words. In some cases this terminology can be confusing. In some circles,
a `dword` is referred to as `4` bytes \(i.e. the same as a word.\), and a word
as `2` bytes \(i.e the same as a half word\); that is the terms `word` and
`dword` can be used interchangeably. If this is the case, then `qword` can also
be meant to be four `words` in length or two `words`. In this case it is usually
useful to know which context these terminologies are being used and what is
meant by a `word`. Just knowing the size of a `word` in context is enough to
know which conventions you are working with because `dword` and `qword` will
always stand for double and quad words, respectively.

## Operand Specifiers.

Since instructions can be unary, binary, or take nothing, we would like to
specify the forms of the operands, and how they can be read from memory.

|Type           | Form          |   Operand Value       |                  Name|
|:---           | :---:         |   :---:               |                  ---:|
|Immediate      | `$Imm`        |   `Imm`               |             Immediate|
|Register       | `r`           |   `R[r]`              |              Register|
|Memory         | `Imm`         |   `M[Imm]`            |              Absolute|
|Memory         | `(r)`         |   `M[R[r]]`           |              Indirect|
|Memory         | `Imm(r)`      |   `M[[Imm+R[r]]`      |     Base+Displacement|
|Memory         | `(r,t)`       |   `M[R[r]+R[t]]`      |               Indexed|
|Memory         | `Imm(r,t)`    |   `M[Imm+R[r]+R[t]]`  |               Indexed|
|Memory         | `(,r,s)`      |   `M[R[r]*s]`         |        Scaled Indexed|
|Memory         | `Imm(,r,s)`   |   `M[Imm+R[r]*s]`     |        Scaled Indexed|
|Memory         | `(r,t,s)`     |   `M[R[r]+R[t]*s]`    |        Scaled Indexed|
|Memory         | `Imm(r,t,s)`  |   `M[Imm+R[r]+R[t]*s]`|        Scaled Indexed|

`x86_64` supports a number of operand forms. Source values are given as
constants, registers, or memory; and results can be stored in either registers
or memory. 

### Immediate Operands.

The first type of operand is an **immediate**, which is a constant.
In `AT&T` syntax, it is preappended by `$`, and then followed by an integer
value in `C` notation (`$-577`, or `$0x1f`) Different instructions allow for
a different ranges of immediate values; and the assemble will automatically
select the most compact way of encoding the value.

### Register Operands.

The second type are **registers**, which denote the contents of a register. They
can contain one of the $$16$$ (`8`, `4`, `2`, or `1` byte) low order portions of
the register for `64`, `32`, `16`, or `8` bit operands. In the table above, `r`
and `t` are registers. The value of a register is indicated with the reference
`R[r]`, which means the assemble views the set of registers as an array indexed
by register identifiers (`rax`, `rdi`, etc).

### Memory Operands.

The third type of operand are the **memory reference** operands, in which
memory is accessed according to a computed address called the **effective
address**. These operands are also views by the assembler as an array  of
address, and so can be denoted `M[addr]`; which denotes a $$b$$-byte value
stored in memory starting at `addr` (here $$b$$ is arbitrary).

There are also different **addressing modes** for how memory is references. This
allows a wide variety of memory referencing. The most general form of addressing
are those with the syntax `Imm(r,t,s)` and are seen by the assembler as:
`M[Imm+R[r]+R[t]*s]`. There are four components to these references: There is
the immediate **offset** `Imm`, a **base** register `r`, an **index** register
`t`, and a scale factor `s` which must be either `1`, `2`, `4`, or `8`. Both the
index and base registers must be `64` bit registers. The effective address is
then computed to be `Imm+R[r]+R[t]*s`. This is the general form seen when
referencing elements of arrays. Since this is the general form, all other
addressing modes are just special cases of `Imm(r,t,s)`.

## Data Movements.

Some of the more heavily used instructions are the `mov` class of instructions,
which, as defined previously, copy data from a source location into the
destination. The generality of this operation allows a simple `mov` instruction
to express a rang of possibilities that in many machines would require
a different number of instructions.

The `mov` class is one example of an **instruction class** that represent
a class of instructions that reperesent the same operation, but on different
operand sizes. For example, the `mov` instruction consist of the instructions
`movb`, `movw`, `movl`, and `movq` which all perform the `mov` operation on
operands of `1`, `2`, `4`, and `8` bytes, respectively, in length.

In our example with the `mov` class, the source opeprand designates an
immediate, stored either in a register, or in memory. The destination is
a location that is either a register, or memory. The convention for `x86_64` is
that a `mov` instruction cannot have both operands refer to memory. If we want
to move data from one memory location into another, wee need to operations:
`mov` the data into a register, and then `mov` the register into a desired
location in memory; more consicely:

```c
mov     $Imm    %r
mov     %r      M[R[t]]
```

Where `r` and `t` are registers.

Register operands for these instructions can be any protion of the `16`
registers, and the size of the register indicates the suffix of the `mov`
instruction. For example operands `movw %bp, %sp` indicate the `w` suffix. In
most cases, `mov` will only update the specific bytes of the register indicated
by the destination operand. The exception here is `movl`, which, when having
a register as the destination, sets the high order `4` bytes to $$0$$. This
comes from the `x86_64` convention that any instruction generating a `32` bit
value for a register sets the higher ordered portion of the register to `0`. For
example, given

```c 
movabsq     $0x0011223344556677,    %rax    //%rax = 0x0011223344556677.
movb        $-1,                    %al     //%rax = 0x00112233445566ff.
movw        $-1,                    %ax     //%rax = 0x001122334455ffff.
movl        $-1,                    %eax    //%rax = 0x00000000ffffffff.
movq        $-1,                    %rax    //%rax = 0xffffffffffffffff.
```

## Memory Segmentation.

Before we can even consider doing anything with assembly, or even analyzing it,
we must know how memory is managed by programs. We exclusively consider `C`
programs compiled with the `gcc` compiler.

A compiled programs memory is allocated into five **segments** \(blocks of
contiguous memory\) called the **text** segment \(or **code** segment\),
**data** segment, **bss** segment, the **heap**, and the **stack**.

### The Text Segment.

The text segment is where the program's assembled machine language instructions
are located; and due to the high level control structures of `C`, execution in
this segment of memory is nonlinear. When a program executes, `rip` is set to
the first instruction in the text segment, and the processor does the following:

1. Read the instruction pointed to by `rip`.
2. Add the byte length of the instruction to `rip`.
3. Execute the instruction.
4. Repeat step 1.

If the processor encounters a jump instruction, it will change the value of
`rip` to the address specified by the `jmp` and repeat step 1. The text segment
only needs to be read, hence write permissions are disabled for this segment. It
prevents attempts from modifying the code to d anything it shouldn't and will
alert the user and kill the process if a write is attempted. It makes sense as
why should one be able to write already compiled code. This security measure
also prevents malicious actors from being able to modify the code directly once
it has been compiled. However, hackers have other ways of modifying program
execution.

### The Data and BSS Segments.

The data and bss segments store static and global variables \( a static
variable in `C` is any variable declared `static <type>`\). If the variable is
initialized with a value, it is stored in the data segment, and if it is not it
is stored in the bss segment. Since static and global variables are stored in
their own segments, they are able to persist throughout runtime.

### The Heap.

The heap is the segment in memory that a programmer can directly control.
Memory in this segment is allocated on a "as need" basis, and freed accordingly;
with this the programmer can allocate and free memory for whatever they might
need the program to do.

Since the heap allocates memory on the fly for the programmer, it is not of
a fixed size, and can grow \(when allocating memory\) or shrink \(when freeing
memory\) as needed. Typically the heap starts at the lower memory addresses and
grows towards higher memory addresses.

### The Stack

On the opposite side of the heap \(literally\), the stack is a another variable
size memory segment, and grows from the higher memory segments towards lower
memory addresses \(in most implementations\). The stack is used mainly as
a place to store addresses to functions \(for function calls\), and non
global/static variables. When these functions or variables are no longer needed,
they are popped off of the stack. This is the reason why variables declared in
functions "die" when the function terminates; where as global/static variables
persist.

When a function is called with the `call` instruction in assembly, the address
of `rip` is changed to that of the function, and the program continues in the
function's block of memory. If `rip` is not changed when the relevant function
finishes, the program would terminate \(or crash\), for this reason, the stack
stores a copy of the address `rip` should return to after the function
terminates, so that execution can can be proceed as it should. We call the
address the stack saves the **saved `rip`** address. The stack also "remembers"
all the passed variables \(function arguments\). All this information, the
address of the function, the saved frame pointer, the variables of the function,
and the function's arguments are all stored together on a **stack frame**. The
stack can have multiple stack frames coinciding with multiple function calls.
The stack is literally a stack data structure, and hence follows the **FILO**
\(**first in last out**\) ordering. As functions are called, stack frames are
**pushed** onto the stack, and once the functions terminate, they are **popped**
off.

The stack pointer `rsp` is used to keep track of what is at the top of the
stack, and changes location as stack frames are pushed onto and popped off the
stack, hence the name "stack pointer".

When a function is called, several things are pushed onto the stack in a stack
frame. The aforementioned function address, variables, arguments, are bundled
together as discussed above; in addition, `rbp` is also in the stack frame, and
in this context is called the **frame pointer**. `rbp` points to locations
within the stack frame itself, and is used to reference local function
variables. Another pointer called the **saved frame pointer** is also stored in
the stack frame, as well as the **return** address of the function. The saved
frame pointer and the saved `rip` are necessary to return the execution flow to
where it should be once the stack frame is popped. The saved frame pointer
returns `rbp` to its previous address before the function call, and the saved
`rip` returns `rip` to the address after call. The saved `rip` is also called
the **return** address of the function. The instruction in assembly to restore
`rip` is `ret`. The first few instructions in the function prologue effectively
set up the stack frame for the function. The function epilogue are the
instructions that restore everything.

#### Pushing and Popping from the Stack.

Focusing now on the `push` and `pop` operations of the stack, given the stack
data structure, it can be implemented as a continguous array where we always
push and pop elelments from one end; the top. For illustrative purposes, since
the stack starts high and grows low, we draw the stack upside down, where the
top of the stack is at the bottom (this is just convention).

The `pushq` instruction pushes data onto the stack, while `popq` pops it. They
both take only one operand, which is the data that is to be pushed or popped.
Notice since the both have the `q` suffix, they work with quad words. Pushing
a quad word onto the stack involves first decrementing the top of the stack by
`8` bytes, and then writing the value at the new top of the stacl, and moving
`rsp` to that value. Thus the instruction `pushq %rbp` is equivalent to

```c
subq    $8,         %rsp
movq    %rbp,       %rsp
```

`pushq` however, es machine encoded into a single byte, where as above `8` bytes
are needed. Similarly, popping a word with `popq` entails reading from the top
of the stack, and then incrementing the top by `8`. So `popq %rax` is equivalent
to

```c 
movq    (%rsp),     %rax
addq    $8,         %rsp
```

### Heap vs. Stack.

The heap and the stack are found as far apart from each other as possible, and
grow towards each other. This is to maximize the amount of space each memory
segment can access. As the heap grows, the stack has less memory to use, and
vice versa as the stack grows. It is for this reason why we want the heap and
the stack to be as far from each other as possible. If they were to collide, the
program wouldn't be able to tell which address was allocated on the heap, and
which belongs to the stack. This, unsurprisingly would cause the program to
behave disastrously.

## Assembly vs `C`.

`C` is a relatively low level language when compared to other high level
programming languages, and indeed `C` was in part developed to be as similar to
assembly as possible. However programming in `C` is different from programming
to assembly. Thankfully, the similarities mean that the underlying principles do
not change much.

Consider the `helloWorld.c` program from before:

```c
#include<stdio.h>

int main(){

    printf("Hello, world!\n");

    return 0;
}
```

The preprocessor directive is declared including the `stdio.h` header file,
then `main()` is declared, and then `printf()`, which relies on `stdio.h` is
called with the string `Hello, world!\n` as an argument. We then terminate the
function `main()` with a `return`, specifying to return `0` to signify success.
The principle will be similar to when we want to program in assembly. We would
like to specify a header file for which we will use a procedure which we will
use to print our string. We will set up a `main()` function to call it, and we
would want to add a return that also signifies that the program exited
successfully. Let us go more in depth

In `C`, standard libraries are called for convenience and portability. Using
`printf()` in our program will enable our program to be compiled for different
architectures and systems. We can do that is because the standard libraries know
the system calls to be able to output the string `Hello, world!` to the screen.

Now when `helloWorld.c` is compiled and the binary is run, the execution will
flow through the `stdio` library, and makes a syscall to `write`. Which writes
`Hello, world!` to the output in the screen. We can view how syscalls work with
`man 2 syscall` and we can look at individual syscalls with `man 2 <syscall>`
where `<syscall>` is the syscall you want to view.

We can view the syscalls that the program makes using the `strace` command,
which traces the syscalls that a program makes. In this example, we get that our
`helloWorld` program makes the following syscalls

```bash
~/ccom4086/ > gcc -o hello helloWorld.c
~/ccom4086/ > ./hello
Hello, world!
~/ccom4086/ > strace ./hello
execve("./hello", ["./hello"], 0x7fff37da9c90 /* 61 vars */) = 0
brk(NULL)                               = 0x564106081000
arch_prctl(0x3001 /* ARCH_??? */, 0x7fff1689f740) = -1 EINVAL (Invalid argument)
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
newfstatat(3, "", {st_mode=S_IFREG|0644, st_size=197640, ...}, AT_EMPTY_PATH) = 0
mmap(NULL, 197640, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7fc3ad6da000
close(3)                                = 0
openat(AT_FDCWD, "/usr/lib/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0`|\2\0\0\0\0\0"..., 832) = 832
pread64(3, "\6\0\0\0\4\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0"..., 784, 64) = 784
pread64(3, "\4\0\0\0@\0\0\0\5\0\0\0GNU\0\2\0\0\300\4\0\0\0\3\0\0\0\0\0\0\0"..., 80, 848) = 80
pread64(3, "\4\0\0\0\24\0\0\0\3\0\0\0GNU\0K@g7\5w\10\300\344\306B4Zp<G"..., 68, 928) = 68
newfstatat(3, "", {st_mode=S_IFREG|0755, st_size=2150424, ...}, AT_EMPTY_PATH) = 0
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fc3ad6d8000
pread64(3, "\6\0\0\0\4\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0"..., 784, 64) = 784
mmap(NULL, 1880536, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fc3ad50c000
mmap(0x7fc3ad532000, 1355776, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x26000) = 0x7fc3ad532000
mmap(0x7fc3ad67d000, 311296, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x171000) = 0x7fc3ad67d000
mmap(0x7fc3ad6c9000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1bc000) = 0x7fc3ad6c9000
mmap(0x7fc3ad6cf000, 33240, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fc3ad6cf000
close(3)                                = 0
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fc3ad50a000
arch_prctl(ARCH_SET_FS, 0x7fc3ad6d9580) = 0
mprotect(0x7fc3ad6c9000, 12288, PROT_READ) = 0
mprotect(0x564104dae000, 4096, PROT_READ) = 0
mprotect(0x7fc3ad739000, 8192, PROT_READ) = 0
munmap(0x7fc3ad6da000, 197640)          = 0
newfstatat(1, "", {st_mode=S_IFCHR|0620, st_rdev=makedev(0x88, 0x2), ...}, AT_EMPTY_PATH) = 0
brk(NULL)                               = 0x564106081000
brk(0x5641060a2000)                     = 0x5641060a2000
write(1, "Hello, world!\n", 14Hello, world!
)         = 14
exit_group(0)                           = ?
+++ exited with 0 +++
```

Here we see that the `hello` program sets up the environments memory for
execution, making various syscalls. However, the most important syscalls are the
`write()` and `exit()` syscalls:

```bash
write(1, "Hello, world!\n", 14Hello, world!
)         = 14
exit_group(0)                           = ?
```

Here we see that `write()` is called with three arguments. The first is the
**file descriptor** for `stdout`. File descriptors are used for everything in
`unix`; input, output, networking, etc. What a file descriptor is is a reference
to a file, which is referenced by an integer. In this case, the file descriptor
is `1` for `stdout`. The first three file descriptors `0`, `1`, and `2` are used
for input \(`0`\), output \(`1`\), and errors \(`2`\). What the `write()`
syscall does with the file descriptor is specify where to write it's argument;
in this case it will write the argument to `stdout`, which means to print on the
screen.

The second argument for the `write()` syscall is the message we actually want
to write out; in this case "Hello, world!" with a newline character, and the
third argument is the length of the message. `Hello, world!\n` has a length of
`14` bytes.

Next comes the `exit()` syscall, which just takes one argument: the **exit
code**. `exit()` is called with exit code `0` which means that the program
terminated successfully. Calling `exit()` with exit code `1` indicates that the
program exited with error\(s\).

In assembly, every linux syscall is enumerated, and hence referenced by numbers
when making calls in assembly. For example the syscall number for `write()` is
`1` in `x86_64` and `4` in `x86_32`; so the syscall numbers are dependent of
architecture. For additional reference, exit has syscall numbers `60` and `1` in
`x86_64` and `x86_32` respectively. We can view syscall numbers in unix by
running `cat` on the appropriate file in the `/usr/include/asm/` directory.

We are now in a position to write our `helloWorld` program in assembly
language. We now know the relevant syscalls to `write()` and `exit()`, as well
as what we want to print out to the screen `Hello, world!\n` \(recall that
`stdout` takes in to account newline characters\). We will use slightly
different syntax from the assembly we've seen so far, as the assembler we will
be using it requires it. We will be using `nasm` as the assembler, which takes
`intel` syntax.

Recall how memory is segmented in a program. We want to specify the `data`
segment, so that we can store the string `Hello, world!\n` and we want to
specify the `text` segment which will contain our assembly code. So far, then
our assembly will have a data segment that looks like:

```c
section .data
   msg:     db      "Hello, world!", 10
```

Here `msg` is the variable we will be using to store our string. It takes
`Hello, world!`, and then `10` which will specify the new line character.

Now we want to set up our `text` segment. Recall that in order to write the
code, we have to set up the memory on that stack. We must declare a "main"
procedure; in the case of `nasm` this procedure is named `_start`. So we have:

```c
section .text
    global _start
```

Then we call `_start` which pushes the stack frame onto the stack. Now we want
to set up the memory to be able to call our syscalls. That is we need to set up
the syscall, the arguments that it takes, and then call it. In the case of
`write()`, it takes `3` arguments, so we have to set up `3` registers. In `man
2 syscall`, the calling convention specifies that `rax` is the register we use
to set up the syscall. `rdi`, `rsi`, and `rdx` are the registers used for the
first, second, and third arguments of a syscall, respectively. Finally we call
`write()` in `x86_64` assembly by calling the `syscall` instruction. \(In
`x86_32`, we would call `int 0x80`\). So we have our text section looking like:

```c
_start:
    mov     rax,    1
    mov     rdi,    1
    mov     rsi,    msg
    mov     rdx,    14
    syscall
```

Similarly, to set up `exit()`, we have:

```c
    mov     rax,    60
    mov     rdi,    0
    syscall
```

Now we are done with the code, so the final product is the following assembly
program:

```c
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
```

We should specify that everything that comes after `;` is interpreted as
a comment by `nasm`. Now we wish to compile this code into a program. We do this
with `nasm`, using the `-f` flag to specify the architecture, `-o` to specify
the output file, and our assembly program.

```bash
~/ccom4086/ > nasm -f elf64 -o hello.o helloWorld.asm
```

This produces the `hello.o` object file, which we cannot run, so we need the
use of a linker to be able to output a proper binary. Luckily, `linux` comes
with a linker called the **GNU linker**, and is called via the `ld` command in
the terminal. Thus we input `hello.o` into the `ld` to get a `hello` binary.
Running `hello` should output `Hello, world!` on the screen.

```bash
~/ccom4086/ > ld -o hello hello.o
~/ccom4086/ > ./hello
Hello, world!
```

We have just created and run our first assembly program.

### `32` Bit Considerations.

The assembly program we just created was created for `64` bit architectures;
specifically, for `x86_64`. If one wanted to create `helloWorld.asm` for `32`,
one would have to rewrite the program to accommodate `32` bit registers and
calling convention. For example we can no longer use `rdi`, `rsi`, and `rdx` to
set up the arguments for `write()`. Instead `32` bit calling convention reserves
`ebx`, `ecx` and `edx` for the first three arguments of any given syscalls.
Similarly, syscalls cannot be called with `syscall`, but are instead called with
the `int` instruction, which stands for **interrupt**, `int` sends an interrupt
to the operating systems kernel to execute a process. In this case, `int 0x80`
is the interrupt for calling syscalls. Rewriting `helloWorld.asm`, the program
would look like:

```c
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
```

Similarly, to get `nasm` to compile for `32` bit, it has to be run with the
`elf32` flag. To get `ld` to link it, we must also specify `32` bit architecture
with the `-m` flag.

```bash
~/ccom4086/ > nasm -f elf32 -o hello.o helloWorld32.asm
~/ccom4086/ > ld -m elf_i386 -o hello hello.o
~/ccom4086/ > ./hello
Hello, world!
```

## Other Assembly Language Considerations.

Assembly language isn't just a language to program for fun. It is a direct
analogue to machine language. That means that assembly is intrinsically tied to
the hardware of any given machine. Desktop, laptop, and server computers all
have their own assembly language; as do microcontrollers, and even GPUs.

Since assembly is $$1-1$$ with machine code, we do not have to program in
machine code to be able to see how the hardware works. Instead of remembering
binary representations for instructions such a `add` and `mov`, we can remember
the mnemonics. Instead of having to worry about specific addresses, we can just
name variables and registers. We can also even enter into coding machine code
and back.

Assembly language also allows for very granular control. The downside is that
it makes it hard to debug and maintain, however programming in assembly should
be done sparingly. It also helps hackers compromise systems. By understanding
the assembly, they can get the system they want to compromise to do whatever
they want. The can also write pieces of assembly code called **shellcode** that
when injected into a vulnerable program, allows them arbitrary code execution.

Assembly language teaches us how the hardware works, so understanding the
assembly lets us understand the hardware. It also introduces a programming
paradigm that focuses on relying on very low level solutions, which introduce
new problem solving techniques. One example of this is how we can optimize
a program by working with its assembly counterpart. It can also do things better
than certain other high level languages, such as self modifying code, writing
drivers, and kernel components for an operating systems, writing drivers, and
kernel components for an operating system. It even helps with better interacting
with higher level languages and write in them more efficiently.

