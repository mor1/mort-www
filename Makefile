#
# Copyright (c) 2012--2015 Richard Mortier <mort@cantab.net>
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

.PHONY: all configure build run clean store store/% css site js test deploy papers

all: site

clean:
	$(RM) -r _site css/screen.css
	$(RM) $(JSS) $(wildcard _coffee/*.js)
	git checkout -- _config.yml css/screen.css
	$(MIRAGE) clean src/config.ml $(FLAGS)
	$(RM) -r src/myocamlbuild.ml src/_build log src/log $(TARGET).xen

distclean: | clean
	$(RM) $(JSS) $(FATS) $(FATSHS)
	$(RM) src/static.ml[i] src/*-fat*-image.sh src/fat*.img


## Jekyll sections
GH_ROOT=/
CS_ROOT=/~rmm/

COFFEE = coffee
JEKYLL = jekyll --trace
MIRROR = rsync -rvz --rsh=ssh --delete --progress

COFFEES = $(notdir $(wildcard _coffee/*.coffee))
JSS = $(patsubst %.coffee,js/%.js,$(COFFEES))

site: css js papers
	$(JEKYLL) build

css: css/screen.css
css/screen.css: _less/screen.css
	sed 's!@BASEURL@!${GH_ROOT}!g' _less/screen.css >| css/screen.css

js: $(JSS)

test: css js
	$(JEKYLL) serve --watch

deploy: js
	sed 's!@BASEURL@!${CS_ROOT}!g' _less/screen.css >| css/screen.css
	sed -i '' 's!baseurl: /!baseurl: ${CS_ROOT}!;					\
		s!analytics_id: UA-15796259-1!analytics_id: UA-15796259-2!' \
			_config.yml
	$(JEKYLL) build
	$(MIRROR) _site/ severn.cs.nott.ac.uk:/lhome/rmm/public_html
	git checkout -- _config.yml css/screen.css

papers: papers/papers.json
papers/papers.json: $(wildcard ~/me/bibs/rmm-*.bib)
	~/src/python-scripts/bib2json.py			\
	  -s ~/me/bibs/strings.bib					\
	  ~/me/bibs/rmm-[cjptwu]*.bib				\
	 >| papers/papers.json

js/%.js: _coffee/%.coffee
	$(COFFEE) -c -o js $<

## Mirage sections
TARGET=_mirage/src/mir-mort-www

MIRAGE  = mirage
MODE   ?= unix
FS     ?= fat     ## really, crunch isn't worth it for 90MB `store` data
NET    ?= direct
ADDR   ?= static

FLAGS ?=

store/courses/js/%.js: store/courses/coffee/%.coffee
	$(COFFEE) -c -o store/courses/js $<

jss: $(JSS)

## FAT filesystem rules
STORES = $(wildcard store/*)						   # input directories
FATS = $(wildcard src/fat*.img)					   # output fat image files
TIMESTAMPS = $(patsubst store/%,timestamp-%,$(STORES)) # sync timestamp targets

# builds all output fat images if any input directory content mtimes changed
store: $(FATS) | $(TIMESTAMPS)

# propagates subdirectory content mtimes up to root
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
  STAT_FLAGS = -f "%m %N"
endif
ifeq ($(UNAME_S),Linux)
  STAT_FLAGS = -c "%Y %n"
endif

timestamp-%:
	find store/$* -type f -print0 | xargs -0 stat $(STAT_FLAGS) |\
	  sort -n | tail -1 | cut -f2- -d" " |\
	  xargs -I {} touch -r {} store/$*

# build specific fat image if any input directory content mtime changed
src/fat%.img: $(STORES) | $(TIMESTAMPS)
	src/make-fat$*-image.sh
	touch $@ # looks like the fat command line tool doesn't update mtime?!

configure:
	FS=$(FS) NET=$(NET) IPADDR=$(IPADDR) \
	  $(MIRAGE) configure src/config.ml --$(MODE)

build: $(JSS) | store
	$(MIRAGE) build src/config.ml

run:
	$(MIRAGE) run src/config.ml
