postgresql-numeral
==================
Christoph Berg <cb@df7cb.de>

**postgresql-numeral** provides numeric data types for PostgreSQL that use
numerals (words instead of digits) for input and output.

Data types:

* *numeral*: English numerals (one, two, three, four, ...), short scale (10⁹ = billion)
* *zahl*: German numerals (eins, zwei, drei, vier, ...), long scale (10⁹ = Milliarde)
* *roman*: Roman numerals (I, II, III, IV, ...)

Requires PostgreSQL >= 9.4 (currently up to 13) and Bison 3.

[![Build Status](https://travis-ci.org/df7cb/postgresql-numeral.svg?branch=master)](https://travis-ci.org/df7cb/postgresql-numeral)

Examples
--------

```
# SELECT 'thirty'::numeral + 'twelve'::numeral as sum;
    sum
───────────
 forty-two

# SELECT 'siebzehn'::zahl * 'dreiundzwanzig' AS "Produkt";
         Produkt
──────────────────────────
 dreihunderteinundneunzig

# SELECT 'MCMLV'::roman + 'II'::roman * 'XXX' AS futurum;
 futurum
─────────
 MMXV
```

Implementation
--------------

The data types are internally binary compatible to *bigint*. Casts to and from
bigint are defined (to bigint as *implicit*). The module does not implement
any operators but instead reuses the existing bigint operators. Effectively,
the data types behave like bigint, just with different input/output functions.

License
-------

Copyright (C) 2017, 2020 Christoph Berg

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
