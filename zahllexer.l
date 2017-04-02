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
#include "zahlparser.tab.h"
%}

%option prefix="yyzahl"
%option noyywrap
%option nounput
%option noinput

INT_R [\-+]?[0-9]+

%%

{INT_R} {
	yyzahllval = atoll(yytext);
	return INT;
}

minus    { return MINUS; }

null     { return ZERO; }

und      { return AND; }

ein[es]? { yyzahllval =  1; return ONE; }
zwei     { yyzahllval =  2; return ONE; }
drei     { yyzahllval =  3; return ONE; }
vier     { yyzahllval =  4; return ONE; }
fünf     { yyzahllval =  5; return ONE; }
sechs    { yyzahllval =  6; return ONE; }
sieben   { yyzahllval =  7; return ONE; }
acht     { yyzahllval =  8; return ONE; }
neun     { yyzahllval =  9; return ONE; }
zehn     { yyzahllval = 10; return ONE; }
elf      { yyzahllval = 11; return ONE; }
zwölf    { yyzahllval = 12; return ONE; }
dreizehn { yyzahllval = 13; return ONE; }
vierzehn { yyzahllval = 14; return ONE; }
fünfzehn { yyzahllval = 15; return ONE; }
sechzehn { yyzahllval = 16; return ONE; }
siebzehn { yyzahllval = 17; return ONE; }
achtzehn { yyzahllval = 18; return ONE; }
neunzehn { yyzahllval = 19; return ONE; }

zwanzig { yyzahllval = 20; return TEN; }
dreißig { yyzahllval = 30; return TEN; }
vierzig { yyzahllval = 40; return TEN; }
fünfzig { yyzahllval = 50; return TEN; }
sechzig { yyzahllval = 60; return TEN; }
siebzig { yyzahllval = 70; return TEN; }
achtzig { yyzahllval = 80; return TEN; }
neunzig { yyzahllval = 90; return TEN; }

hundert { yyzahllval = 100; return HUNDRED; }

tausend { yyzahllval = 1000; return THOUSAND; }

[mM]illion(en)?  { yyzahllval = 1000000; return ZILLION; }
[mM]illiarden?   { yyzahllval = 1000000000; return ZILLION; }
[bB]illion(en)?  { yyzahllval = 1000000000000; return ZILLION; }
[bB]illiarden?   { yyzahllval = 1000000000000000; return ZILLION; }
[tT]rillion(en)? { yyzahllval = 1000000000000000000; return ZILLION; }

 /* Trilliarde doesn't fit into long long */

[ \t\n]* /* eat whitespace */

. return ERR;
