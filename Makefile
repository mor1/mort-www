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

.PHONY: clean distclean jss papers site test drafts \
        $(JSS) $(PAPERS) $(AUTHORS) configure build

help: # list targets
	@egrep "^\S+:" Makefile \
	  | grep -v "^.PHONY" \
	  | awk -F"\s*#\s*" \
	      '{ if (length($2) != 0) printf("-- %s\n  %s\n\n", $$1, $$2) }'

PORT  ?= 8080
MIRAGE = cd _mirage && \
	DOCKER_FLAGS="$$DOCKER_FLAGS -v $$(realpath ../_site):/cwd/.site:ro -p $(PORT)" \
	  dommage

DOCKER = docker run -ti -v $$(pwd -P):/cwd -w /cwd $$DOCKER_FLAGS
COFFEE = $(DOCKER) mor1/coffeescript
JEKYLL = $(DOCKER) mor1/jekyll
JEKYLLS = $(DOCKER) -p $(PORT):$(PORT) mor1/jekyll
PYTHON = $(DOCKER) mor1/python3

BIBS = $(wildcard ~/me/publications/rmm-*.bib)
COFFEES = $(notdir $(wildcard _coffee/*.coffee))
JSS = $(patsubst %.coffee,js/%.js,$(COFFEES))

PAPERS = research/papers/papers.json
AUTHORS= research/papers/authors.json

clean: # remove build artefacts
	$(RM) -r _mirage/_build
	$(MIRAGE) clean || true
	cd _mirage && mirage clean || true
	$(RM) -r _mirage/_build
	rmdir _mirage/.site

distclean: | clean # also remove built assets
	$(RM) -r _site
	$(RM) -r _coffee/*.js js/*.js $(PAPERS)

jss: $(JSS) # build all .js files
js/%.js: _coffee/%.coffee # create .js from .coffee
	$(COFFEE) -c -o js $<

papers: $(PAPERS) $(AUTHORS) # create JSON data for papers
$(PAPERS): $(BIBS) # build `papers.json`
	$(PYTHON) _papers/bib2json.py \
	    -s _papers/strings.bib _papers/rmm-[cjptwu]*.bib \
	  | tr '\r\n' '\n' \
	  >| $(PAPERS)

site: jss papers # build site
	$(JEKYLL) build --trace

test: jss papers # serve site for testing
	$(JEKYLLS) serve -H 0.0.0.0 -P $(PORT) --trace --watch --future

drafts: jss papers # serve site, including draft posts
	$(JEKYLLS) serve -H 0.0.0.0 -P $(PORT) --trace --watch --future --drafts

FLAGS ?= -vv --net socket -t unix --port $(PORT)
configure: site
	$(MIRAGE) configure $(FLAGS)

configure.socket:
	$(MIRAGE) configure -t unix -vv --net socket --port $(PORT)
configure.direct:
	$(MIRAGE) configure -t unix -vv --net direct --port $(PORT)
configure.xen:
	$(MIRAGE) configure -t xen  -vv --net direct --port $(PORT) --dhcp false \
	  --interface 0 --ipv4 46.43.42.137/25 --ipv4-gateway 46.43.42.129

build:
	$(MIRAGE) build

publish:
	$(MIRAGE) publish mor1/www

destroy:
	$(MIRAGE) destroy

run:
	$(MIRAGE) run ./mortio
