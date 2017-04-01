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

#include "postgres.h"
#include "fmgr.h"

#include "numbers.h"

/* module initialization */

PG_MODULE_MAGIC;

void _PG_init(void);

void
_PG_init(void)
{
}

/* input and output */

char *yyerrstr; /* copy of error catched by yynumbererror() */

void yynumberserror (char *s);

void
yynumberserror (char *s)
{
	/* store error for later use in number_in */
	yyerrstr = pstrdup(s);
}

PG_FUNCTION_INFO_V1(zahl_in);

Datum
zahl_in (PG_FUNCTION_ARGS)
{
	char	*str = PG_GETARG_CSTRING(0);
	Zahl	 zahl;

	if (numbers_parse(str, &zahl) > 0)
		ereport(ERROR,
				(errcode(ERRCODE_INVALID_TEXT_REPRESENTATION),
				 errmsg("invalid input syntax for type numbers: \"%s\", %s",
					 str, yyerrstr)));

	PG_RETURN_INT64(zahl);
}

PG_FUNCTION_INFO_V1(zahl_out);

Datum
zahl_out(PG_FUNCTION_ARGS)
{
	Zahl	zahl = PG_GETARG_INT64(0);
	PG_RETURN_CSTRING(zahl_cstring(zahl));
}

