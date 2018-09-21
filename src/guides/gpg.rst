GnuPG
=====

The `GNU Privacy Guard` is a program that implements the OpenPGP standard for
encrypting and signing messages.

OpenPGP
~~~~~~~

OpenPGP relies on asymmetric cryptography, where each key consists of a public
part and a private/secret part. Typically, one person will hold the private part
of a key, and send the public part to anybody he wants to communicate with (or
publish it for anybody to see).

For the possible actions with a key, see `Capabilities`_ below.

Limitations
-----------

.. _forward-secrecy:

OpenPGP's biggest limitation is currently the lack of `forward secrecy`.

Capabilities
------------

A primary key may have any of four capabilities:

encryption
  Encrypting a document with a public key makes it unreadable to everyone
  except the holder of the corresponding primary key.
signing
  The holder of a primary key can create a message signature showing that he
  wrote a message, and anybody with the corresponding public key can validate
  the signature.
authentication
  The holder of a primary key can prove his identity to anyone who knows the
  public key.
certification
  The primary key can be used to confirm the authenticity of another key, which
  can be validated with the corresponding public key.

Key Management
~~~~~~~~~~~~~~

The main burden of working with OpenPGP is having to manage keys (your own
private keys, and others' public keys).

Creation
--------

The first thing to do is generate a primary key, which contains information
about our identity and can certify other keys. We use ``expert`` mode to disable
all other key capabilities, as well as setting some `cryptography options <Key
Types_>`_), the `expiration <Expiry_>`_ and a `passphrase <Passphrases_>`_::

  > gpg --full-generate-key --expert
  gpg (GnuPG) 2.2.9; Copyright (C) 2018 Free Software Foundation, Inc.
  This is free software: you are free to change and redistribute it.
  There is NO WARRANTY, to the extent permitted by law.

  gpg: keybox '/home/john/.gnupg/pubring.kbx' created
  Please select what kind of key you want:
    (1) RSA and RSA (default)
    (2) DSA and Elgamal
    (3) DSA (sign only)
    (4) RSA (sign only)
    (7) DSA (set your own capabilities)
    (8) RSA (set your own capabilities)
    (9) ECC and ECC
    (10) ECC (sign only)
    (11) ECC (set your own capabilities)
    (13) Existing key
  Your selection? 8

  Possible actions for a RSA key: Sign Certify Encrypt Authenticate
  Current allowed actions: Sign Certify Encrypt

    (S) Toggle the sign capability
    (E) Toggle the encrypt capability
    (A) Toggle the authenticate capability
    (Q) Finished

  Your selection? S

  Possible actions for a RSA key: Sign Certify Encrypt Authenticate
  Current allowed actions: Certify Encrypt

    (S) Toggle the sign capability
    (E) Toggle the encrypt capability
    (A) Toggle the authenticate capability
    (Q) Finished

  Your selection? E

  Possible actions for a RSA key: Sign Certify Encrypt Authenticate
  Current allowed actions: Certify

    (S) Toggle the sign capability
    (E) Toggle the encrypt capability
    (A) Toggle the authenticate capability
    (Q) Finished

  Your selection? Q
  RSA keys may be between 1024 and 4096 bits long.
  What keysize do you want? (2048) 4096
  Requested keysize is 4096 bits
  Please specify how long the key should be valid.
          0 = key does not expire
        <n>  = key expires in n days
        <n>w = key expires in n weeks
        <n>m = key expires in n months
        <n>y = key expires in n years
  Key is valid for? (0) 1y
  Key expires at Tue  1 Jan 2019 00:00:00 UTC
  Is this correct? (y/N) y

  GnuPG needs to construct a user ID to identify your key.

  Real name: John Doe
  Email address: john@doe.example.com
  Comment: Personal
  You selected this USER-ID:
      "John Doe (Personal) <john@doe.example.com>"

  Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O
  We need to generate a lot of random bytes. It is a good idea to perform
  some other action (type on the keyboard, move the mouse, utilize the
  disks) during the prime generation; this gives the random number
  generator a better chance to gain enough entropy.
  gpg: /home/john/.gnupg/trustdb.gpg: trustdb created
  gpg: key BAF5C09917F3F46B marked as ultimately trusted
  gpg: directory '/home/john/.gnupg/openpgp-revocs.d' created
  gpg: revocation certificate stored as '/home/john/.gnupg/openpgp-revocs.d/B426DB6068B545E4F65FCBCABAF5C09917F3F46B.rev'
  public and secret key created and signed.

  pub   rsa4096 2018-09-20 [C] [expires: 2019-01-01]
        B426DB6068B545E4F65FCBCABAF5C09917F3F46B
  uid                      John Doe (Personal) <john@doe.example.com>

We can then print information about our key::

  > gpg --list-keys
  /home/john/.gnupg/pubring.kbx
  ------------------------------
  pub   rsa4096 2018-01-01 [C] [expires: 2019-01-01]
        B426DB6068B545E4F65FCBCABAF5C09917F3F46B
  uid           [ultimate] John Doe (Personal) <john@doe.example.com>

The primary key has the ID ``B426DB6068B545E4F65FCBCABAF5C09917F3F46B``, this
will be different for every key. It is a RSA key with 4096 bits, created on
2018-01-01, with the certification (``C``) capability only and expires on
2019-01-01. The key has one user ID (``uid``), that of John Doe, along with his
email address and a comment in parentheses. Finally, this identity is labelled
as `ultimately` trusted, since it was the one that created the key.

We can also view the corresponding primary key (note the first key is labelled
``sec`` instead of ``pub``)::

  > gpg --list-secret-keys
  /home/john/.gnupg/pubring.kbx
  ------------------------------
  sec   rsa4096 2018-01-01 [C] [expires: 2019-01-01]
        B426DB6068B545E4F65FCBCABAF5C09917F3F46B
  uid           [ultimate] John Doe (Personal) <john@doe.example.com>

Subkeys
.......

As our key only has the certification capability, it is only useful for
generating additional keys. We will first generate an additional sub-key with
the signing capability::

  > gpg --expert --edit-key B426DB6068B545E4F65FCBCABAF5C09917F3F46B
  gpg (GnuPG) 2.2.9; Copyright (C) 2018 Free Software Foundation, Inc.
  This is free software: you are free to change and redistribute it.
  There is NO WARRANTY, to the extent permitted by law.

  Secret key is available.

  sec  rsa4096/BAF5C09917F3F46B
      created: 2018-09-20  expires: 2019-09-20  usage: C
      trust: ultimate      validity: ultimate
  [ultimate] (1). John Doe (Personal) <john@doe.example.com>

  gpg> addkey
  Please select what kind of key you want:
    (3) DSA (sign only)
    (4) RSA (sign only)
    (5) Elgamal (encrypt only)
    (6) RSA (encrypt only)
    (7) DSA (set your own capabilities)
    (8) RSA (set your own capabilities)
    (10) ECC (sign only)
    (11) ECC (set your own capabilities)
    (12) ECC (encrypt only)
    (13) Existing key
  Your selection? 8

  Possible actions for a RSA key: Sign Encrypt Authenticate
  Current allowed actions: Sign Encrypt

    (S) Toggle the sign capability
    (E) Toggle the encrypt capability
    (A) Toggle the authenticate capability
    (Q) Finished

  Your selection? E

  Possible actions for a RSA key: Sign Encrypt Authenticate
  Current allowed actions: Sign

    (S) Toggle the sign capability
    (E) Toggle the encrypt capability
    (A) Toggle the authenticate capability
    (Q) Finished

  Your selection? Q
  RSA keys may be between 1024 and 4096 bits long.
  What keysize do you want? (2048) 2048
  Requested keysize is 2048 bits
  Please specify how long the key should be valid.
          0 = key does not expire
        <n>  = key expires in n days
        <n>w = key expires in n weeks
        <n>m = key expires in n months
        <n>y = key expires in n years
  Key is valid for? (0) 1y
  Key expires at Tue  1 Jan 2019 00:00:00 UTC
  Is this correct? (y/N) y
  Really create? (y/N) y
  We need to generate a lot of random bytes. It is a good idea to perform
  some other action (type on the keyboard, move the mouse, utilize the
  disks) during the prime generation; this gives the random number
  generator a better chance to gain enough entropy.

  sec  rsa4096/BAF5C09917F3F46B
      created: 2018-01-01  expires: 2019-01-01  usage: C
      trust: ultimate      validity: ultimate
  ssb  rsa2048/D287180B16DA7CE7
      created: 2018-01-01  expires: 2019-01-01  usage: S
  [ultimate] (1). John Doe (Personal) <john@doe.example.com>

  gpg> save

Note how the capabilities (S, E, and A) can be toggled individually. Repeat this
to create one sub-key with each capability. At the end of the process, you
should have one primary key and three sub-keys::

  > gpg --list-secret-keys
  /home/john/.gnupg/pubring.kbx
  -------------------------------------------------------
  sec   rsa4096 2018-01-01 [C] [expires: 2019-01-01]
        B426DB6068B545E4F65FCBCABAF5C09917F3F46B
  uid           [ultimate] John Doe (Personal) <john@doe.example.com>
  ssb   rsa2048 2018-01-01 [S] [expires: 2019-01-01]
  ssb   rsa2048 2018-01-01 [E] [expires: 2019-01-01]
  ssb   rsa2048 2018-01-01 [A] [expires: 2019-01-01]

Note the secret sub-keys are labelled ``ssb``, and each has a different
capability (``S``, ``E``, and ``A``).

Key types
.........

GPG supports many key types. For a beginner, the default types are fine (i.e.
2048-bit RSA), but for additional security a larger key can be used. Ecliptic
curve (ECC) based keys are also available.

Passphrases
...........

A key can also be encrypted with a passphrase. This is an additional layer of
protection as an attacker needs both the key and the passphrase to use it.

Expiry
------

A key can be created with an expiry date. This in itself does `not` provide
additional security - if an attacker has the certification secret key, they can
use it to modify the expiry date. However, it is useful if the original private
key is lost along with its `revokation certificate <Revocation_>`_, as no-one
will attempt to use it after the expiry date.

Revocation
----------

A compromised key should be `revoked` as soon as possible, to show it is no
longer secure. Anybody importing the revoked public key will then see that the
key is no longer in use. Revoking a key requires the corresponding certification
secret key. The revocation may also contain other information, such as the
reason for the revocation.

Certificates
............

As revocation requires the secret key, this poses a problem if the key needs to
be revoked because the private key is lost. The solution is to pre-generate a
`revocation certificate`, which can be used in place of the primary key (but
only for revocation). This happens by default during the key generation process.

.. warning:: An attacker with access to this certificate can make your key
   unusable, so this certificate should be considered secret until it is used.

.. _gnupg: https://gnupg.org
