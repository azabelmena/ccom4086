The microprocessor is among the most complex systems ever created. A single
silicon schip on the scale of nanometers contains several high performance
processors, memory caches, and the logic required to interface to external
devices. The processors today implemented on a single chip vastly outcompete
the room-size supercomputers that were used just decades ago. The
microprocssors found in the smart phones in 2021, already dwarf the ones used
in the Apollo moon missions.

At the machine language level, the processor mus execute a sequence of
instructions, each of which computes a primitive operation like adding. Each of
these instructions is encoded as a binary stream, i.e. a bit vector. Not all
these binary encodings are supported the same way, one binary encoding for
`x86_64` may not translate over to `ARM` architecture, it necessarily doesn't
even transfer over to `x86_32` evem! The instructions supported by a prticular
architecture, and how they are encoded at the byte level is called the
**instruction set architeccture** (**ISA**). Different families of
architectures have different instruction set architecture (we''l refer to these
as ISAs from now on), so the ISA shared by the `x86` family is not the same as
those shared by the `IA32` or the `IBM/Freescale Power` architectures. So, a
program compiled, for example, the `Freescale Power` architecture will not
run on any processor from the `x86` family.

ISAs can even differ within the same family. The `x86_64` architecture is backwards
compatibly with `x86_32`, but not the other way around, so the ISA for `x86_64` will not
work with `x86_32` in all cases. Manufacturers also produce processors of every
growing complexity; however, despite this, each model remains the same at the
ISA level. Popular architectures (see `x86`) have processors supplied by
multiple manufacturers, and so they attain a cross platform compatibility, as
opposed to something like `ARM`, which is majorily used for smart phones.

The ISA provides a level of abstraction between compiler writers, who need to
know what instructions are permitted, which ones aren't, and how each of those
instructions are encoded at the binary level. Porcessor designers also benefit
from this abstraction since they have to build the processors that execute
those instructions.

A modern processor operates quite differently from the computations that the
ISA implies. The ISA model implies a **sequential** instruction execution,
where each instruction follows the *fetch-decode-execute* cycle. However,
processors can leverage this by computing multiple instructions *in parallel*
(more on that later), and they can hence achieve a higher level of performance
than can be achieved from the ISA alone. Special mechanisms are provided so
that they can produce the same results as if they were computed sequentially.

Processor design embodies many of the principles of good engineering practie.
It requires ceating simple and regular models for performing complex tasks.
Similarly, understanding processors als deepens the understanding of how
computers work. It is no longer the black box one considered it when taking
stock programming and data structures course.

It also pays to understand these topics, as even though few people actually
work in designing processors, many people design the hardware that the
processor goes into and interacts with; understanding the processor design is
curcial then to building hardware that interacts with it efficiently and
squeezes the most out of the processor. Now processors are embedded into not
just desktop/laptop and server computers, but also cars and home appliances.

Instead of working with the `x86_64` ISA, which can be complex, we will instead
view an ISA called `Y86_64`, which was inspired by `x86_64`. This ISA, has
fewer data types, instructions, and addressing modes; it also has a relatively
simple byte encoding for instructions, which makes the machine code less
compact, while also making the CPU logic easier to design. The `Y86_64` ISA
while being simple will also allow us to design programs that can manipulate
integer data. We can also gain an appreciation for processor designers as
designing a system using `Y86_64` will present us with the hurtles that
processor designers face.
