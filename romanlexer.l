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
#include "romanparser.tab.h"
%}

%option prefix="yyroman"
%option noyywrap
%option nounput
%option noinput

INT_R [\-+]?[0-9]+

%%

{INT_R} {
	yyromanlval = atoll(yytext);
	return INT;
}

nulla { yyromanlval = 0; return ZERO; }
minus { yyromanlval = -1; return MINUS; }
[iI]  { yyromanlval = 1; return I; }
[vV]  { yyromanlval = 5; return V; }
[xX]  { yyromanlval = 10; return X; }
[lL]  { yyromanlval = 50; return L; }
[cC]  { yyromanlval = 100; return C; }
[dD]  { yyromanlval = 500; return D; }
[mM]  { yyromanlval = 1000; return M; }

[ \t\n]* /* eat whitespace */

. return ERR;
