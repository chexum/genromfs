
# Makefile for the genromfs program.

all: genromfs

PACKAGE = genromfs
VERSION = 0.5
CC = gcc
CFLAGS = -O2 -Wall -DVERSION=\"$(VERSION)\"#-g#
LDFLAGS = -s#-g

DISTDIR = $(PACKAGE)-$(VERSION)

FILES = COPYING NEWS ChangeLog Makefile \
 genromfs.8 genromfs.c genromfs.lsm \
 readme-kernel-patch genrommkdev romfs.txt

prefix = /usr
bindir = $(prefix)/bin
mandir = $(prefix)/man

genromfs: genromfs.o
	$(CC) $(LDFLAGS) genromfs.o -o genromfs

.c.o:
	$(CC) $(CFLAGS) $< -c -o $@

clean:
	rm -f genromfs *.o

distclean: clean
	rm -rf $(DISTDIR) $(DISTDIR).tar.gz

dist:
	rm -rf $(DISTDIR).tar.gz $(DISTDIR); \
	mkdir $(DISTDIR); \
	for i in $(FILES); do \
		cp $$i $(DISTDIR)/; \
	done; \
	tar --owner=root --group=root -zcvf $(DISTDIR).tar.gz $(DISTDIR); \
	rm -rf $(DISTDIR)

install: all install-bin install-man

install-bin:
	mkdir -p $(PREFIX)/$(bindir)
	install -m 755 genromfs $(PREFIX)/$(bindir)

install-man:
	mkdir -p $(PREFIX)/$(bindir)
	install -m 644 genromfs.8 $(PREFIX)/$(bindir)/man8

