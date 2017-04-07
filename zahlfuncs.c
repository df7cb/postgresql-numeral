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

char *yyerrstr; /* copy of error catched by yyzahlerror() */

void yyzahlerror (char *s);

void
yyzahlerror (char *s)
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

	if (zahl_parse(str, &zahl) > 0)
		ereport(ERROR,
				(errcode(ERRCODE_INVALID_TEXT_REPRESENTATION),
				 errmsg("invalid input syntax for type zahl: \"%s\", %s",
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

/* format German numerals */

static const char *zahl_one[] = {
	"",
	"eins", /* einhunderteins */
	"zwei",
	"drei",
	"vier",
	"fünf",
	"sechs",
	"sieben",
	"acht",
	"neun",
	"zehn",
	"elf",
	"zwölf",
	"dreizehn",
	"vierzehn",
	"fünfzehn",
	"sechzehn",
	"siebzehn",
	"achtzehn",
	"neunzehn",
};

static const char *zahl_ten[] = {
	"",
	"zehn",
	"zwanzig",
	"dreißig",
	"vierzig",
	"fünfzig",
	"sechzig",
	"siebzig",
	"achtzig",
	"neunzig",
};

static const char *
zahl_x (Zahl zahl, const char *eins)
{
	Assert (zahl >= 0 && zahl < 20);
	if (zahl == 1)
		return eins;
	return zahl_one[zahl];
}

static const char *
zahl_xx (Zahl zahl, const char *eins)
{
	if (zahl < 20) {
		return zahl_x(zahl, eins); /* returns empty for 0 */
	}
	if (zahl % 10 == 0)
		return zahl_ten[zahl / 10];
	return psprintf("%sund%s",
			zahl_x(zahl % 10, "ein"),
			zahl_ten[zahl / 10]);
}

static const char *
zahl_xxx (Zahl zahl, const char *eins)
{
	if (zahl < 100)
		return zahl_xx(zahl, eins);
	return psprintf("%shundert%s",
			zahl_x(zahl / 100, "ein"),
			zahl_xx(zahl % 100, eins));
}

static const char *
zahl_xxxxxx (Zahl zahl)
{
	if (zahl < 1000)
		return zahl_xxx(zahl, "eins");
	return psprintf("%stausend%s",
			zahl_xxx(zahl / 1000, "ein"),
			zahl_xxx(zahl % 1000, "eins"));
}

struct zillions {
	long long value;
	const char *name1;
	const char *name2;
} static zillions[] = {
	{ 1000000000000000000, "Trillion",  "Trillionen" },
	{    1000000000000000, "Billiarde", "Billiarden" },
	{       1000000000000, "Billion",   "Billionen"  },
	{          1000000000, "Milliarde", "Milliarden" },
	{             1000000, "Million",   "Millionen"  },
	{                   0                            },
};

static const char *
zahl_zillion (Zahl zahl)
{
	struct zillions *z;
	char *result = palloc0(1000);

	for (z = zillions; z->value; z++)
		if (zahl >= z->value) {
			int n = zahl / z->value;
			if (*result)
				strlcat (result, " ", 1000);
			strlcat (result, zahl_xxx(n, "eine"), 1000);
			strlcat (result, " ", 1000);
			if (n == 1)
				strlcat (result, z->name1, 1000);
			else
				strlcat (result, z->name2, 1000);
			zahl = zahl % z->value;
		}

	if (zahl > 0) {
		if (*result)
			strlcat (result, " ", 1000);
		strlcat (result, zahl_xxxxxx(zahl), 1000);
	}

	return result;
}

const char *
zahl_cstring (Zahl zahl)
{
	if (zahl < 0) {
		return psprintf("minus %s", zahl_cstring(-zahl));
	} else if (zahl == 0) {
		return "null";
	}

	return zahl_zillion(zahl);
}


