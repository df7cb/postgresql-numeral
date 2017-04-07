/* type defs */

typedef long long Numeral;
typedef long long Zahl;
typedef long long Roman;

/* prototypes */

const char *numeral_cstring (Numeral numeral);
int numeral_parse (char *s, Numeral *numeral);

const char *zahl_cstring (Zahl zahl);
int zahl_parse (char *s, Zahl *zahl);

const char *roman_cstring (Roman roman);
int roman_parse (char *s, Roman *roman);
