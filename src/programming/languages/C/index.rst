.. _c-guide:

C
=

C is considered a low-level programming language, in that it is similar to the
machine code executed by computers directly [#low-level]_. It does not offer as
many useful features as other languages, but it can be very fast and is
available on almost all platforms. Many higher level programming languages are
capable of interfacing with C code in some way, so it serves as a common
language for communicating between them.

Compiling
+++++++++

C does not offer a REPL (read-eval-print loop) like many other languages (e.g.
Python). This means that a whole program must be compiled and then run from the
:ref:`command-line <command-line-guide>`. For example, suppose we have the
following C program::

  #include <stdio.h>

  int main(int argc, char ** argv) {
    for (unsigned int i = 0; i < argc; i++){
      printf("%s ", argv[i]);
    }
    printf("\n");
    return 0;
  }

Most Linux distributions have ``cc`` available as a C compiler. OSX uses the
``clang`` comand instead. The following command compiles the file ``echo.c``
(containing the program above), and saves the result in a file called
``echo``::

  > cc -o echo echo.c

Now, we can run the resulting program, and the function called ``main`` will be
executed::

  > ./echo Hello, world!
  Hello, world!

Object Files
------------

A C compiler can also create `object files`. These contain C functions and data,
but do not define a function called ``main``. For example, the following file
(named ``greet.c``) defines a `function <Functions_>`_ named ``greet`` and a
`variable <Variables_>`_ named ``answer``::


  # include <stdio.h>

  int answer = 42;

  void greet(char * name) {
    printf("Hello %s!\n", name);
  }

As it does not define ``main``, it cannot be compiled to an executable. However,
we can use it to create an object file named ``greet.o``::

  > cc -c -o greet.o greet.c

This checks the file ``greet.c`` for any errors, and creates the object file
which can be re-used later if we want to use the defined function. This is a
useful way to try out some of the examples in this document.

Unspecified Behaviour
---------------------

In some cases, the result of an operation is not specified by the standard. In
some cases, the result is said to be `implementation-defined`. This means the
operation is correct and will not disrupt the program, but the exact result may
vary between different operating systems and compilers.

.. warning:: In other cases, the behaviour of a C program is `undefined` by the
   language standard. This may cause surprising and unexpected program
   behaviour, and must be avoided.

Variables
+++++++++

A variable is declared by stating its `type <Types_>`_, followed by its name::

  int i;

Multiple variables of the same type may be declared at the same time::

  int i, j;

.. attention:: Be careful when declaring multiple variables of `pointer
   <Pointers_>`_ type, ``int * i, j;`` is equivalent to ``int * i; int j``. The
   ``*`` must be repeated for each varaible: ``int *i, *j``

Assignment
----------

A variable may be assigned to, from another variable or a `literal <Literals_>`_
value. This maybe combined with the declaration::

  i = 3;
  int k = i;
  int j = 4, l = i;

.. warning:: Using an uninitialized variable (one that was never assigned to) is
   usually undefined behaviour.

Types
+++++

The data-types in C are very similar to what is used by a computer internally to
represent data, so some discussion of these is needed.

Integers
--------

Integers are the simplest data type, representing whole numbers.

Sizes
~~~~~

Integers come in various sizes, usually multiples of 8 bits. The values that can
be represented by an integer depend on its size. The number of values that can
be represented is :math:`2^{\mathrm{bits}}`. The traditional C types to
represent integers (``char``, ``short``, ``int`` and ``long``) have varying
sizes depending on the platform, so the modern versions are preferred. To use
them, you need to `include <Includes_>`_ the ``stdint.h`` header.

The basic integer types look like ``int8_t``, where ``8`` should be replaced
with the desired size in bits. There also exist ``int_fast8_t`` and
``int_least8_t``, which are the fastest and smallest types of at least 8 bits in
size respectively (and similarly for other sizes). `Unsigned <Signedness_>`_
types begin with ``uint`` instead of ``int``.

Signedness
~~~~~~~~~~

Integers may be signed, in which case they can represent negative numbers, or
unsigned, in which case they can only represent positive numbers. In the case of
signed integers, their available range is split in half; an 8-bit unsigned
integer can represent the numbers 0 to 255 (inclusive), while an 8-bit signed
integer can represent the numbers -128 to 127.

.. attention:: The result of assigning a value that a signed integer type cannot
   represent is implementation-defined.

Unsigned integers wrap when they overflow (e.g. for an 8-bit variable, ``255 + 1
== 0``).

.. warning:: Overflow of signed integers is undefined.

Enums
-----

Enumerations (or `enums`) are similar to integer types in that they represent
discrete values. However, the values they represent are chosen by the user. For
example, suppose we want to represent a list of available colors::

  enum Color {
    Red,
    Green,
    Blue,
  };

This defines an enum named ``enum Color``, with the values ``Red``, ``Green``
and ``Blue``. By default, enums are assigned sequential values beginning with
``0``, but they may also be explicitly assigned values::

  enum Color {
    Red = 2,
    Green,
    Blue = 4,
    Rouge = Red,
  };

If any enum member is not assigned a value, its value is the value of the member
above plus one. Any previously defined member can also be used as a value. A
variable of an enum type is declared like any other variable::

  enum Color my_color = Blue;

.. warning:: Assigning from integers to enums is possible, and may result in the
   enum containing invalid values.

Floats
------

Floating point numbers are a way to represent numbers with a fixed number of
significant figures over a large range. They consist of a sign bit, a
significand and an exponent. The final value is given by:

.. math::

   (-1)^{\mathrm{sign}} \times {\mathrm{significand}}
   \times 2^{\mathrm{exponent}}

They are commonly available in 32-bit (24-bit significand and 8-bit exponent)
and 64-bit (53-bit significand and 11-bit exponent) sizes, known as ``float``
and ``double`` respectively.

Pointers
--------

Pointers are references to locations in computer memory. They are represented by
a ``*`` after the type stored in the location they are pointing to (e.g.
``uint8_t*`` is a pointer to a ``uint8_t``). A special type ``void*`` also
exists, which is a pointer to general-purpose memory of no specific type. To get
a pointer to a value, add a ``&`` in front of the value::

  int x = 4;
  int* x_ptr = &x;

To get the pointed-to value, use ``*`` in front of the pointer. For example, the
following assigns the value of ``x`` to ``y``::

  int y = *x_ptr;

Pointers are often used to represent `arrays <Arrays_>`_ by taking a pointer to
the first element. As arrays are stored contiguously in memory, the second
element can be accessed by simply incrementing the pointer, and so on for
further elements.

.. warning:: Pointers do not store any information about the length of an array,
   and reading or writing to memory past the end of an array is undefined
   behaviour.

Strings
~~~~~~~

In many cases, strings (i.e. text) are represented by a pointer to the first
element of an `array <Arrays_>`_ of ``char``. The end of the string is marked by
the special character ``NULL``. This gives flexibility in that the length of the
string can vary.

.. warning:: Ensure the trailing ``NULL`` is present to avoid undefined
   behaviour by accidentally accessing values beyond the end of the string.


Compound Types
--------------

These base types can be assembled into compound types.

Arrays
~~~~~~

Arrays are the simplest kind of compound type, and simply consist of a type
repeated several times in memory. For example, an array of 3 ``float`` values
may be used to describe a point::

  float point[3];

The three values are stored consecutively in memory, which means that a pointer
to the second element in the array (``&point[1]``) is one greater than a pointer
to the first element in the array (``&point[0]``).

Arrays can be initialised all at once::

  float point[3] = {1.0, 2.0, 5.0};

If some elements are missing, they are filled with zeros.

To access a value at some position in an array, square brackets are used::

  float x = point[0], y = point[1], z = point[2];

Arrays behave much like pointers, and can be freely converted to pointers::

  float *point_ptr = point;

In fact, ``point[i]`` is the same as ``*(point_ptr + i)``.

Structs
~~~~~~~

Structures (or `structs`) are types containing fields, each containing another
type. For example, information about a train might be represented by::

  struct Train {
    uint16_t num_carriages;
    float speed;
    char* model;
  };

In this case, the struct named ``struct Train`` has three members,
``num_carriages`` of type ``uint16_t``, ``speed`` of type ``float`` and the
string ``model``.

Struct members can also be initialised together::

  struct Train my_train = {
    .num_carriages = 4,
    .speed = 70.0,
    .model = "TGV",
  }

A member of a struct can be accessed with the ``.`` operator::

  my_train.speed = 75.0
  float travel_time = 25.5 / my_train.speed;

Unions
~~~~~~

A union looks similar to the struct, but only one of its members may be defined
at a time. For example, if a user is represented by a unique ID or his name,
this could be defined as a union::

  union User {
    uint32_t id;
    char * name;
  }

Members of a union can be initialised and accessed like members of a struct.
Note that if a different member is used to read than to store, the resulting
value may not contain valid information. For example::

  union User u = {.name = "Some name"};
  uint32_t id = u.id;

In this case, ``id`` contains the address of ``"Some name"``, interpreted as an
integer. This is probably not a valid user id. A common solution is to create a
tagged union, i.e. a struct containing a union, and an enum to specify which
union member is in use::

  enum UserType {
    Type_Number,
    Type_Name,
  };

  struct UserInfo {
    enum UserType ty;
    union User data;
  };

  struct UserInfo my_user = {
    .type = Number,
    .data.id = 1234,
  };

Anonymous Types
---------------

Types like unions or enums don't have to be assigned a name, if they are only
used once. For example, the ``struct UserInfo`` above could be declared more
compactly as::

  struct UserInfo {
    enum {Number, Name} ty;
    union {uint32_t id; char *name} data;
  };

Functions
+++++++++

The main way of re-using code in C is by defining functions. In fact, the only
things allowed outside of a function are type declarations, variable
declarations and assignments of constant values. A function takes a number of
parameters, executes some code and returns a value as output. It may also have
side-effects such as writing to memory or printing some output.

Declaring
---------

A function is declared (i.e. its type, or signature specified) by writing its
return type, followed by its name, followed by the types of its parameters in
parentheses and separated by commas::

  float add(float, float);

It is common to specify the names of its parameters as well::

  float add(float x, float y);

A function must be declared before it can be used in other code. This does not
require writing the code for the function, only its return type and parameters.

Definition
----------

At some point, a function must be defined. This starts the same way as a
declaration, but is followed by the code executed in a `block <Blocks_>`_::

  float add(float x, float y) {
    float sum = x + y;
    return sum;
  }

The function exits when it reaches a ``return`` statement, and returns the value
given.

Calling
-------

A function is called by writing its name, followed by the values for its
parameters in parentheses. A function call evaluates to the return value of a
function::

  float x = add(1.4, 2.3);

The value of ``x`` is now ``3.7``.

Side-effects
------------

A common pattern is to use pointer parameters to return values::

  uint32_t divide(uint32_t x, uint32_t y, uint32_t *remainder) {
    *remainder = x % y;
    return x / y;
  }

Now the function could be used as follows::

    uint32_t remainder;
    uint32_t quotient = divide(5, 2, &remainder);

The fact that the value of ``remainder`` changes when the function is executed
is known as a side-effect. Another common side-effect is writing or reading data
from a file.

Control Flow
++++++++++++

It is often necessary to execute different code depending on input values (or
execute the same code a different number of times). This is made possible by
``if``, ``for``, and ``while`` conditions.

If
--

If statements will execute the following statement or block if their condition
evaluates to a value other than zero. An if-statement begins with the word
``if``, followed by the condition surrounded by parentheses, and then the code
to be conditionally executed::

  if (x > 0)
    x += 1;

will only increase ``x`` if it is already greater than zero. Additional code
that is only executed if the condition is false (i.e. zero) can also be given,
after the ``else`` keyword::

  if (x > 0)
    x += 1;
  else
    x = 0;

Multiple statements can be grouped by enclosing them in a block::

  if (x > 0) {
    x += 1;
    y = 3;
  }

This can be useful to make one-line if-statements clearer.

Multiple conditions can be tested by simply adding a second if-statement as the
``else`` block::

  if (x > 0) {
    x += 1;
  } else if (x < 0) {
    x -= 1;
  } else {
    x = 0;
  }

While
-----

A while loop executes the contained block multiple times, as long as its
condition is true::

  int x = 0, y = 3;
  while (x < 4) {
    y = y - 1;
    x = x + 1;
  }

After this code runs, the values of ``x`` and ``y`` are ``4`` and ``-1``
respectively.

Similar is the do-while loop, which evaluates its condition after executing the
loop::

  int x = 5, y = 3;
  do {
    y = y - 1;
    x = x + 1;
  } while (x < 4);

In this case, the code is still executed once even though the condition is never
true, so the values of ``x`` and ``y`` are ``6`` and ``2`` respectively.

For
---

A for-loop is very similar to a while loop, except that it allows the
declaration, testing, and modification of loop variables in one place. This can
often make the code more organised than the equivalent while-loop::

  int y = 3
  for (int x = 0; x < 4; x++) {
    y = y - 1;
  }

The ``for`` keyword is followed by a loop initialisation, a loop condition and a
loop increment. The initialisation statement is executed before the loop starts.
The condition is tested before every loop iteration, and the increment is run
after every loop iteration. This prevents the variable used to track the loop
from being available afterwards (i.e. in this example, ``x`` cannot be used
outside the body of the loop).

Break & Continue
----------------

The statements ``break;`` and ``continue;`` can be used in a loop. ``break``
exits the loop immediately. ``continue`` skips the remainder of the current loop
iteration.

Program Structure
+++++++++++++++++

Constructs which will show up frequently below are expressions, statements, and
blocks.

Expressions
-----------

Expressions are fragments of code that evaluate to a value. They may be
`variables <Variables_>`_ (``x``), `function <Functions_>`_ evaluations
(``add(x, y)``), `operator <Operators_>`_ evaluations (``x + 2``) or `literals
<Literals_>`_ (``4``). Assignment of a value to a variable is also an
expression, and returns the value being assigned (``x = 2`` evaluates to ``2``).

The comma (``,``) can be used to evaluate multiple expressions where only one is
expected. All expressions will be evaluated, but only the last one will be
returned. For example, ``x = (puts("foo"), 2, 3)`` will assign ``3`` to ``x``.
The fact that all expressions are evaluated is important because any
side-effects will be observed, in this case ``foo`` will be printed.

Statements
----------

Statements in contrast, do not return values. Every statement is terminated by a
semi-colon ``;``.

Blocks
------

Blocks are groups of statements, surrounded by curly braces ``{}``.

Literals
++++++++

A literal is a value defined in the source code of the program.

Numbers
-------

Several kind of numbers are supported.

Integers
~~~~~~~~

Integers (whole numbers) can be written in decimal form (``23``). The integer
will be sized such that the number can be represented. The suffix ``u`` can be
added to specify that the number is `unsigned`. ``l`` or ``ll`` can be added to
specify the number should be at least the size of a ``long`` or ``long long``
integer respectively.

Floats
~~~~~~

Floats, or floating precision numbers are decimals with a specific number of
significant figures (``1.4``). Values are double-precision floats, unless the
specifier ``f`` is appended to specify single-precision.

Characters
~~~~~~~~~~

Characters are single letters enclosed in single quotation marks (``'a'``).

.. note:: some complex characters, e.g. ``ü``, are actually composed of a
   character and a modifier drawn in one space, so do not count as C characters.

Strings
~~~~~~~

Strings are sequences of characters, terminated with the character `null`
(written ``'\0'``). Literal strings can be included as text between double
quotes (e.g. ``"hello!"``), this automatically appends the trailing null.

Memory
++++++

C programs assume that the computer has a linear, continuous range of memory
available. This is split into three sections - constant, stack and heap memory.

Printing
++++++++

Due to the lack of a REPL, it is very useful to be able to print the contents of
a variable in C. This is done with the ``printf`` `function <Functions_>`_. The
first argument to this function is the `format string`, specially formatted text
that will define how the variables are printed. Every instance of ``%``,
followed by a letter, will be replaced by the value of a variable from the
remaining arguments. The letter used depends on the type of the variable.

=================== ==========================================================
Format code         Variable type
=================== ==========================================================
``d``, ``i``        Signed integer, formatted as decimal
``u``, ``o``, ``x`` Unsigned signed integer, formatted as decimal, octal or
                    hexadecimal
``c``               single character
``s``               null-terminated string
``p``               pointer
``f``               floating-point value in normal notation
``e``               floating-point value in scientific notation
``g``               floating-point value in normal or scientific notation, as
                    appropriate for its magnitude
=================== ==========================================================

For example, the variables below::

  char s[] = "foobar";
  unsigned int i = 3;
  int j = 4;
  float k = 5.0;

Could be used as follows in a ``printf`` call::

  printf("printed: %s %d %u %f '%c' %p\n", s, i, j, k, s[2], &j);

This would output::

  printed: foobar 3 4 5.0 'o' 0x7ffe4517656c

Note that arbitrary characters can be mixed in with the format codes. Also, to
print a newline, the ``\n`` `escape` is used. Other characters that may be
escaped are tabs (``\t``), quotes (``\"``) and backslashes (``\\``). To print a
percent sign, double it (``%%``).

Additionally, integer format codes may be preceeded by a length specifier, that
specifies the size of the argument (if omitted, it is assumed to be the size of
an ``int``).

=========== =============
Length code Size
=========== =============
``hh``      ``char``
``h``       ``short``
``l``       ``long``
``ll``      ``long long``
``z``       ``size_t``
``t``       ``ptrdiff_t``
=========== =============

Floating point values allow the ``L`` length code for ``long double`` values.

Operators
+++++++++

C includes the usual arithmetic operators, ``+``, ``-``, ``*`` and ``/`` for
addition, subtraction, multiplication and division.

Comparison operators are ``==`` and ``!=`` for equals and not-equals

Preprocessor
++++++++++++

Comments
--------

Comments exist in two forms, line comments and block comments. Any text after
``//`` until the end of the line is removed by the preprocessor. Similarly, any
text after the characters ``/*`` is removed until the next occurence of ``*/``.

Defines
-------

A ``#define`` directive or macro can be used to replace a particular bit of
source code before compiling. The syntax is ``#define PATTERN REPLACEMENT`` -
every instance of ``PATTERN`` will become ``REPLACEMENT`` before compiling.
Macros are often written in uppercase.

For example, the following C produces the same as ``int f = 2 + 3;``::

  #define FIVE (2 + 3)
  int f = FIVE;

.. note:: It is good practice to put parentheses around all macro definitions,
   imagine if we had written ``f = 4 * FIVE;`` - this would give the wrong
   result without parentheses.

A macro can also be declared with arguments, that can then be used on the right
hand side. For example, we can define a macro to add two numbers::

  #define MUL(x, y) ((x) * (y))

This can be used like a function, but it actually replaces the source code
before compiling.

.. note:: The parentheses might look excessive, but they are all necessary.
   Consider the expansion of ``MUL(1 + 2, 3 + 4)`` to ``((1 + 2) * (3 + 4))``,
   omitting any of the parentheses might change the meaning.

Conditional Compilation
-----------------------

The preprocessor can be used to select between two different segments of code
while compiling. This can be used to switch depending on a compile-time option,
or based on information about the current system.

This is done with ``#if``, ``#else``, ``#elif``, and ``#endif`` directives.

The if-condition may use numbers, arithmetic operators, other macros and the
special operator ``defined`` that checks whether a macro has been defined for a
particular pattern. ``#ifdef`` is short for ``#if defined``.

For example, to use different code on Windows and Linux, it is common to see::

  #if defined _WIN64
  // Windows code here
  #elif defined __linux__
  // Linux code here
  #else
  #error "Unsupported operating system!"
  #endif

The special macros ``_WIN64`` and ``__linux__`` are defined by the compiler
depending on the operating system in use.

Includes
--------

Other files can be included by the processor with the ``#include`` directive.

For example the line ``#include "./file.h"`` is replaced by the contents of the
file ``./file.h``. If the path is surrounded by quotes (``"./file.h"``), the
compiler searches in the directory of the current file and then in the
compiler-specified folders. If the path is surrounded by angle brackets
(``<file.h>``), only the compiler-specified folders are searched.

Guards
~~~~~~

Including a file more than once can be a problem. There are two common patterns
to avoid this. The first is the use of ``#ifdef`` guards::

  #ifndef _HAVE_FILE_H
  #define _HAVE_FILE_H
  // Code here...
  #endif // _HAVE_FILE_H

The macro name generally matches the filename, and must be unique to every
included file.

A non-standard, but commonly supported extension is the directive ``#pragma
once`` in a file, which has the same effect without defining a macro.

.. [#low-level] C does hide many details of computer hardware, such as the
   multiple levels of caching of memory. It is still lower level than most other
   languages.

.. [#nostd] Technically, it is the ``_start`` function. However, most C programs
   use the standard library, which implements that function for you.
