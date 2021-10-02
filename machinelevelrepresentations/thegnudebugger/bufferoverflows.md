# Buffer Overflows.

**Buffer overflow** happens when a program writes an urestricted ammount of data
to a **buffer**, a contiguous space in memory) of a given size. If more data is
written to the buffer than is allowed, then the buffer **overflows**, and
adjacent memory is overwritten with the overflowed data. For example, this kind
of programming error happens when a programmer declares an array of, say, size $$16$$ 
but writes $$32$$ bytes to the array. Some languages prevent this kind of error
by provding automatic bounds checking, however `C` does not. `C` will not bother
to check if the array will be able to hold the ammount of data written to it,
which makes `C` programs vulnerable to buffer overflows, and requires that a
programmer be on the look out for these errors. Consider the following code. We
compile it and run it with a string of $$12$$ bytes.

```c
#include<string.h>
#include<stdio.h>

void copy(char*);

int main(int argc, char* argv[]){

    copy(argv[1]);

    printf("Program returned 0.\n");

    return 0;
}

void copy(char* str){
    char buffer[16];

    strcpy(buffer, str);
    printf("%s\n", buffer);

    return;
}
```

```bash
~/ccom4086/ > gcc -g -o vuln stringBufOver.c
~/ccom4086/ > ./vuln HelloWorld
HelloWorld
Program returned 0.
~/ccom4086/ >
```
 However, if we run it with a string of $$26$$ bytes, say, the entire English
 alphabet, we get a segmentation violation:

 ```bash
~/ccom4086/ >  ./vuln abcdefghijklmnopqrstuvwxyz
abcdefghijklmnopqrstuvwxyz
*** stack smashing detected ***: terminated
zsh: abort (core dumped)  ./vuln abcdefghijklmnopqrstuvwxyz
~/ccom4086/ >
 ```

In fact it tells us that it detected **stack smashing**, which occurs when we
overflow a buffer on the stack into the adjacent variables in the stack frame.
Notice that since we declare `buf` in `copy()` without declaring it `static`,
that it resides on the stack. In this case, we call this type of buffer overflow
a **stack based buffer overflow**.

Detecting stack smashing is a security feature implemented on modern compilers
that helps prevent buffer overflows. As soon as one is detected, the program is
terminated. This helps prevent hackers from exploiting the program. We can turn
this feature off with the `-fno-stack-protector` flag, compiling with this flag
and running `vuln` gives us:

```bash
~/ccom4086/ > gcc -g -fno-stack-protector -o vuln stringBufOver.c
~/ccom4086/ > ./vuln abcdefghijklmnopqrstuvwxyz
abcdefghijklmnopqrstuvwxyz
zsh: segmentation fault (core dumped)  ./vuln abcdefghijklmnopqrstuvwxyz
~/ccom4086/ >
```

Buffer overflows have been around since the early days of computers, and are a
classic vulnerability that hackers exploit to gain control over a program.
Despite their age, they still persist today and have allowed for the
exploitation of modern programs. The 2011 ![CVE-2011-1266](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2011-1266) 
vulnerability in the vector markup language (VML) for Internet Explorer was
cause by a buffer overflow vulnerability.

## Bounds Checking and Avoiding Buffer Overflows.
