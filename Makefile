
# Makefile for the genromfs program.

CFLAGS = -O2 -Wall#-g#
LDFLAGS = -s#-g

prefix = /usr
bindir = $(prefix)/bin
mandir = $(prefix)/man

all: genromfs

genromfs: genromfs.o

distclean clean:
	rm -f genromfs *.o

install: all install-bin install-man

install-bin:
	mkdir -p $(PREFIX)/$(bindir)
	install -m 755 genromfs $(PREFIX)/$(bindir)

install-man:
	mkdir -p $(PREFIX)/$(bindir)
	install -m 644 genromfs.8 $(PREFIX)/$(bindir)/man8

