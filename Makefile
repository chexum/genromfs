
# Makefile for the genromfs program.

CFLAGS = -O2 -Wall #-g#
LDFLAGS = -s#-g

all: genromfs

genromfs: genromfs.o

clean:
	rm -f genromfs *.o

install:
	install genromfs $(DESTDIR)/usr/bin
