Electronic circuits are used to compute boolean functions on bits, as well as
to store them in different kinds of memory. Most contemporary circuits present
bits as being either high, or low voltage values within a given trheshhold. A
binary `1` typically represents a value of around $$1.0 V$$, while a `0` is
around $$0.0 V$$. These voltages, and hence, the bits are transferred along
signal wires.

There are three major components required to implement a digital system:
**combinational logic** which computes functions on bits, **memory elements**
which store bits, and **clock signals** which regulate the updating of memory
elements.

Historically, hardware designers created circuit designs by drawing schematics
of logic circuits. Now, mostt designs are expressed with **hardware description
language** (**HCL**) which is a textual notation, similar to a programin
language, except that it is used to describe hardware structures and behaviors
instead of program behaviors. Common languages include Verilog, which has a
similar syntax to `C`, and VHDL which as a syntax similar to the `ada`
programming language (named after Ada Lovelace). HCLs were originally designed
to create simulations of digital circuits. In the 1980s, reserchers debeloped
**logic synthesis** programs that could generate circuit designs from HDL
descriptions; this has led to a number of commercial synthesis programs. We
notice that this shift of designing circuits by hand to designing them from
synthesized ones is akin to the shift of programming with assembly to
programming with high level languages.

HCL languages express only the control portions of hardware design, and have a
limited set of operations; in addition, they also lack modularity. Designing
the logic is the most dificult part of microprocessor design. By carefully
seperating, designing and testinc control logic, one can create a working
microporcessor with.

## Logic Gates.

Logic gates are the basic computing elements for digital circuits, much like
how prime numbers are the basic elements for building numbers. A logic gate
takes boolean value inputs and output boolean values. Hence, they can be viewed
as a function on boolean values; indeed, thats how they can be described.
