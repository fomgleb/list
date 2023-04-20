
AR ?= ar
CC ?= gcc
STRIP ?= strip
PREFIX ?= /usr/local
LIBDIR ?= $(PREFIX)/lib
INCLUDEDIR ?= $(PREFIX)/include
INCLUDESUBDIR ?= /clibs
DESTDIR ?=

CFLAGS = -O3 -std=c99 -Wall -Wextra -Ideps

SRCS = src/list.c \
		   src/list_node.c \
		   src/list_iterator.c

OBJS = $(SRCS:.c=.o)

MAJOR_VERSION = 0
MINOR_VERSION = 4
PATCH_VERSION = 0

all: build/libclibs_list.a

install: all
	test -d $(DESTDIR)$(LIBDIR) || mkdir -p $(DESTDIR)$(LIBDIR)
	cp -f build/libclibs_list.a $(DESTDIR)$(LIBDIR)/libclibs_list.a
	test -d $(DESTDIR)$(INCLUDEDIR)$(INCLUDESUBDIR) || mkdir -p $(DESTDIR)$(INCLUDEDIR)$(INCLUDESUBDIR)/
	cp -f src/list.h $(DESTDIR)$(INCLUDEDIR)$(INCLUDESUBDIR)/list.h

uninstall:
	rm -f $(DESTDIR)$(LIBDIR)/libclibs_list.a
	rm -f $(DESTDIR)$(INCLUDEDIR)$(INCLUDESUBDIR)/list.h

build/libclibs_list.a: $(OBJS)
	@mkdir -p build
	$(AR) rcs $@ $^

bin/test: test.o $(OBJS)
	@mkdir -p bin
	$(CC) $^ -o $@

bin/benchmark: benchmark.o $(OBJS)
	@mkdir -p bin
	$(CC) $^ -o $@

%.o: %.c
	$(CC) $< $(CFLAGS) -c -o $@

clean:
	rm -fr bin build *.o src/*.o

test: bin/test
	@./$<

benchmark: bin/benchmark
	@./$<

.PHONY: test benchmark clean install uninstall
