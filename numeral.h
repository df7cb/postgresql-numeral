/* type defs */

typedef long long Zahl;
typedef long long Roman;

/* prototypes */

const char *zahl_cstring (Zahl zahl);
int zahl_parse (char *s, Zahl *zahl);

const char *roman_cstring (Roman roman);
int roman_parse (char *s, Roman *roman);
