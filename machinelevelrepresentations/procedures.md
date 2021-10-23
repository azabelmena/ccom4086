## Procedures.

Porcedures provide a way to package code that implement functionality with
designated arguments and a return value. They can be called from different
points in the program. Well designed software use procedures as an abstraction
mechanism, that hide the details of implementation of the task, while providing
a clear and consise interface definition of what will be computed, and how the
procedure affects the program.

There are many different attributes that have to be handled when providing
support for preocedures at the machine level. Suppose, that a procedure `P`
calls a procedure `Q`; `Q` then executes, and returns back to `P`. These actions
involve the follwing mechanisms:

- Passing control
    - The program counter is set to the starting address of the code `Q` upon
      entry, and set then set to the address of `P` upon returning.

- Passing data
    - `P` must be able to provide one or more parameters to `Q`, and `Q` must be
      able to return a value back to `P`.

- Allocation of memory
    - `Q` may need to allocate space for local variables when it begins, and
      likewise free the memory used upon returning.

The `x86_64` implementations of procedures involve the combination of
instructions and conventions on how to set up machine resources using the stack.
Great effort is made to minimize the overhead when invoking the procedure. It
then follows what can be seen as a minimalist stratagy, implementing only
what is needed for the particular procedure.

We have already seen the stack, and how it relates to procedures, hence we will
not go over it here; instead one should refer to the relevent sections. We begin
the analysis with control transferring.

### Control Transfer.

### Data Transfer.

### Recursive Procedures.
