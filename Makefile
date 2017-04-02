MODULE_big = numeral
OBJS = numeral.o zahllexer.yy.o zahlparser.tab.o zahl.o
EXTENSION = numeral
DATA = numeral--1.sql
REGRESS = extension zahl cast
EXTRA_CLEAN = *.yy.* *.tab.*

PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)

# upgrade testing, not enabled by default
#REGRESS += upgrade

numeral.o: numeral.c numeral.h

%.yy.c: %.l
	flex -o $@ $<

zahllexer.yy.o: numeral.h zahlparser.tab.c # actually zahlparser.tab.h

%.tab.c: %.y
ifneq ($(shell bison --version | grep 'Bison..2'),)
	echo "### bison 2 detected, using pre-built *.tab.c and *.tab.h files ###" # remove this hack once wheezy and precise are gone
	touch $@
else
	bison -d $<
endif

zahlparser.tab.o: numeral.h
