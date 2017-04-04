MODULE_big = numeral
OBJS = numeral.o \
	   zahl.o zahllexer.yy.o zahlparser.tab.o \
	   roman.o romanlexer.yy.o romanparser.tab.o
EXTENSION = numeral
DATA_built = numeral--1.sql
REGRESS = extension zahl operator roman
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
romanlexer.yy.o: numeral.h romanparser.tab.c # actually romanparser.tab.h

%.tab.c: %.y
ifneq ($(shell bison --version | grep 'Bison..2'),)
	echo "### bison 2 detected, using pre-built *.tab.c and *.tab.h files ###" # remove this hack once wheezy and precise are gone
	touch $@
else
	bison -d $<
endif

zahlparser.tab.o: numeral.h
romanparser.tab.o: numeral.h

# extension sql
%.sql: %.sql.in
	for type in zahl roman; do \
		sed -e "s/@TYPE@/$$type/g" < $< || exit; \
	done > $@
