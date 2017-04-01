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
  AS '$libdir/numbers'
  LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION zahl_out(zahl)
  RETURNS cstring
  AS '$libdir/numbers'
  LANGUAGE C IMMUTABLE STRICT;

CREATE TYPE zahl (
	internallength = 8,
	input = zahl_in,
	output = zahl_out,
	passedbyvalue,
	alignment = double,
	category = 'N'
);

CREATE CAST (zahl AS bigint)
	WITHOUT FUNCTION
	AS IMPLICIT;
