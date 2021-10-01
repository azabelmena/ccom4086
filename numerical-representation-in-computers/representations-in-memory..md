---
description: >-
  We go over how memory is organized on a cumputer, and how things like chars,
  pointers, and strings are represented.
---

# Representations in Memory.

## Byte Oriented memory orginization.

We can visualize computer memory as a large array of bytes, and a byte is the 
smallest of unit that one can access. Bytes in memory are referred to by 
**addresses** which is an index to the array of memory. Addresses are encoded 
in hexadecimal, and goes from address `00...0` to `ff...f`. **Pointers** are 
variables that store memory addresses. We also note that systems provide 
private access to memory to processes. Each process can access the memory 
allocated for it, but not that of others. Each process is explicitly controlled 
by the operating system.

## Machine Words.

Every machine has a given "word size", which describes how big addresses are. 
Typical `32` bit machines use `4` bytes as one **word**, which limits the address 
space to `4GB` or $$2^32$$ possible bytes. Most machines now have `64` bit word 
sizes, increasing the address space to `18 EB` or $$18.4 x 10^18$$ total bytes. 
Most `64` bit machines support `32` bit word sizes, and also support multiple 
data formats which make up fractional or multiples of words, and must always be 
an integral number of bytes.

Addresses specify byte locations, and when referencing a data type, the address 
indexes the first byte of the word. That is words are refered to by their firt 
byte. So the word `0000 0001 0002 0003` will be reference by `0000`, and the next 
word by `0003` \(for `32` bits\). For `32` bits, the addresses of successive 
words differ by `4`, while for `64` bits, they differ by `8`.

If we set, for example `int x = 0x1234567`, we can "store" it at address `100`, 
that is `&x == 0x100` \(where we assume an integer to by `4` bytes in length\). 
We reference `x` at its first byte, but since `x` is of `4` bytes in length, `x` 
is actually stored contiguously at addresses `0x100`, `0x101`, `0x102`, and 
`0x103`. Conventions will dictate whether `x` is stored in big endian fashion 
\(for Sun, PCC Mac, or internet\), or little endian \(`x86`, or ARM\). Endianness 
matters for debugging, for considder the follwing disassembly

```bash
    addr        Machine                Assembly
-------------------------------------------------------------------------------
    1189:	    e8 d2 fe ff ff       	call   1060 <puts@plt>
    118e:	    83 7d ec 03          	cmpl   $0x3,-0x14(%rbp)
    1192:	    7e 0c                	jle    11a0 <main+0x37>
-------------------------------------------------------------------------------
```

Which describes a little endian encoding. The machine instruction at `118e` is 
read as `83 7d ec 03`, where as it's corresponfing assembly instruction in `cmpl 
$0x3, -0x14(%rpb)`. Here `03` is the most significant byte, and hence represented 
last in the machine code. This makes sense as the corresponding program was compiled 
in an `x86_64` machine.

## Strings.

In `C`, strings are represented by arrays of characters, that is an array of data 
types of type `char`.  Each character is encoded in ASCII format, and \(shoulb be\)
terminated with the _null byte_ `0`, or `\0`. Byte ordering is not an issue since 
each character is only `1` byte.

Apart from the ASCII standard, there is also the **Unicode** standard which is 
used to represent a whole space of characters that ASCII cannot represent. The 
Unicode standard was created due to the limitations of ASCII for representing 
characters from other languages such as the letters `ç` or `ñ` in portuguese/french 
and spanish \(respectively\). Thus the Unicode standard handles consistent 
encoding, and representation of text in different languages and and writing 
systems. It can handle latin, greek, currency, and mathematical symbols, and even 
emojis. The Unicode encodings while have the same encodings for ASCII for the 
characters that come from ASCII, but also encode characters and scripts from 
outside of ASCII with different codes. Most characters for Unicode will require 
more than `8` bits to encode a  character, as with ASCII; so data types of type 
`char` encoded in Unicode can be well over `1` byte in length \(byte ordering 
will matter in this case\). This gives us the concept of a **Unicode strings**.

### Unicode Strings.

Unicode strings are just like regular strings, except in `C`, they need 
conversion from a conventional ASCII string. There are two types of conventions. 
The `UTF-8` convention reads encoding by `8` bits, so endianness is not an issue 
in this case, however, strings can have more than `1` byte. Some software will 
require a **magic number** to signal `utf-8` encoding, this magic number will 
usually by `ef bb bf`.

We also have the `utf-16` encoding. In this encoding scheme, characters are read 
by `16` bits, so endianness matters, and the magic number for indicating `utf-16`
encoding is `fe ff` \(big endian\) or `ff fe` \(little endian\). These magic 
numbers are also calle **Byte order Marks** or **BOMs** for short.
