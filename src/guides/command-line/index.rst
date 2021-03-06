.. _command-line-guide:

Command Line
============

The command-line, also known as console, terminal, or shell, is one way of
getting a computer to perform actions. It is often used as it is easier to
copy-and-paste a command than to remember a sequence of buttons or menu entries
to press. There are several different command-lines available, we will be using
`fish`_ for its simplicity (see the website for installation instructions).
Other shells include `Bash` and `Zsh`.

When you start up a terminal, you will see a command prompt where you can type
commands. For example, it may look like this::

  > 

or contain more information, like this::

  user@computer /some/folder>

To exit a shell, type ``exit``, or press ``Ctrl`` + ``d``, which signals the end
of input.

Commands
++++++++

The purpose of a command line is to allow the user to run commands, and see
their output. The first word typed at a command line is the command to run, and
any following words (separated by spaces) are known as `arguments`.

The output of running a command on its arguments will be printed to the screen
below, when you press `Enter` to run the command. For example, the ``echo``
command simply outputs its arguments and then exits::

  > echo some text
  some text
  >

To interrupt a running command, press ``Ctrl`` + ``c``::

  > sleep 1000
  ^C⏎
  >

Special Keys
------------

You can press the up- and down-arrows to go through your history of previous
commands. You can filter commands by typing something before pressing the
up-arrow, this will only show commands containing that text.

The ``Tab`` key attempts to auto-complete the current command or filename.
``Ctrl`` + ``f`` accepts a currently proposed completion.

Options
-------

Many commands allow options to modify their behaviour. How they are specified is
up to the program, to the command line they are all just arguments. There are
some common patterns that are often seen. We will use the ``ls`` command, which
lists the contents of folders as an example (see `Files & Folders`_ below)
Normally, ``ls`` lists the contents of the current directory::

  > ls
  notes.txt  pictures/

Options begin with one ``-`` for single-letter options, or two ``--`` for long
options. Most short options have a long equivalent. For example, to list hidden
files use the ``-A`` or ``--almost-all`` option::

  > ls -A
  notes.txt  pictures/  .secrets
  > ls --almost-all
  notes.txt  pictures/  .secrets

Or the ``-1`` to list one file per line::

  > ls -1
  notes.txt
  pictures/

Short options can usually be combined, long options must be stated separately::

  > ls -1A
  notes.txt
  pictures/
  .secrets

  > ls -1 --almost-all
  notes.txt
  pictures/
  .secrets

Some options take values, for example the ``--ignore`` or ``-I`` option. For
long options, the option and value may be separated with a ``=`` symbol::

  > ls -I notes.txt -1
  pictures/
  > ls --ignore notes.txt -1
  pictures/
  > ls --ignore=notes.txt -1
  pictures/

Most commands provide a ``--help`` option that describes their options and
arguments, and a manual page (``man some_command``) with more detailed
information.

Input
-----

Some commands will run, and then wait for input. For example, the ``tr``
(translate) command takes two arguments. It then replaces each letter occuring
in the first argument, with the corresponding letter in the second argument. For
example the input::

  > tr ef ab

Will produce no output. There will just be a blank line, where the user can
enter text to be processed. For example, entering::

  efrecedefre

will produce the output::

  abracadabra

And then wait for more input. To exit the program, use ``Ctrl`` + ``d`` to
signal the end of input, or ``Ctrl`` + ``c`` to interrupt it.

Pipes
~~~~~

The output of one program, can be used directly as the input of another with the
``|`` symbol, known as a `pipe`. For example::

  > echo efrecedefre | tr ef ab
  abracadabra

Output Redirection
~~~~~~~~~~~~~~~~~~

The output of a command can be stored in a file (see `Files & Folders`_ below)
with the ``>`` operator [#prompt_redirect]_. For example::

  > echo efrecedefre > gibberish.txt

The ``cat`` (concatenate) command prints the content of one or more files::

  > cat gibberish.txt
  efrecedefre 

Similarly, the contents of a file can be used as input to a command with the
``<`` operator::

  > tr ef ab < gibberish.txt 
  abracadabra

This is equivalent to ``cat gibberish.txt | tr ef ab``.

These can be combined::

  > tr ef ab < gibberish.txt > magic.txt
  > cat magic.txt
  abracadabra

Note the ``>`` operator overwrites the entire file::

  > echo first line > lines.txt
  > echo second line > lines.txt
  > cat lines.txt
  second line

If you want to append to the end of a file, the ``>>`` operator should be used
instead::

  > echo first line > lines.txt
  > echo second line >> lines.txt
  > cat lines.txt
  first line
  second line

Quoting
~~~~~~~

Because the shell interprets words separated by spaces as distinct arguments,
this can cause problems when they contains spaces - for example when you want to
read a file with spaces in its name::

  > cat file with spaces.txt
  cat: file: No such file or directory
  cat: with: No such file or directory
  cat: spaces.txt: No such file or directory

As you can see, it tries to open three separate files: ``file``, ``with``, and
``spaces.txt``. There are several ways to get the shell to treat the whole thing
as one argument, but the easiest to remember is by quoting::

  > cat "file with spaces.txt"

Single quotes also work: ``cat 'file with spaces.txt'``. Quotes can also be used
to include new-lines in a commands arguments::

  > echo "first line
  second line"
  first line
  second line

Escaping
~~~~~~~~

An alternative is to quoting is to `escape` special characters with a preceeding
backslash::

  > cat file\ with\ spaces.txt

New-lines can be inserted with the sequence ``\n`` and tabs with the sequence
``\t``::

  > echo first\tline\nsecond\tline
  first   line
  second  line

To include the literal sequence ``\n``, you can double-escape it or quote it::

  > echo \\n "\n"
  \n \n

Because the shell processes the arguments (including quoting and escaping)
before passing them on to the ``echo`` command, ``echo`` can be useful to test
whether a command is being interpreted correctly.

.. _files:

Files & Folders
+++++++++++++++

Files contain data, and are organized in folders (or directories). Often, the
distinction is made between text files, which can be printed directly to a
terminal, and binary files, which have to be opened in some other way.

.. note:: A Microsoft Word document is a binary file, not a text file.

   It contains information other than text, such as formatting and images, and
   so needs a specialized program to display its contents.

A path is a list of nested folders that define the location of a file. The
folders are separated by a ``/``: ``Pictures/Family/group_photo.jpg`` is a file
called ``group_photo.jpg``, in the folder ``Family``, which is in the folder
``Pictures``.

The ``pwd`` (print working directory) command prints the directory the shell is
currently working in. For example (for why the directory starts with a ``/``,
see `Disk Drives`_ below)::

  > pwd
  /home/user

The ``ls`` (list) command lists the contents of a directory. Folders will end
with a ``/``, and files of different types are often colored differently. For
example::

  > ls
  cat.jpg  Documents/  Mail/  notes.txt  Pictures/  Videos/

It is also possible to list the contents of a specific directory, for example
``ls Mail/`` will list the contents of the ``Mail`` directory.

The ``cd`` (change directory) command is used to change the working directory,
for example::

  > cd Pictures/Family
  > ls
  dad.jpg  group_photo.jpg  me.jpg  mum.jpg  puppy.jpg  sis.jpg

Some special names exist. ``.`` refers to the current directory, ``..`` refers
to the parent directory, ``../..`` refers to the parent directory of the parent,
and so on. ``~`` refers to the user's home directory, usually something like
``/home/user``.

Disk Drives
-----------

On Windows, paths start with the disk name. So a folder called ``documents`` on
the disk ``C:`` has the path ``C:/documents``. On Linux, there is a top-level
folder, called ``/`` which contains all other folders. The contents of disks can
be located anywhere (as defined by the system administrator).

This is achieved by definining `mount points` for each disk. The disk device
itself is located in the folder ``/dev`` (for devices), and begins with ``sd``
(for SCSI Disk). The first disk is then ``/dev/sda``, the second ``/dev/sdb``
and so on. Each disk contains one or more partitions, which are numbered. The
third partition on the second disk is then ``/dev/sdb3``. To view the contents
of a disk, it is `mounted` in a particular folder::

  mount /dev/sdb1 /mnt/my_usb/

Will make the contents of the partition ``sdb1`` visible in the folder
``/mnt/my_usb``. This is more flexible than the Windows scheme, but requires
some more set-up to get working.

Tools
+++++

There are some descriptions of helpful tools in the documents below.

.. toctree::
   :maxdepth: 1
   :glob:

   *

.. [#prompt_redirect] The fact that the same symbol is used for the prompt at the
   start of the line is purely coincidental.

.. _fish: https://fishshell.com
