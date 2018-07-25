Concepts
========

This document describes some concepts which are common to many programming
languages.

.. _escaping:

Escaping
++++++++

Escaping is a way of representing text which would otherwise be unrepresentable
in a specific format. This is usually achieved in one of two ways.

Escape Sequences
----------------

A special escape character (frequently ``\``) signals that the following
character has a special meaning. For example, to represent a double quote
(``"``) in a string delimited by double quotes, use the sequence ``\"``. In C
for example::

  int main(void) {
    char my_str[] = "This string contains a special character: \".";
    puts(my_str);
    return 0;
  }

This will print::

  This string contains a special character: ".

Of course, this means that ``\`` is itself a special character and must be
escaped as ``\\``. Other common escape sequences include ``\n`` for a new-line
and ``\t`` for a tab.

Doubling
--------

In some cases, a special character can be doubled instead of preceeding it with
an escape character. For example, Python's string formatting syntax uses curly
braces (``{}``) to substitute values:

  >>> "my name is: {}".format("John Doe")
  "my name is: John Doe"

This makes it difficult to include curly braces in a string::

  >>> "curly braces look like this: '{' and '}', and my name is: {}".format("John Doe")
  Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
  KeyError: "' and '"

Instead, they should be doubled::

  >>> "curly braces look like this: '{{' and '}}', and my name is: {}".format("John Doe")
  "curly braces look like this: '{' and '}', and my name is: John Doe

Using ``{{`` does not activate the formatting machinery, and is replaced with
``{`` in the final text (and similarly for ``}}``).

