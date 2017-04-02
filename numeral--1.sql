/*
Copyright (C) 2017 Christoph Berg

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
*/

-- type definition

CREATE TYPE zahl;

CREATE OR REPLACE FUNCTION zahl_in(cstring)
  RETURNS zahl
  AS '$libdir/numeral'
  LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION zahl_out(zahl)
  RETURNS cstring
  AS '$libdir/numeral'
  LANGUAGE C IMMUTABLE STRICT;

CREATE TYPE zahl (
	internallength = 8,
	input = zahl_in,
	output = zahl_out,
	passedbyvalue,
	alignment = double,
	category = 'N'
);

/* zahl is as good as bigint, make a cast */

CREATE CAST (zahl AS bigint)
	WITHOUT FUNCTION
	AS IMPLICIT;

/* steal bigint's operators */

CREATE FUNCTION int8pl(zahl, zahl)
	RETURNS zahl
	AS 'int8pl'
	LANGUAGE internal IMMUTABLE STRICT;

CREATE OPERATOR + (
	leftarg = zahl,
	rightarg = zahl,
	procedure = int8pl,
	commutator = +
);

CREATE FUNCTION int8mi(zahl, zahl)
	RETURNS zahl
	AS 'int8mi'
	LANGUAGE internal IMMUTABLE STRICT;

CREATE OPERATOR - (
	leftarg = zahl,
	rightarg = zahl,
	procedure = int8mi
);

CREATE FUNCTION int8um(zahl)
	RETURNS zahl
	AS 'int8um'
	LANGUAGE internal IMMUTABLE STRICT;

CREATE OPERATOR - (
	rightarg = zahl,
	procedure = int8um
);

CREATE FUNCTION int8mul(zahl, zahl)
	RETURNS zahl
	AS 'int8mul'
	LANGUAGE internal IMMUTABLE STRICT;

CREATE OPERATOR * (
	leftarg = zahl,
	rightarg = zahl,
	procedure = int8mul,
	commutator = *
);

CREATE FUNCTION int8div(zahl, zahl)
	RETURNS zahl
	AS 'int8div'
	LANGUAGE internal IMMUTABLE STRICT;

CREATE OPERATOR / (
	leftarg = zahl,
	rightarg = zahl,
	procedure = int8div
);

