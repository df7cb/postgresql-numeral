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
#include "numbers.h"
#include "parser.tab.h"
%}

%option prefix="yynumbers"
%option noyywrap
%option nounput
%option noinput

INT_R [\-+]?[0-9]+

%%

{INT_R} {
	yynumberslval = atoll(yytext);
	return INT;
}

minus    { return MINUS; }

null     { return ZERO; }

und      { return AND; }

ein[es]? { yynumberslval =  1; return ONE; }
zwei     { yynumberslval =  2; return ONE; }
drei     { yynumberslval =  3; return ONE; }
vier     { yynumberslval =  4; return ONE; }
fünf     { yynumberslval =  5; return ONE; }
sechs    { yynumberslval =  6; return ONE; }
sieben   { yynumberslval =  7; return ONE; }
acht     { yynumberslval =  8; return ONE; }
neun     { yynumberslval =  9; return ONE; }
zehn     { yynumberslval = 10; return ONE; }
elf      { yynumberslval = 11; return ONE; }
zwölf    { yynumberslval = 12; return ONE; }
dreizehn { yynumberslval = 13; return ONE; }
vierzehn { yynumberslval = 14; return ONE; }
fünfzehn { yynumberslval = 15; return ONE; }
sechzehn { yynumberslval = 16; return ONE; }
siebzehn { yynumberslval = 17; return ONE; }
achtzehn { yynumberslval = 18; return ONE; }
neunzehn { yynumberslval = 19; return ONE; }

zwanzig { yynumberslval = 20; return TEN; }
dreißig { yynumberslval = 30; return TEN; }
vierzig { yynumberslval = 40; return TEN; }
fünfzig { yynumberslval = 50; return TEN; }
sechzig { yynumberslval = 60; return TEN; }
siebzig { yynumberslval = 70; return TEN; }
achtzig { yynumberslval = 80; return TEN; }
neunzig { yynumberslval = 90; return TEN; }

hundert { yynumberslval = 100; return HUNDRED; }

tausend { yynumberslval = 1000; return THOUSAND; }

[mM]illion(en)?  { yynumberslval = 1000000; return ZILLION; }
[mM]illiarden?   { yynumberslval = 1000000000; return ZILLION; }
[bB]illion(en)?  { yynumberslval = 1000000000000; return ZILLION; }
[bB]illiarden?   { yynumberslval = 1000000000000000; return ZILLION; }
[tT]rillion(en)? { yynumberslval = 1000000000000000000; return ZILLION; }

 /* Trilliarde doesn't fit into long long */

[ \t\n]* /* eat whitespace */

. return ERR;
