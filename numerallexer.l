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

%{
#include "numeral.h"
#include "numeralparser.tab.h"
%}

%option prefix="yynumeral"
%option noyywrap
%option nounput
%option noinput

INT_R [\-+]?[0-9]+

%%

{INT_R} {
	yynumerallval = atoll(yytext);
	return INT;
}

minus     { return MINUS; }

zero      { return ZERO; }

and       { return AND; }
-         { return DASH; }

one       { yynumerallval =  1; return ONE; }
two       { yynumerallval =  2; return ONE; }
three     { yynumerallval =  3; return ONE; }
four      { yynumerallval =  4; return ONE; }
five      { yynumerallval =  5; return ONE; }
six       { yynumerallval =  6; return ONE; }
seven     { yynumerallval =  7; return ONE; }
eight     { yynumerallval =  8; return ONE; }
nine      { yynumerallval =  9; return ONE; }
ten       { yynumerallval = 10; return ONE; }
eleven    { yynumerallval = 11; return ONE; }
twelve    { yynumerallval = 12; return ONE; }
thirteen  { yynumerallval = 13; return ONE; }
fourteen  { yynumerallval = 14; return ONE; }
fifteen   { yynumerallval = 15; return ONE; }
sixteen   { yynumerallval = 16; return ONE; }
seventeen { yynumerallval = 17; return ONE; }
eighteen  { yynumerallval = 18; return ONE; }
nineteen  { yynumerallval = 19; return ONE; }

twenty    { yynumerallval = 20; return TEN; }
thirty    { yynumerallval = 30; return TEN; }
forty     { yynumerallval = 40; return TEN; }
fifty     { yynumerallval = 50; return TEN; }
sixty     { yynumerallval = 60; return TEN; }
seventy   { yynumerallval = 70; return TEN; }
eighty    { yynumerallval = 80; return TEN; }
ninety    { yynumerallval = 90; return TEN; }

hundred   { yynumerallval = 100; return HUNDRED; }

thousand  { yynumerallval = 1000; return THOUSAND; }

millions?     { yynumerallval = 1000000; return ZILLION; }
billions?     { yynumerallval = 1000000000; return ZILLION; }
trillions?    { yynumerallval = 1000000000000; return ZILLION; }
quadrillions? { yynumerallval = 1000000000000000; return ZILLION; }
quintillions? { yynumerallval = 1000000000000000000; return ZILLION; }

[ \t\n]* /* eat whitespace */

. return ERR;
