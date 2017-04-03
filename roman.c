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
#include "numeral.h"

/* input and output */

char *yyerrstr; /* copy of error catched by yyromanerror() */

void yyromanerror (char *s);

void
yyromanerror (char *s)
{
	/* store error for later use in number_in */
	yyerrstr = pstrdup(s);
}

PG_FUNCTION_INFO_V1(roman_in);

Datum
roman_in (PG_FUNCTION_ARGS)
{
	char	*str = PG_GETARG_CSTRING(0);
	Roman	 roman;

	if (roman_parse(str, &roman) > 0)
		ereport(ERROR,
				(errcode(ERRCODE_INVALID_TEXT_REPRESENTATION),
				 errmsg("invalid input syntax for type roman: \"%s\", %s",
					 str, yyerrstr)));

	PG_RETURN_INT64(roman);
}

PG_FUNCTION_INFO_V1(roman_out);

Datum
roman_out(PG_FUNCTION_ARGS)
{
	Roman	roman = PG_GETARG_INT64(0);
	PG_RETURN_CSTRING(roman_cstring(roman));
}

/* format roman numerals */

static char *
romanize (Roman roman)
{
	int val[] = { 1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1 };
	char *rom[] = { "M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I" };
	char res[1000] = "";
	int i;

	for (i = 0; i < 13; i++) {
		while (val[i] <= roman) {
			strlcat(res, rom[i], 1000);
			roman -= val[i];
		}
	}

	return pstrdup(res);
}

const char *
roman_cstring (Roman roman)
{
	if (roman < 0) {
		return psprintf("minus %s", roman_cstring(-roman));
	} else if (roman == 0) {
		return "nulla";
	}

	return romanize(roman);
}
