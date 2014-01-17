#
# Copyright (c) 2013 Richard Mortier <mort@cantab.net>
#
# Permission to use, copy, modify, and distribute this software for any purpose
# with or without fee is hereby granted, provided that the above copyright
# notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
#

.PHONY: all configure build run clean store store/%

TARGET=src/mir-mort-www

all: build
	@ :

## pre-compile coffeescript for /courses
COFFEE = coffee
COFFEES = $(notdir $(wildcard store/courses/coffee/*.coffee))
JSS = $(patsubst %.coffee,store/courses/js/%.js,$(COFFEES))

store/courses/js/%.js: store/courses/coffee/%.coffee
	$(COFFEE) -c -o store/courses/js $<

jss: $(JSS)

## FAT filesystem rules
STORES = $(wildcard store/*)		# input directories
FATS = $(wildcard src/fat*.img)	# output fat image files
TIMESTAMPS = $(patsubst store/%,timestamp-%,$(STORES)) # sync timestamp targets

# builds all output fat images if any input directory content mtimes changed
store: $(FATS) | $(TIMESTAMPS) configure

# propagates subdirectory content mtimes up to root
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
  STAT_FLAGS = -f "%m %N"
endif
ifeq ($(UNAME_S),Linux)
  STAT_FLAGS = -c "%Y %N"
endif

timestamp-%:
		find store/$* -type f -print0 | xargs -0 stat $(STAT_FLAGS) |	\
		sort -n | tail -1 | cut -f2- -d" " |			\
		xargs -I {} touch -r {} store/$*

# build specific fat image if any input directory content mtime changed
src/fat%.img: $(STORES) | $(TIMESTAMPS) configure
	src/make-fat$*-image.sh
	touch $@ # looks like the fat command line tool doesn't update mtime

## mirage rules
MIRAGE = mirage
MODE ?= unix
FS_MODE ?= fat
BFLAGS ?=

configure: src/Makefile
src/Makefile: src/config.ml
	$(MIRAGE) configure src/config.ml $(BFLAGS) --$(MODE)

build: $(JSS) | store configure
	$(MIRAGE) build src/config.ml $(BFLAGS)

run: | build
	$(MIRAGE) run src/config.ml

clean:
	$(MIRAGE) clean src/config.ml $(BFLAGS)
	$(RM) -r src/myocamlbuild.ml src/_build log src/log src/static.ml[i]

distclean: | clean
	$(RM) $(JSS) $(FATS) $(FATSHS)
