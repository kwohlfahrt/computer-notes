Functional Programming
======================

Python provides several functional-programming features. These are often
particularly useful when paired with generators.

Lambdas
+++++++

`lambdas` are short, anonymous functions. They may consist of one expression,
and look like this::

  lambda <args>: <expression>

This defines an anonymous (i.e. not bound to a name) function with some
parameters that evaluates to an expression using those parameters. For example::

  lambda x, y: x + y

Defines an anonymous function of two parameters that returns their sum.

An example of when a lambda is useful is when a function takes another function
as an argument, for example ``map``. This applies the first argument to every
element of an iterable::

  >>> list(map(lambda x: x + 2, [1, 2, 3]))
  [3, 4, 5]

This is equivalent to the following, but shorter::

  >>> def add_one(x):
  ...     return x + 1
  ...
  >>> list(map(add_one, [1, 2, 3]))

Closures
++++++++

Any functions (including `lambdas <Lambdas_>`_) may refer to any variables
defined in their environment. This is known as a closure::

  x = 4
  def add_x_to(y):
      return y + x

Note that ``x`` is defined outside ``y``, but is still used in the body of the
function. This binds ``x`` by name, so if we assign a different value to it, the
output will change::

  >>> add_x_to(3)
  7
  >>> x = 5
  >>> add_x_to(3)
  8

.. todo:: nonlocal scope
