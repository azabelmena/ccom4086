# Arithmetic and Logical Operations in Assembly Language.

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

As an example, consider the following `C` code and its assembly translation.

```c
long exchange(long* xp, long y){
    long x = *xp;
    *xp = y;
    
    return x;
}
```

```c
exchange:
    movq    (%rdi),     %rax
    movq    %rsi,       (%rdi)
    ret
```

When `exchange()` begins execution, `xp` and `y` are stroed in `rdi` and `rsi`,
then `x` is read and stores it in `rax`, this corresponds to storing the address
at `xp` into `x`. Then  `y` is copied into `xp`. The function then returns. Thus
the `mov` instruction can be used to read from memory and store it in
a register, and to write from a register to memory.

Also notice that pointers are just memory addresses, dereferencing entails
copying an address into a register, and then using the register in a memory
reference. Additionally, local variables are stored into registers, which are
much faster to access than memory.

Just like the `mov` instruction, most other instructions are given istruction
classes to deal with different operand sizes. For example, just like `mov`, the
`add` instruction class has the variants `addb`, `addw`, `addl`, and `addq`,
which operate on bytes, words, double words, and quad words respectively. This
is true for all other instructions. The only instruction that has no other size
variants however is the `leaq` instruction. 

The istruction classes are divided into four groups, the _load effective
address_ instruction, unary and binary instructions, and _shift_ instructions.

|Instruction            |       Effect              |              Description|
|:---                   |       :---:               |                     ---:|
|`leaq S, D`            |       `D = &S`            |   Load Effective Address|
|`inc D`                |       `D += 1`            |   Increment             |
|`dec D`                |       `D -= 1`            |   Decrement             |
|`not D`                |       `D = ~D`            |   Negate                |
|`add S, D`             |       `D = D+S`           |   Add                   |
|`sub S, D`             |       `D = D-S`           |   Subtract              |
|`imul S, D`            |       `D = D*S`           |   Multiply              |
|`xor S, D`             |       `D = D^S`           |   Exclusive Or          |
|`or S, D`              |<code>D = D &#124; S</code>|   Or                    |
|`and S, D`             |       `D = D&S`           |   And                   |
|`sal k, D`             |       `D = << k`          |   Left Shift            |
|`shl k, D`             |       `D = << k`          |   Left Shift            |
|`sar k, D`             |       `D = >> k`          |   Arithmetic Right Shift|
|`shl k, D`             |       `D = >> k`          |   Logical Right Shift   |
-------------------------------------------------------------------------------

## The `leaq` Instruction.

The **load effective address** instruction, `leaq` is a variation of `movq`. It
reads from memory into a register, with the exception that it does not reference
memory at all. Instead of reading from the designated location, it copies the
effective address into the destination operand; hence the name. Additionally,
the destination operand of `leaq` must be a register.

`leaq` can be used to generate pointers for memory reference, and it can be used
to describe arithmetic operations. For example, if `rdx` contains 
the value $$x$$, then the instruction `leaq 7(%rdx,%rdx,4), %rax` correspinds to
storing $$5x+7$$ into `rax`. Compilers often use clever tricks with `leaq` which
has nothing to do with actually loading the effective addreess.

Consider the following code:

```c
long scale(long x, long y, long z){
    long t = x+4*y+12*z;

    return t;
}
```

Compiling it, the arithmetic operations are implemented as a sequence of `leaq`
instructions:

```c
scale:
    leaq    (%rdi,%rsi,4),     %rdx      // x+4*y
    leaq    (%rdx,%rdx,2),     %rdx      // z+2*z
    leaq    (%rax,%rdx,4),     %rax      // x+4*y+12*z
```

The ability of the `leaq` instruction implementing basic forms of arithmetic
makes it  useful when compiling simple arithmetic expressions. 

## Unary and Binary Instructions.

The second group of operations are the unary and binary instructions. For unary
instructions, the single operand is both the source and the destination. Again,
this operand may be a register, or a location in memory. The `incq` instruction
**increments** the operand by `1`., for example `incq (%rsp)` increments the `8`
byte stack pointer by `1`, moving the top of the stack. This instruction is
indicative of the `++` and `--` operations in `C`.

In binary instructions, the second operand is also both a source, and
a destination, and again can be a register, or a memory location, and is
reminiscent of the `+=`, `*=`, `-=`, and `/=` operations in `C`. The convention
of source first and destination second looks peculiar for noncommutative
operations. For example `subq %rax, %rdx` decrements the register `rdx` by the
value in `rax`. Likewise with the `mov` instruction, both operands cannot be
memory locations. If the second operand is  a memory location, then the
processor must read the value from memory, perform the operation, and write the
result back into memory.

## Shift Instructions.

Finally, there are the **shift** instructions, which implement shift operations.
Left shifts are implemented, as well as right shifts (arithmetic and logical).  
The fisrt operand is required to be an immediate or the single byte
register `cl`, and denotes the shift ammount, the second operand is the value to be
shifted. For example, if `rdx` holds the value $$x$$, then `sal 7 %rdx`
translates to $$x << 7$$. Having a `1` byte operand allows encoding of shift
ammounts up to $$2^8-1=255$$. 
With `x86_64`, a shift instruction operating on $$w$$ bit long values,
determines the shift ammount of from the lower order $$m$$ bits of `cl`, 
where $$2^m=w$$. The higher bits are ignored. 
For example, if `cl` has the value `0xff`, then the instruction `salb` shifts by
`7` while `salw` shifts by `15`, `sall` by `31`, and `salq` by `64`.

There are two names for the left shift insgtruction, `sal` and `shl`. Both
execute the same operation, which is a left shift. On the contrary, the
arithmetic right shift is perfomred by teh `sar` instruction, and `shr` performs
a logical right shift.

Most of the instructions seen so far can be used for unsigned or two's
compliment arithmetic, with inly the right shift operations requiring that the
two be distinguished. This is one of the features that makes two's complement
arithmetic the desired way to implement signed arithmetic.

In genral, compilers generate code that uses individual registers for multiple
program values, and move them among the registers.

## Special Arithmetic Instructions.

Multiplyin two `64` bit signed or unsigned integers can yield a product
requiring `128` bits to represent. Thus, the `x86_64` instruction set implements
limited support for operations involving `128` bit (or `16` byte) numbers. We
refer to these numbers as **oct words**, and are the same convention used by
Intel.

The `imulq` instruction has two different forms. One is the memmber of the
`imul` instruction class, and is a binary multiply instruction generating a `64`
bit output from two `64` bit operands. It implements unsigned and two's
complement multiplication in `64` bits. This operation will yield an incorrect
result if overflow occurs. The second is a unary multipy instruction used to
compute `128` b The second is a "one operand" multipy instruction used to
compute a `128` product of two `64` bit operands. There is one for unsigned
data, `mulq`, and anither for signed data, `imulq`. For both these instructions,
one operand must be in `rax`, and the other is the source operand. The product
is then stored in the high `64` bit portion of `rdx` the low order portion of
`rax`. The assemble distinguishes between the two versions of `imulq` by
counting the number of operands.

For example, consider the `C` code generating a `128` bit product of two `64`
bit values.

```c 
#include<inttypes.h>

void store(__int128* dest, __int64 x, __int64 y){
    *dest = x * (__int128) y;

    return;
}
```

`x` and `y` are explicitly declared to be `64` bit `ints`, and `dest` is a `128`
bit `int`, this can be done by including the `inttypes.h` header file. Instead
of making provisions for `128` bit values, what this library does is rely on the
`128` bit integer support built in to `gcc`. The code specifies that the product
should be stored at `16` bytes designated by the `dest` pointer. Compiling this
into assembly, we get:

```c
store:
    movq    %rsi,   %rax        // Copy x into dest.
    mulq    %rdx                // Multiply by y.
    movq    %rax,   (%rdi)      // Store lower 8 bytes at dest.
    movq    %rdx,   8(%rdi)     // Store upper 8 bytes at dest+8.
    ret                         // Return.
```

Storing the product requires two `mov` instructions, of for the lower `8` byte
portion, and one for the upper `8` byte portion. For little endian machines,
high order bytes are stored at higher addresses, in big endian, it is the
opposite.

The division an modulus instructions are provided by a unary divide instruction
similar to the unary multiply instruction. The signed division instruction
`idivl` takes as its dividen the `128` bit cuantity in the high order `64` bits
of `rdx` and the low order `64` bits of `rax`. The divisor is given as the
instruction operand, and the instruction stores the quotient in `rax` and the
remainder in `rdx`. The dividend is given as a `64` bit value, for most
applications of `64` bit addition. This value should be stored at `rax`, and the
bits of `rdx` should either be all `0` (unsigned) or the sign bit of `rax`
(signed). The `cqto` instruction can perform the latter. This instruction takes
no operands, and just reads the sign bit from `rax` and copies it to `rdx`.
