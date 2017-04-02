SELECT 'vier'::zahl::bigint;

SELECT 'hundert'::zahl = 'einhundert';
SELECT 'drei'::zahl <> 'vier';
SELECT 'zehn'::zahl < 'elf';
SELECT 'acht'::zahl > 'sieben';
SELECT 'neun'::zahl <= 'neun';
SELECT 'eins'::zahl >= 'null';

SELECT 'zehn'::zahl % 'drei';
SELECT 'acht'::zahl + 'vier';
SELECT 'neun'::zahl - 'vier';
SELECT 'fünf'::zahl * 'vier';
SELECT 'zwölf'::zahl / 'drei';

SELECT 'zehn'::zahl & 'sechs';
SELECT 'zwei'::zahl | 'vier';

SELECT @ 'minus drei'::zahl;
SELECT - 'vier'::zahl;
SELECT ~ 'fünfzehn'::zahl;
SELECT + 'sechs'::zahl;
