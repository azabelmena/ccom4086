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

|Instruction            |       Effect          |              Description|
|:---                   |       :---:           |                     ---:|
|`leaq S, D`            |       `D = &S`        |   Load Effective Address|
|`inc D`                |       `D += 1`        |   Increment             |
|`dec D`                |       `D -= 1`        |   Decrement             |
|`not D`                |       `D = ~D`        |   Negate                |
|`add S, D`             |       `D = D+S`       |   Add                   |
|`sub S, D`             |       `D = D-S`       |   Subtract              |
|`imul S, D`            |       `D = D*S`       |   Multiply              |
|`xor S, D`             |       `D = D^S`       |   Exclusive Or          |
|`or S, D`              |       `D = D|S`       |   Or                    |
|`and S, D`             |       `D = D&S`       |   And                   |
|`sal k, D`             |       `D =  << k`     |   Left Shift            |
|`shl k, D`             |       `D =  << k`     |   Left Shift            |
|`sar k, D`             |       `D =  >> k`     |   Arithmetic Right Shift|
|`shl k, D`             |       `D =  >> k`     |   Logical Right Shift   |

## The `leaq` Instruction.

The **load effective address** instruction, `leaq` is a variation of `movq`. It
reads from memory into a register, with the exception that it does not reference
memory at all. Instead of reading from the designated location, it copies the
effective address into the destination operand; hence the name.

`leaq` can be used to generate pointers for memory reference, and it can be used
to describe arithmetic operations. For example, if `rdx` contains 
the value $$x$$, then the instruction `leaq 7(%rdx,%rdx,4), %rax` correspinds to
storing $$5x+7$$ into `rax`. Compilers often use clever tricks with `leaq` which
has nothing to do with actually loading the effective addreess.
