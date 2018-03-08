.. _python-context-managers:

Context Managers
================

A good way of handling clean-up is by using `context managers`. This is
partially a replacement for `try-finally` blocks. A context is entered using a
`with-statement`, for example to read a file in a context::

  with open("filename.txt") as f:
      first_line = f.readline()
      second_line = f.readline()

When the context is exited, whether this is by completing the block or raising
an exception, the file will be closed. This is equivalent to::

  f = open("filename.txt")
  try:
    first_line = f.readline()
    second_line = f.readline()
  finally:
    f.close()

for completeness, this is also equivalent to::

  f = open("filename.txt)
  with f:
     ...

But this is rarely used.

Variable Binding
++++++++++++++++

You can bind multiple contexts in one statement::

  with open("filename.txt") as f1, open("other.png") as f2:
      ...

Or not bind::

  with open("filename.txt"):
      ...

The latter is not very useful in the case of files, as we have no way of
accessing the open file now.

Creating
++++++++

To create a class that can be used as a context manager, it must define
``__enter__`` and ``__exit__`` methods that are called when entering and exiting
the context respectively.

``__enter__`` takes only ``self`` as a parameter, while ``__exit__`` takes
``self``, ``exc_type``, ``exc_value``, and ``traceback``. The last three
describe the exception that caused the context to be exited, if there was no
exception they will be ``None``.

For example, a custom file-reader might look like this::

  class MyFile:
      def __init__(self, filename):
          self.filename = open(filename)

      def __enter__(self):
          self._handle = open(filename)

      def __exit__(self, exc_type, exc_value, traceback):
          self._handle.close()
