MODULE_big = numeral
OBJS = numeral.o \
	   numeralfuncs.o numerallexer.yy.o numeralparser.tab.o \
	   zahlfuncs.o zahllexer.yy.o zahlparser.tab.o \
	   romanfuncs.o romanlexer.yy.o romanparser.tab.o
EXTENSION = numeral
DATA_built = numeral--1.sql
REGRESS = extension numeral zahl roman operator
EXTRA_CLEAN = *.yy.* *.tab.*

PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)

INCLUDEDIR_SERVER = $(shell $(PG_CONFIG) --includedir-server)
# FLOAT8PASSBYVAL moved from pg_config.h to c.h in PG13
FLOAT8PASSBYVAL = $(shell grep FLOAT8PASSBYVAL $(INCLUDEDIR_SERVER)/pg_config.h $(INCLUDEDIR_SERVER)/c.h | grep -o true)
ifeq ($(FLOAT8PASSBYVAL),true)
PASSEDBYVALUE = passedbyvalue,
endif

numeral.o: numeral.c numeral.h

%.yy.c: %.l
	flex -o $@ $<

numerallexer.yy.o: numeral.h numeralparser.tab.c # actually numeralparser.tab.h
zahllexer.yy.o: numeral.h zahlparser.tab.c # actually zahlparser.tab.h
romanlexer.yy.o: numeral.h romanparser.tab.c # actually romanparser.tab.h

%.tab.c: %.y
	bison -d $<

numeralparser.tab.o: numeral.h
zahlparser.tab.o: numeral.h
romanparser.tab.o: numeral.h

# extension sql
%.sql: %.sql.in
	set -e; \
	for type in numeral zahl roman; do \
		sed -e "s/@TYPE@/$$type/g" -e "s/@PASSEDBYVALUE@/$(PASSEDBYVALUE)/" < $<; \
	done > $@
