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
#include <strings.h> /* bzero */
#include "numeral.h"

/* flex/bison prototypes */
int yyromanlex (void);
struct yyroman_buffer_state *yyroman_scan_string(char *str);
void yyroman_delete_buffer(struct yyroman_buffer_state *buffer);
void yyromanerror (char const *s);

static Roman *numeral_parse_result; /* parsing result gets stored here */
%}

%define parse.error verbose
%define api.prefix {yyroman}

%define api.value.type {Roman}
%token INT
%token ZERO
%token MINUS
%token I
%token V
%token X
%token L
%token C
%token D
%token M
%token ERR
%%

input: /* parser entry */
  INT { *numeral_parse_result = $1; }
| ZERO { *numeral_parse_result = 0; }
| MINUS expr { *numeral_parse_result = -$2; }
| expr { *numeral_parse_result = $1; }
;

expr:
  max_c M max_m { $$ = $2 - $1 + $3; }
| max_c D max_c { $$ = $2 - $1 + $3; }
| max_x C max_c { $$ = $2 - $1 + $3; }
| max_x L max_x { $$ = $2 - $1 + $3; }
| max_i X max_x { $$ = $2 - $1 + $3; }
| max_i V max_i { $$ = $2 - $1 + $3; }
|       I max_i { $$ = $1 + $2; }
;

max_m:
  %empty { $$ = 0; }
| max_c M max_m { $$ = $2 - $1 + $3; }
| max_c D max_c { $$ = $2 - $1 + $3; }
| max_x C max_c { $$ = $2 - $1 + $3; }
| max_x L max_x { $$ = $2 - $1 + $3; }
| max_i X max_x { $$ = $2 - $1 + $3; }
| max_i V max_i { $$ = $2 - $1 + $3; }
|       I max_i { $$ = $1 + $2; }
;

max_c:
  %empty { $$ = 0; }
| max_x C max_c { $$ = $2 - $1 + $3; }
| max_x L max_x { $$ = $2 - $1 + $3; }
| max_i X max_x { $$ = $2 - $1 + $3; }
| max_i V max_i { $$ = $2 - $1 + $3; }
|       I max_i { $$ = $1 + $2; }
;

max_x:
  %empty { $$ = 0; }
| max_i X max_x { $$ = $2 - $1 + $3; }
| max_i V max_i { $$ = $2 - $1 + $3; }
|       I max_i { $$ = $1 + $2; }
;

max_i:
  %empty { $$ = 0; }
|       I max_i { $$ = $1 + $2; }
;

%%

/* parse a given string and return the result via the second argument */
int
roman_parse (char *s, Roman *roman)
{
	struct yyroman_buffer_state *buf;
	int ret;

	numeral_parse_result = roman;
	buf = yyroman_scan_string(s);
	ret = yyromanparse();
	yyroman_delete_buffer(buf);
	return ret;
}
