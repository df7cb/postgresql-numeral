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

char *yyerrstr; /* copy of error catched by yynumeralerror() */

void yynumeralerror (char *s);

void
yynumeralerror (char *s)
{
	/* store error for later use in number_in */
	yyerrstr = pstrdup(s);
}

PG_FUNCTION_INFO_V1(numeral_in);

Datum
numeral_in (PG_FUNCTION_ARGS)
{
	char	*str = PG_GETARG_CSTRING(0);
	Numeral	 numeral;

	if (numeral_parse(str, &numeral) > 0)
		ereport(ERROR,
				(errcode(ERRCODE_INVALID_TEXT_REPRESENTATION),
				 errmsg("invalid input syntax for type numeral: \"%s\", %s",
					 str, yyerrstr)));

	PG_RETURN_INT64(numeral);
}

PG_FUNCTION_INFO_V1(numeral_out);

Datum
numeral_out(PG_FUNCTION_ARGS)
{
	Numeral	numeral = PG_GETARG_INT64(0);
	PG_RETURN_CSTRING(numeral_cstring(numeral));
}

/* format German numerals */

static const char *numeral_one[] = {
	"",
	"one",
	"two",
	"three",
	"four",
	"five",
	"six",
	"seven",
	"eight",
	"nine",
	"ten",
	"eleven",
	"twelve",
	"thirteen",
	"fourteen",
	"fifteen",
	"sixteen",
	"seventeen",
	"eighteen",
	"nineteen",
};

static const char *numeral_ten[] = {
	"",
	"ten",
	"twenty",
	"thirty",
	"forty",
	"fifty",
	"sixty",
	"seventy",
	"eighty",
	"ninety",
};

static const char *
numeral_x (Numeral numeral)
{
	Assert (numeral >= 0 && numeral < 20);
	return numeral_one[numeral];
}

static const char *
numeral_xx (Numeral numeral)
{
	if (numeral < 20) {
		return numeral_x(numeral); /* returns empty for 0 */
	}
	if (numeral % 10 == 0)
		return numeral_ten[numeral / 10];
	return psprintf("%s-%s",
			numeral_ten[numeral / 10],
			numeral_x(numeral % 10));
}

static const char *
numeral_xxx (Numeral numeral)
{
	if (numeral < 100)
		return numeral_xx(numeral);
	if (numeral % 100 == 0)
		return psprintf("%s hundred", numeral_x(numeral / 100));
	return psprintf("%s hundred %s",
			numeral_x(numeral / 100),
			numeral_xx(numeral % 100));
}

static const char *
numeral_xxxxxx (Numeral numeral)
{
	if (numeral < 1000)
		return numeral_xxx(numeral);
	if (numeral % 1000 == 0)
		return psprintf("%s thousand", numeral_xxx(numeral / 1000));
	return psprintf("%s thousand %s",
			numeral_xxx(numeral / 1000),
			numeral_xxx(numeral % 1000));
}

struct zillions {
	long long value;
	const char *name;
} static zillions[] = {
	{ 1000000000000000000, "quintillion" },
	{    1000000000000000, "quadrillion" },
	{       1000000000000, "trillion"    },
	{          1000000000, "billion"     },
	{             1000000, "million"     },
	{                   0                },
};

static const char *
numeral_zillion (Numeral numeral)
{
	struct zillions *z;
	char *result = palloc0(1000);

	for (z = zillions; z->value; z++)
		if (numeral >= z->value) {
			int n = numeral / z->value;
			if (*result)
				strlcat (result, " ", 1000);
			strlcat (result, numeral_xxx(n), 1000);
			strlcat (result, " ", 1000);
			strlcat (result, z->name, 1000);
			numeral = numeral % z->value;
		}

	if (numeral > 0) {
		if (*result)
			strlcat (result, " ", 1000);
		strlcat (result, numeral_xxxxxx(numeral), 1000);
	}

	return result;
}

const char *
numeral_cstring (Numeral numeral)
{
	if (numeral < 0) {
		return psprintf("minus %s", numeral_cstring(-numeral));
	} else if (numeral == 0) {
		return "null";
	}

	return numeral_zillion(numeral);
}


