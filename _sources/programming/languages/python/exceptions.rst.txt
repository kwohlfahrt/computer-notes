Exceptions
==========

Many Python operations can `throw` (or `raise`) an `exception`. This is a
notification that the operation could not be completed successfully. For
example, trying do index past the end of a list raises an ``IndexError``::

  >>> l = [1, 2, 3]
  >>> l[10]
  Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
  IndexError: list index out of range

Exceptions can be caught with a `try-except` block, and handled in a useful
fashion. Use of exceptions is considered good practice in Python. This consists
of a ``try`` block, one (or more) ``except`` blocks, and optional ``else`` and
``finally`` blocks.

At its most basic, we can simply check if an exception occurs, and then handle
it::

   >>> try:
   ...     item = l[10]
   ... except IndexError:
   ...     item = 1000
   ...
   >>> item
   1000

Multiple Exceptions
+++++++++++++++++++

We can check for multiple kinds of exceptions by placing them in a tuple, or
chaining multiple ``except`` statements::

  ... except (IndexError, ValueError):
  ...    ...  # Do something
  ... except TypeError:
  ...    ...  # Do something else

Omitting the exception entirely, or using ``Exception`` will catch any
exception. This is not recommended, as it might be a different exception than
what you expected when writing the handler!

Raising Exceptions
++++++++++++++++++

To create an exception, use the `raise` statement::

  >>> raise Exception()
  Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
  Exception

It is best to use the most specific kind of exception, defining your own if
necessary. This way, a user can catch this specific exception and handle it.
Error messages can help the user figure out what caused the problem::

  class Knight:
      def grenade(self, count):
          if count != 3:
              raise ValueError("Three shall be the number thou shalt count!")
          print("One... two... five... err, three!")

      def taunt(self, target):
          if target == "mother":
              print("Your mother was a hamster!")
          elif target == "father":
              print("Your father smelt of elderberries!")
          else:
              raise ValueError("Missing insult for target!")

      def say(self):
          print("Ni!")

The function will exit immediately after raising the exception, and any
following statements will not be executed::

  >>> knight = Knight()
  >>> knight.grenade(3)
  One... two... five... err, three!
  >>> knight.grenade(5)
  Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
  ValueError("Three shall be the number thou shalt count!")


Inspecting Exceptions
+++++++++++++++++++++

The properties of the exception object can be examined by binding it using
``as``::

  >>> try:
  ...     raise RuntimeError("Let this be a message!")
  ... except RuntimeError as e:
  ...     print(e.msg)
  ...
  Let this be a message!
  >>>

Else
++++

`try-except` blocks can also have an `else` component, which is only
run when no exception occurs. For example, consider the following::

  >>> tauntee = "mother"
  >>> try:
  ...     knight.grenade(3)
  ... except ValueError:
  ...     print("Oops")
  ... else:
  ...     knight.taunt(mother)
  ...
  One... two... five... err, three!
  Your mother was a hamster!
  >>>

If no exception is raised, it gives the same result as this::

  try:
      knight.grenade(3)
      knight.taunt(tauntee)
  except ValueError:
      print("Oops")

However, if ``tauntee`` had a different value (say ``"priest"``), the second
example would print::

  One... two... five... err, three!
  Oops

Whereas the first would result in::

  One... two... five... err, three!
  Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
  ValueError("Missing insult for target!")

Finally
+++++++

Finally, `try-except` blocks can have a `finally` statement, which always run
after all other statements::


  try:
      knight.grenade(count)
  finally:
      knight.say()

This will result in the knight always saying ``"Ni!"``, regardless of whether he
successfully throws the grenade.

.. Note:: :ref:`Context Managers <python-context-managers>` are often better
   suited for performing cleanup actions.
