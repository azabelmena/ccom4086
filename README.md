# Introduction.

This introductory page goes through the class structure and operation, and also goes over the syllabus‌‌

## Class Orginization and Syllabus.‌ <a id="class-orginization-and-syllabus"></a>

‌

The class will be held online and through the platform moodle [https://online.uprrp.edu/course/view.php?id=52590](https://online.uprrp.edu/course/view.php?id=52590). The code of honor must also be validated.‌‌

All the material will be posted on moodle. Material will consist of videos, slides, and supplementary material.‌‌

The course meets on Tuesdays, and Thursdays from 08.30-09.50, and office hours are on Mondays and Thursdays from 14.00-16.00. The relevent meets link will be found in the class page on moodle as well.The meet links and the professor's email are ommitted for security.‌‌

### Course Components <a id="course-components"></a>

‌

* Participation - 10%
* Homeworks/quizes - 20%
* Intigrative assignments \(labs\) - 15%
* Independent study project - 20%
  * One individual project, one group project.

### Topics <a id="topics"></a>

‌

The main cours will go thorugh the follwoing topics in specific‌‌

* C programming
  * Numerical data types \(quizes\)

    Arrays and pointers

  * control structures
  * functions
* Introductory computer science
  * Binary numbers
  * Boolean algebra
  * logic circuits
  * computer systems and components.
* Assembly language and machine code \(quizes and lab\)
* processor architecture \(quizes and lab\)
* Memory heiarchy and I/O \(quiz\).

‌

The goal of this course is to acquire the knowledge necessary to understand computer architecture and design and orginization. Most architecture is related to computer orginization, which is how each hardware component is laid out in the computer. This include the CPU, the graphics card or GPU, and I/O devices. In essence a computer can be viewed as a wall with modules in which we can look at specific modules. This gives a systems perspective of the computer. We also have a different view that deals with how to program the system, which will involve machine language.‌‌

A computer system has many layers, which start with the transistors, to logic gates, and then to hardware. Computer architecture connects the hardware to the software, and consists of different architectures such as `x86` and `ARM`.‌‌

From the intstruction set architecture down is the computer hardware, and from machine code up is the software of the computer. The middleware, or firmware OS floats between maching code, assemble and programming language, and the application layer.‌The hardware layout of a typical computer.The levels of the computer starting from the application layer in software and going down to the transistors in hardware.‌

The computer consists of the following layers‌‌

* Application
* Programming language
* Assembly language
* Machine code
* Instruction set architecture
* Processor, Memory, and I/O
* Logic design
* Transistors
* Numerical representation and arithmetic
* Assembler and machine code.
* processor architecture
* Memory heiarchy and I/O

‌

Along with their applications and supplementary material.‌‌

The class will consist of quizes, labs and projects \(one group and one individual\).‌‌

### The Abstraction of Computer Science. <a id="the-abstraction-of-computer-science"></a>

levels of abstraction for computer architecture.‌

Most computer science courses focus on abstraction which is useful when planning out a project and not having to worry about specific details. It should be noted that abstraction still has limits, especially when it comes to finding bugs in certain programs, optimization of said programs, and the general need to understand the underlying structures of what you're working with.‌

## Useful outcomes <a id="useful-outcomes"></a>

‌

Some outcomes from this class will be that oe will become a more efficient programmer, who knows how to find bugs efficiently and optimize their code.‌‌

## The Great Reality <a id="the-great-reality"></a>

‌

ints are not integers, and floats are not real numbers. In general, in a language such as `C/C++`, multiplying two large numbers may produce a number too large \(or overflow\) producing an incorrect or answer, another thing is for floating point numbers, associativity fails, due to how the computer treats floating points.‌‌

For example, the equation:x^2 \geq 0x2≥0‌

is true for floating point number, however, for `int`s, it is not, if the integers are large enough they can produce overflow leading to a negative result. Take `40000*40000 = 160000`, which is true, but `50000*50000 = -1794967296` is false. Similarly, since associativity is not true for floating point numbers,\(x+y\)+x \neq x+\(y+z\)\(x+y\)+x≠x+\(y+z\)‌

And `(1e20+-1e20) = 3.140000` but `1e20+(-1e20+3.14) = 0.000000`.‌

### Computer Arithmetic <a id="computer-arithmetic"></a>

‌

Some thing to note about computer arithmetic is that no random values are generated, and the usual mathematical properties must be thrown out the window. As we have seen, associativity does not hold for floating point numbers, if we take the set of all possible arithmetic operations as a set over `int`s and over `float`s \(respectively\), we see that for an `int`, that the filed is obviouslt finite, because of overflow, moreover, they form a ring under the usual addition and multiplication. In terms of floats, what is most notable is that they satisfy the usual order relation on the reals.‌

### Assembly is important <a id="assembly-is-important"></a>

‌

One needs to know assembly language. You may not write assmebly language, but knowlege of it leads to‌‌

* high level language model breakdowns
* understanding and implementing optimization and understanding when programs become inefficient.
* implementing system software. The compiler has machine code as a targer, and the operating system mus manage the process state.
* Understanding, creating, and fighting malware. Most malware uses `x86` assmbly language to hit a broader scope of victims.
  * One of the most common attacks on computer concer Buffer overflow attacks, in where an attacker manipulates memory to exploit a system.

‌

### Random Access Memory \(RAM\) <a id="random-access-memory-ram"></a>

‌

RAM is an unphysical abstraction. For computer architecture it is important to know how memory is managed and allocated, and all applications on the computer rely on memory. In terms of programming, some of the most pernicous bugs have to do with memory referencing, which affect the time and space complexity of a given program.‌

Lastly, memory is not uniform, programs depend on virtual memory, and memory stored in the cache, and knowing how to adpat programs to these constraints can optimize them significantly.‌

Where does RAM come in? RAM is just another abstraction of memory, in which the memory is volitile, Read Only Memory \(ROM\) is another type of memory to be aware of. For the most part, most of the memory in a computer is RAM.‌

### Memory in C/C++ <a id="memory-in-c-c"></a>

‌

Unlike programming languages such as `java`, `ruby`, or `python`, `C/C++` does not hold your hand when it comes to memory. They do not offer memory protection, meaning it is easy to make out of bounds references, bad memory allocation on deletion, and invalid pointer. All these issues lead to bugs in a program that can be severe, affecting not only performance, but possibly even security \(buffer overflows\). To midigate this, on should knoow what possible affects will happen when allocating/freeing memory and to use a tool to detect errors \(a standard debugger\).‌

### Complexity <a id="complexity"></a>

‌

Complexity matters in a program, not just asymptotic complexit of an `O(n^2)` or `O(n)` algorithm, but the specific function is important. Constants in the formula may lead to improvements, or cost. This is useful to optimizing code.
=======
# Introduction
>>>>>>> 73da6de1560bcd7db8ba1509112f0ed5c7b02047

