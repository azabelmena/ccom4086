---
description: >-
  In this section, we go over numerical representation in computer systems and
  how computers deal and treat numerical information. We go over decimal,
  binary, and hexadecimal representation.
---

# Numerical Representation in Computers.

## Representation of Information.

### Binary, Decimal and Hexadecimal

In a computer system, numerical information is encoded in **binary digits**, or
**bits**. Bits are encoded as 0 or 1; hence, one can view a computer as working
over the finite field of two elements $\mathbb{F}_2$ \(addition and
multiplication are defined a little differently\). By encoding bits in various
ways, computers determine what instructions to execute and represent numbers in
different bases, strings of characters, etc, and manipulate them.

![Binary encoding of voltage. 0 is low voltage, 1 is high
voltage.](../.gitbook/assets/2021-08-19_08-57.png)

Why do computers use bits? Bits are easy to work with. A typical computer
operates with transistors turning _on_ with a HIGH voltage, and turning _off_
with a LOW voltage. This makes the values 0 and 1 natural analogs to represent
LOW and HIGH, OFF and ON, or FALSE and TRUE. So bits are easy to store with
bistable elements. Another reason why bits are preferred, is that they can be
reliably transmitted on noisy, or faulty wires, reducing the cost of error
correction.

#### Example

* `15213` in decimal is `11101101101101` in binary.
* `1.20` in decimal is `1.0011001100110011[0011]...` in binary.
* `1.55213e4` in decimal is `1.1101101101101e13` in binary.

We can encode 8 bits into a **byte** value. With this encoding, we can
represent 256 different numbers. In decimal we can represent the numbers `0` to
`255` and in binary `00000000` to `11111111`.

Hexadecimal is also a useful way to encode bytes. **Hexadecimal** is just the
integers $$\mod{16}$$ encoded in a special way. We represent one hexadecimal
digit by, `0-9` and `a-f`, as 4 bits, a byte is represented as any combination
of two hex digits. For example, the byte `00001111` can be represented as `0x0f`
in hex. Then the hexadecimal number `0xfa1d37b` is
`1111101000011101001101111011` in binary and `4196218235` in decimal.

Here we are assuming that the reader knows how to convert decimal to binary to
hex and vice versa. It would also be useful to know or learn some algorithms for
easy conversion.

### Data Representation

The following table shows some data representations in different architectures,
and their sizes.

|`C` data type|`32` bit|`64` bit| `x86_64` | Size |
| :--- | :---: | :---: | :---: | ---: |
| `char` | `1` byte | `1` byte | `1` byte | `8` bits |
| `short` | `2` bytes | `2` bytes | `2` bytes | `16` bits |
| `int` | `4` bytes | `4` bytes | `4` bytes | `32` bits |
| `long` | `4` bytes | `8` bytes | `8` bytes | `32`/`64` bits |
| `float` | `4` bytes | `4` bytes | `4` bytes | `32` bits |
| `double` | `8` bytes | `8` bytes | `8` bytes | 64\` bits |
| `long double` |  |  | `10`/`16` bytes |  |
| `pointer` | `4` bytes | `8` bytes | `8` bytes | 32`/`64\` bits |

## Bit Level Manipulation.

|   AND     |       |       |       |       OR              |       |       | 
|   :---:   |:---:  |:---:  |:---:  |       :---:           |:---:  |:---:  |
|   `&`     |`0`    |`1`    |       |<code>&#124;</code>    |`0`    |`1`    |
|   `0`     |`0`    |`0`    |       |       `0`             |`0`    |`1`    |
|   `1`     |`0`    |`1`    |       |       `1`             |`1`    |`1`    |

|   NOT     |       |       |       |       XOR     |       |       |
|   :---:   |:---:  |:---:  |:---:  |       :---:   |:---:  |:---:  |
|   `~`     |       |       |       |       `^`     |`0`    |`1`    |
|   `0`     |`1`    |       |       |       `0`     |`0`    |`1`    |
|   `1`     |`0`    |       |       |       `1`     |`1`    |`0`    |


The way we manipulate binary digits is with **Boolean algebra**, developed by
George Boole, which defines algebra over the finite field $$\mathbb{F}_2$$. This
algebra is useful for representing the logic of computers, in which `1` is
encoded as `true` and `0` is `false`. The following are some bitwise operations
of boolean algebra.

* The **AND** operation `&` in where `A&B=1` only when both `A=1` and `B=1` and `A&B=0` in any other case.
* The **OR** operation `|` where `A|B=1` when either `A=1` or `B=1`, and `A|B=0` when both are `0`.
* The **NOT** \(or _negation_\) operation `~` where `~A=1` when `A=0` and `A=0` when `A=1`.
* The **exclusive OR** \(**XOR**\) operation `^`, where `A^B=1` when either `A=1` or `B=1` \(but not both\), and `A^B=0` in any other case.

These operations are applied bit wise, that is if:

$$
a=(a_{0}, \dots, a_{k}) \text{ and } b=(b_{0}, \dots, b_{k})
$$

Are `k` bit binary numbers, and if $$\cdot$$ is a bitwise operation \(not
necessarily those of above, then:

$$
a \cdot b = (a_{0} \cdot b_{0}, \cdots, a_{k} \cdot b_{k})
$$

One interesting thing to note, is that, $$\mathbb{F}_2$$ forms an Abelian group
under `&`, and Abelian group over `|`, and that `&` distributes over `|`. So `|`
can be viewed as an addition over $$\mathbb{F}_2$$, and `&` as multiplication
\(we also see that `|` distributes over `&`\). That is $$\mathbb{F}_2$$ forms
a field over `&` and `|`. So an computer can be seen as operating over an $$n$$
dimensional vector space over $$\mathbb{F}_2$$.

Let us put aside first that given the binary number represented as a vector, we
make the following convention:

$$
(a_0, \dots a_{k}) \equiv a_k \cdot 2^k+\dots+a_{0} \cdot 2^0
$$

\(That is we represent binary numbers mathematically in little-endian fashion,
more on that later\).

### Bit Level Operations in C.

In `C/C++`, bit level operations operate on any integral data types \(`char`,
`short`, `int`, `long`, and `unsigned`\). And, as described above, they view
their arguments as bit vectors, and are applied bitwise.

#### Example.

* `~0x41 = 0xbe`.
  * `~01000001 = 10111110`.
* `~0x00 = 0xff`.
  * `~00000000 = 11111111`.
* `0x69 & 0x55 = 0x41`.
  * `01101001 & 01010101 = 01000001`.
* `0x69 | 0x55 = 0x7d`.
  * `01101001 | 01010101 = 01111101`.

In contrast to the logical operations of `C/C++` \(`&&`, `||`, and `!`\), which
view `0` as `false` and any nonzero value as `true`, they will always return `0`
or `1`, and terminate as early as possible. For example for `int a = 0`, `a &&
p/a` will return `0`, moreover it will terminate as soon as it evaluates `a`,
and will never evaluate `p/a` which is a division by `0`.

### Shift Operations.

There are additional bit operations called **shift operations**. There is
a **left shift** denoted by `<<` and a **right shift** denoted by `>>`.

#### Left Shifts

We define the left shift operation as follows. Given a bit vector $$x = (x_{0},
\dots, x_{k})$$ and an integer $$w$$,

$$
x << w = (0, \dots, 0, x_{0}, \dots, x_{k-w-1})
$$

That is the left shift shifts $$x$$ $$w$$ bits to the left and overwrites the
least significant bits with `0`.

#### Right Shifts.

There are two different definitions for what a right shift is. There is
a **logical** right shift and an **arithmetic** right shift.

Given a bit vector $$x$$ and an integer $$y$$, and the logical right shift
`>>`, $$x >> w$$ shifts the bits of $$x$$ $$w$$ bits to the right and overwrites
the remaining bits with `0`.

#### Example.

* `0x01 << 4 = 0x04`.
  * `00000001 << 4 = 00010000`.
  * `1 << 4 = 16`.

Given an vector $$x$$ and an integer $$w$$, and the arithmetic right shift
`>>`, $$x >> w$$ overwrites the left most $$w$$ bits by the most significant bit
of $$x$$.

#### Example

* `10100010 >> 2 = 00101000` \(logical right shift\).
* `10100010 >> 2 = 11101000` \(arithmetic right shift\).

### Shift implementations in C/C++.

Given a left or a right \(arithmetic or logical\) shift, and a bit vector, it
is possible to completely overwrite the bit vector if an integer greater than or
equal the bit length is chosen. For example, 
`001100 << 6 = 000000`. And `1010 >>4 = 0000` or `1010 >> 4 = 1111` \(depending
on the context\). For that reason, in `C/C++` it is good to choose an integer
that is less than the size of the given data type when using a either shift
operations. In certain cases, it may be that the shift operation actually 
shifts $$k \mod{w}$$ bits, \(where $$w$$ is a given integer, and $$k$$ is the
size of the data type\), however it is not consistent. In some machines, only
$$log_2(w)$$ bits of the shift amount will actually be shifted.

Another behaviour is the `C` does not precisely define whether a right shift is
logical or arithmetic, leading to portability issues.
