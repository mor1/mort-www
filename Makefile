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

.PHONY: clean distclean site test papers configure build

PORT ?= 8080

help: # list targets
	@egrep "^\S+:" Makefile \
	  | grep -v "^.PHONY" \
	  | awk -F"\s*#\s*" '{ if (length($2) != 0) printf("%s\n--%s\n", $$1, $$2) }'

DOCKER = docker run -ti -v $$(pwd -P):/cwd -w /cwd

COFFEE = $(DOCKER) mor1/alpine-coffeescript
JEKYLL = $(DOCKER) mor1/jekyll
JEKYLLS= $(DOCKER) -p $(PORT):$(PORT) mor1/jekyll
PYTHON = $(DOCKER) mor1/alpine-python3
MIRAGE = mirage # $(DOCKER) -v `pwd`:/src avsm/mirage mirage

BIBS = $(wildcard ~/me/publications/rmm-*.bib)
COFFEES = $(notdir $(wildcard _coffee/*.coffee))
JSS = $(patsubst %.coffee,js/%.js,$(COFFEES))

PAPERS = research/papers/papers.json

clean: # remove Mirage build outputs and built site
	$(RM) log
	-cd _mirage && make clean
	$(RM) -r _site

distclean: | clean # also remove built assets
	$(RM) -r _coffee/*.js js/*.js $(PAPERS)

jss: $(JSS)
js/%.js: _coffee/%.coffee # create .js from .coffee
	$(COFFEE) -c -o js $<

papers: $(PAPERS) research/papers/authors.json # create JSON data for papers
$(PAPERS): $(BIBS)
	$(PYTHON) _papers/bib2json.py \
	    -s _papers/strings.bib _papers/rmm-[cjptwu]*.bib \
	  >| $(PAPERS)

site: jss papers
	$(JEKYLL) build --trace --incremental

test: jss papers
	$(JEKYLLS) serve -H 0.0.0.0 -P $(PORT) --trace --watch --incremental

## mirage

FLAGS ?= -vv --net socket -t unix
CONFIG = _mirage/config.ml

configure:
	$(MIRAGE) configure -f $(CONFIG) $(FLAGS)

configure.xen:
	FLAGS="-vv --net direct" $(MIRAGE) configure $$FLAGS -f $(CONFIG) -t xen
configure.socket:
	FLAGS="-vv --net socket" $(MIRAGE) configure $$FLAGS -f $(CONFIG) -t unix
configure.direct:
	FLAGS="-vv --net direct" $(MIRAGE) configure $$FLAGS -f $(CONFIG) -t unix

build:
	cd _mirage && make build
