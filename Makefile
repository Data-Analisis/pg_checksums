#-------------------------------------------------------------------------
#
# Makefile for pg_checksums
#
# Copyright (c) 1998-2019, PostgreSQL Global Development Group
#
# pg_checksums/Makefile
#
#-------------------------------------------------------------------------

PROGRAM = pg_checksums
PGFILEDESC = "pg_checksums - Activate/deactivate/verify data checksums in an offline cluster"
PGAPPICON=win32

OBJS= pg_checksums.o port.o $(WIN32RES)
EXTRA_CLEAN = tmp_check doc/man1

PG_CONFIG ?= pg_config
PGXS = $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)

# avoid linking against all libs that the server links against (xml, selinux, ...)
LIBS = $(libpq_pgport)

all: pg_checksums

man: doc/man1/pg_checksums.1

doc/man1/pg_checksums.1: doc/pg_checksums.sgml
	(cd doc && xsltproc stylesheet-man.xsl pg_checksums.sgml)

prove_installcheck:
	rm -rf $(CURDIR)/tmp_check
	cd $(srcdir) && TESTDIR='$(CURDIR)' PATH="$(bindir):$$PATH" PGPORT='6$(DEF_PGPORT)' PG_REGRESS='$(top_builddir)/src/test/regress/pg_regress' $(PROVE) $(PG_PROVE_FLAGS) $(PROVE_FLAGS) $(if $(PROVE_TESTS),$(PROVE_TESTS),t/*.pl)

installcheck: prove_installcheck
