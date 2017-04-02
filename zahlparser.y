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
int yyzahllex (void);
struct yyzahl_buffer_state *yyzahl_scan_string(char *str);
void yyzahl_delete_buffer(struct yyzahl_buffer_state *buffer);
void yyzahlerror (char const *s);

static Zahl *numeral_parse_result; /* parsing result gets stored here */
%}

%define parse.error verbose
%define api.prefix {yyzahl}

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
  INT { *numeral_parse_result = $1; }
| ZERO { *numeral_parse_result = 0; }
| expr { *numeral_parse_result = $1; }
| MINUS expr { *numeral_parse_result = -$1; }
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
zahl_parse (char *s, Zahl *zahl)
{
	struct yyzahl_buffer_state *buf;
	int ret;

	numeral_parse_result = zahl;
	buf = yyzahl_scan_string(s);
	ret = yyzahlparse();
	yyzahl_delete_buffer(buf);
	return ret;
}
