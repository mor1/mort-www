#
# Copyright (c) 2012--2015 Richard Mortier <mort@cantab.net>. All Rights
# Reserved.
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

.PHONY: all clean site test

COFFEE = coffee
MIRAGE = mirage

MODE  ?= unix
NET   ?= socket
PORT  ?= 80

BIBS = $(wildcard ~/me/footprint/publications/rmm-*.bib)
COFFEES = $(notdir $(wildcard _coffee/*.coffee))
JSS = $(patsubst %.coffee,js/%.js,$(COFFEES))

PAPERS = research/papers/papers.json
FLAGS ?=

all: site build

clean:
	$(RM) -r _site _coffee/*.js js/*.js
	[ -r _mirage/Makefile ] && ( cd _mirage && make clean ) || true
	$(RM) log_mirage/mir-mortio _mirage/main.ml _mirage/Makefile _mirage/mortio*

distclean: | clean
	$(RM) -r $(PAPERS)

jss: $(JSS)
js/%.js: _coffee/%.coffee
	$(COFFEE) -c -o js $<

site: jss papers
	jekyll build --trace $(FLAGS)

test: site
	jekyll serve --trace --watch --skip-initial-build $(FLAGS)

papers: $(PAPERS) research/papers/authors.json
$(PAPERS): $(BIBS)
	~/src/python-scripts/bib2json.py \
	    -s ~/me/footprint/publications/strings.bib \
	    ~/me/footprint/publications/rmm-[cjptwu]*.bib \
	  >| $(PAPERS)

configure: _mirage/Makefile
_mirage/Makefile:
	NET=$(NET) PORT=$(PORT) ADDR=$(ADDR) MASK=$(MASK) GWS=$(GWS) \
		$(MIRAGE) configure _mirage/config.ml --$(MODE)

build: _mirage/mir-mortio
_mirage/mir-mortio: _mirage/Makefile
	cd _mirage && make build
