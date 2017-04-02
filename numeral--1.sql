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

CREATE FUNCTION zahleq(zahl, zahl) RETURNS boolean
	AS 'int8eq' LANGUAGE internal IMMUTABLE STRICT;

CREATE OPERATOR = (
	leftarg = zahl, rightarg = zahl,
	procedure = zahleq,
	commutator = =, negator = <>,
	restrict = eqsel, join = eqjoinsel,
	hashes, merges
);

CREATE FUNCTION zahlne(zahl, zahl) RETURNS boolean
	AS 'int8ne' LANGUAGE internal IMMUTABLE STRICT;

CREATE OPERATOR <> (
	leftarg = zahl, rightarg = zahl,
	procedure = zahlne,
	commutator = <>, negator = =,
	restrict = neqsel, join = neqjoinsel
);

CREATE FUNCTION zahllt(zahl, zahl) RETURNS boolean
	AS 'int8lt' LANGUAGE internal IMMUTABLE STRICT;

CREATE OPERATOR < (
	leftarg = zahl, rightarg = zahl,
	procedure = zahllt,
	commutator = >, negator = >=,
	restrict = scalarltsel, join = scalarltjoinsel
);

CREATE FUNCTION zahlgt(zahl, zahl) RETURNS boolean
	AS 'int8gt' LANGUAGE internal IMMUTABLE STRICT;

CREATE OPERATOR > (
	leftarg = zahl, rightarg = zahl,
	procedure = zahlgt,
	commutator = <, negator = <=,
	restrict = scalargtsel, join = scalargtjoinsel
);

CREATE FUNCTION zahlle(zahl, zahl) RETURNS boolean
	AS 'int8le' LANGUAGE internal IMMUTABLE STRICT;

CREATE OPERATOR <= (
	leftarg = zahl, rightarg = zahl,
	procedure = zahlle,
	commutator = >=, negator = >,
	restrict = scalarltsel, join = scalarltjoinsel
);

CREATE FUNCTION zahlge(zahl, zahl) RETURNS boolean
	AS 'int8ge' LANGUAGE internal IMMUTABLE STRICT;

CREATE OPERATOR >= (
	leftarg = zahl, rightarg = zahl,
	procedure = zahlge,
	commutator = <=, negator = <,
	restrict = scalargtsel, join = scalargtjoinsel
);


CREATE FUNCTION zahlmod(zahl, zahl) RETURNS zahl
	AS 'int8mod' LANGUAGE internal IMMUTABLE STRICT;

CREATE OPERATOR % (
	leftarg = zahl, rightarg = zahl,
	procedure = zahlmod
);

CREATE FUNCTION zahlpl(zahl, zahl) RETURNS zahl
	AS 'int8pl' LANGUAGE internal IMMUTABLE STRICT;

CREATE OPERATOR + (
	leftarg = zahl, rightarg = zahl,
	procedure = zahlpl,
	commutator = +
);

CREATE FUNCTION zahlmi(zahl, zahl) RETURNS zahl
	AS 'int8mi' LANGUAGE internal IMMUTABLE STRICT;

CREATE OPERATOR - (
	leftarg = zahl, rightarg = zahl,
	procedure = zahlmi
);

CREATE FUNCTION zahlmul(zahl, zahl) RETURNS zahl
	AS 'int8mul' LANGUAGE internal IMMUTABLE STRICT;

CREATE OPERATOR * (
	leftarg = zahl, rightarg = zahl,
	procedure = zahlmul,
	commutator = *
);

CREATE FUNCTION zahldiv(zahl, zahl) RETURNS zahl
	AS 'int8div' LANGUAGE internal IMMUTABLE STRICT;

CREATE OPERATOR / (
	leftarg = zahl, rightarg = zahl,
	procedure = zahldiv
);

CREATE FUNCTION zahland(zahl, zahl) RETURNS zahl
	AS 'int8and' LANGUAGE internal IMMUTABLE STRICT;

CREATE OPERATOR & (
	leftarg = zahl, rightarg = zahl,
	procedure = zahland,
	commutator = &
);

CREATE FUNCTION zahlor(zahl, zahl) RETURNS zahl
	AS 'int8or' LANGUAGE internal IMMUTABLE STRICT;

CREATE OPERATOR | (
	leftarg = zahl, rightarg = zahl,
	procedure = zahlor,
	commutator = |
);

CREATE FUNCTION zahlxor(zahl, zahl) RETURNS zahl
	AS 'int8xor' LANGUAGE internal IMMUTABLE STRICT;

CREATE OPERATOR # (
	leftarg = zahl, rightarg = zahl,
	procedure = zahlxor,
	commutator = #
);


CREATE FUNCTION zahlabs(zahl) RETURNS zahl
	AS 'int8abs' LANGUAGE internal IMMUTABLE STRICT;

CREATE OPERATOR @ (
	rightarg = zahl,
	procedure = zahlabs
);

CREATE FUNCTION zahlum(zahl) RETURNS zahl
	AS 'int8um' LANGUAGE internal IMMUTABLE STRICT;

CREATE OPERATOR - (
	rightarg = zahl,
	procedure = zahlum
);

CREATE FUNCTION zahlnot(zahl) RETURNS zahl
	AS 'int8not' LANGUAGE internal IMMUTABLE STRICT;

CREATE OPERATOR ~ (
	rightarg = zahl,
	procedure = zahlnot
);

CREATE FUNCTION zahlup(zahl) RETURNS zahl
	AS 'int8up' LANGUAGE internal IMMUTABLE STRICT;

CREATE OPERATOR + (
	rightarg = zahl,
	procedure = zahlup
);

