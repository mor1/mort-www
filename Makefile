#
# Copyright (c) 2012--2016 Richard Mortier <mort@cantab.net>. All Rights
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

.PHONY: all clean distclean site test papers configure build

help: # list targets
	@egrep "^[^\w]+:" Makefile

DOCKER = docker run -ti -v $$(pwd -P):/cwd -w /cwd

COFFEE = $(DOCKER) mor1/alpine-coffeescript
JEKYLL = $(DOCKER) -p 80:80 mor1/alpine-jekyll
PYTHON = $(DOCKER) mor1/alpine-python3
MIRAGE = mirage # $(DOCKER) -v `pwd`:/src avsm/mirage mirage

BIBS = $(wildcard ~/me/publications/rmm-*.bib)
COFFEES = $(notdir $(wildcard _coffee/*.coffee))
JSS = $(patsubst %.coffee,js/%.js,$(COFFEES))

PAPERS = research/papers/papers.json
FLAGS ?=
MIRFLAGS ?= --no-opam

all: jss papers

clean: # remove Mirage build outputs
	$(RM) log
	cd _mirage \
	  && ( [ -r _mirage/Makefile ] && make clean ) || true \
	  && $(RM) log mir-mortio main.ml Makefile mortio* *.cmt static*.ml*

distclean: | clean # also remove built site and assets
	$(RM) -r _site _coffee/*.js js/*.js $(PAPERS)

jss: $(JSS)
js/%.js: _coffee/%.coffee # create .js from .coffee
	$(COFFEE) -c -o js $<

papers: $(PAPERS) research/papers/authors.json
$(PAPERS): $(BIBS) # create JSON data for papers
	$(PYTHON) _papers/bib2json.py \
	    -s _papers/strings.bib _papers/rmm-[cjptwu]*.bib \
	  >| $(PAPERS)

site: jss papers
	$(JEKYLL) build --trace  --incremental $(FLAGS)

test: jss papers
	$(JEKYLL) serve -H 0.0.0.0 -P 80 --trace --watch --incremental $(FLAGS)

## mirage

CONFIG = _mirage/config.ml

configure:
	$(MIRAGE) configure --$(MODE) $(FLAGS) -f $(CONFIG)

configure.xen:
	MODE=xen FLAGS="-vv --net direct" \
	  $(MIRAGE) configure $$FLAGS -f $(CONFIG) --$$MODE
configure.socket:
	MODE=unix FLAGS="-vv --net socket" \
	  $(MIRAGE) configure $$FLAGS -f $(CONFIG) --$$MODE
configure.direct:
	MODE=unix FLAGS="-vv --net direct" \
	  $(MIRAGE) configure $$FLAGS -f $(CONFIG) --$$MODE

build:
	cd _mirage && make build
