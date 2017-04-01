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
#include "numbers.h"

/* flex/bison prototypes */
int yylex (void);
struct yynumbers_buffer_state *yynumbers_scan_string(char *str);
void yynumbers_delete_buffer(struct yynumbers_buffer_state *buffer);
void yyerror (char const *s);

static Zahl *numbers_parse_result; /* parsing result gets stored here */
%}

%define parse.error verbose
%define api.prefix {yynumbers}

%define api.value.type {Zahl}
%token INT
%token MINUS
%token ZERO
%token AND
%token ONE
%token TEN
%token HUNDRED
%token THOUSAND
%token ZILLION
%token ERR
%%

input: /* parser entry */
  INT { *numbers_parse_result = $1; }
| ZERO { *numbers_parse_result = 0; }
| expr { *numbers_parse_result = $1; }
| MINUS expr { *numbers_parse_result = -$1; }
;

expr: /* general number */
  xxxxxx
| prefix_xxx ZILLION expr_tail { $$ = $1 * $2 + $3; }
;

expr_tail: /* tail of general number */
  %empty { $$ = 0; }
| xxxxxx
| prefix_xxx ZILLION expr_tail { $$ = $1 * $2 + $3; }

xxxxxx: /* 6-digit number */
  xxx
| prefix_xxx THOUSAND suffix_xxx { $$ = $1 * $2 + $3; }
;

prefix_xxx: /* N-thousand */
  %empty { $$ = 1; }
| xxx
;

suffix_xxx: /* thousand-and-N */
  %empty { $$ = 0; }
| xxx
;

xxx: /* 3-digit number */
  xx
| prefix_x HUNDRED suffix_xx { $$ = $1 * $2 + $3; }
;

xx: /* 2-digit number */
  ONE
| TEN
| ONE AND TEN { $$ = $1 + $3; }
;

prefix_x: /* N-hundred */
  %empty { $$ = 1; }
| ONE
;

suffix_xx: /* hundred-and-N */
  %empty { $$ = 0; }
| xx
;

%%

/* parse a given string and return the result via the second argument */
int
numbers_parse (char *s, Zahl *zahl)
{
	struct yynumbers_buffer_state *buf;
	int ret;

	numbers_parse_result = zahl;
	buf = yynumbers_scan_string(s);
	ret = yynumbersparse();
	yynumbers_delete_buffer(buf);
	return ret;
}
