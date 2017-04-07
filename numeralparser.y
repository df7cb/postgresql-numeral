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
int yynumerallex (void);
struct yynumeral_buffer_state *yynumeral_scan_string(char *str);
void yynumeral_delete_buffer(struct yynumeral_buffer_state *buffer);
void yynumeralerror (char const *s);

static Numeral *numeral_parse_result; /* parsing result gets stored here */
%}

%define parse.error verbose
%define api.prefix {yynumeral}

%define api.value.type {Numeral}
%token INT
%token MINUS
%token ZERO
%token AND
%token DASH
%token ONE
%token TEN
%token HUNDRED
%token THOUSAND
%token ZILLION
%token ERR
%%

input: /* parser entry */
  INT { *numeral_parse_result = $1; }
| ZERO { *numeral_parse_result = 0; }
| expr { *numeral_parse_result = $1; }
| MINUS expr { *numeral_parse_result = -$2; }
;

expr: /* general number */
  xxxxxx
| prefix_xxx ZILLION maybe_and expr_tail { $$ = $1 * $2 + $4; }
;

expr_tail: /* tail of general number */
  %empty { $$ = 0; }
| xxxxxx
| prefix_xxx ZILLION maybe_and expr_tail { $$ = $1 * $2 + $4; }

xxxxxx: /* 6-digit number */
  xxx
| prefix_xxx THOUSAND maybe_and suffix_xxx { $$ = $1 * $2 + $4; }
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
| prefix_x HUNDRED maybe_and suffix_xx { $$ = $1 * $2 + $4; }
;

xx: /* 2-digit number */
  ONE
| TEN
| TEN DASH ONE { $$ = $1 + $3; }
;

prefix_x: /* N-hundred */
  %empty { $$ = 1; }
| ONE
;

suffix_xx: /* hundred-and-N */
  %empty { $$ = 0; }
| xx
;

maybe_and:
  %empty
| AND
;

%%

/* parse a given string and return the result via the second argument */
int
numeral_parse (char *s, Numeral *numeral)
{
	struct yynumeral_buffer_state *buf;
	int ret;

	numeral_parse_result = numeral;
	buf = yynumeral_scan_string(s);
	ret = yynumeralparse();
	yynumeral_delete_buffer(buf);
	return ret;
}
