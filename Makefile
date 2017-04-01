MODULE_big = numbers
OBJS = numbers.o lexer.yy.o parser.tab.o zahl.o
EXTENSION = numbers
DATA = numbers--1.sql
REGRESS = extension zahl cast
EXTRA_CLEAN = lexer.yy.* parser.tab.*

PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)

# upgrade testing, not enabled by default
#REGRESS += upgrade

numbers.o: numbers.c numbers.h

lexer.yy.c: lexer.l
	flex -o $@ $<

lexer.yy.o: numbers.h parser.tab.c # actually unitparse.tab.h

parser.tab.c: parser.y
ifneq ($(shell bison --version | grep 'Bison..2'),)
	echo "### bison 2 detected, using pre-built parser.tab.c and .h files ###" # remove this hack once wheezy and precise are gone
	touch $@
else
	bison -d $<
endif

parser.tab.o: numbers.h
