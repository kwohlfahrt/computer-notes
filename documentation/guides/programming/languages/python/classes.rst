Classes
=======

Every object is an `instance` of a `class`. Which class an object belongs to can
be discovered with the ``type`` function::

  >>> type(1.0)
  <class 'float'>

Instantiation
-------------

Creating an object which is an instance of the class is known as `instantiating`
the class. This is done by calling it like a function, for example the built-in
``int`` class is used for integers::

  >>> int()
  0

For some classes, parameters can be provided to modify the created object::

  >>> int("101", base=2)
  5

Definition
----------

A new class can be defined with the ``class`` keyword, followed by the
`attributes` and `methods` of the class::

  class Dog:
      ...

Attributes
----------

Attributes of a class are just like variables, except they belong to the class::

  class Dog:
      sound = "woof"

  >>> sound
  Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
  NameError: name 'sound' is not defined
  >>> Dog.sound
  'woof'

Note attributes of a class are distinct from attributes on an object. If an
attribute of an object has not been assigned a value, it will use the value of
the same attribute with the same name on the class::

  >>> rex = Dog()
  >>> rex.sound
  'woof'

However, modifying the attribute on the object does not affect the attribute of
the class::

  >>> rex.sound = "wuff"  # Rex is German
  >>> rex.sound
  'wuff'
  >>> Dog.sound
  'woof'

Methods
-------

Methods of a class are just like functions, except they are always passed the
object itself as the first parameter. This is traditionally called ``self``, but
any name will do::

  class Dog:
      sound = "woof"

      def bark(self):
          print(self.sound)

      def poke(self, intensity=5):
          self.sound = "g" + "r" * intensity

      def pat(self):
          self.sound = Dog.sound

``pat`` could have been defined as::

  def pat(puppy):
      puppy.sound = Dog.sound

Use ``self`` where possible, as it is usually less confusing.

Methods may modify the state of their object, by writing to the attributes of
``self``::

  >>> rex.poke(intensity=3)
  >>> rex.bark()
  grrr
  >>> rex.pat()
  >>> rex.bark()
  woof

Methods of an object are knows as `bound methods`, as the first parameter is
fixed. The function can be also used directly from the class, but the parameter
must then be passed explicitly::

  >>> Dog.bark(rex)
  woof
