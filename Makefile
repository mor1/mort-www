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

.PHONY: all clean distclean site test papers configure build

DOCKER = docker run -it --rm
COFFEE = $(DOCKER) -v `pwd`:/pwd -w /pwd shouldbee/coffeescript coffee
JEKYLL = $(DOCKER) -v `pwd`:/srv/jekyll jekyll/jekyll:pages jekyll
JEKYLLS = $(DOCKER) -v `pwd`:/srv/jekyll -p 4000:4000 -p 80:80 jekyll/jekyll:pages jekyll
MIRAGE = mirage

BIBS = $(wildcard ~/me/publications/rmm-*.bib)
COFFEES = $(notdir $(wildcard _coffee/*.coffee))
JSS = $(patsubst %.coffee,js/%.js,$(COFFEES))

PAPERS = research/papers/papers.json
FLAGS ?=
MIRFLAGS ?= --no-opam

all: jss papers

clean:
	$(RM) log
	cd _mirage \
	  && ( [ -r _mirage/Makefile ] && make clean ) || true \
	  && $(RM) log mir-mortio main.ml Makefile mortio* *.cmt static*.ml*

distclean: | clean
	$(RM) -r _site _coffee/*.js js/*.js $(PAPERS)

jss: $(JSS)
js/%.js: _coffee/%.coffee
	$(COFFEE) -c -o js $<

papers: $(PAPERS) research/papers/authors.json
$(PAPERS): $(BIBS)
	~/src/python-scripts/bib2json.py \
	    -s ~/me/publications/strings.bib ~/me/publications/rmm-[cjptwu]*.bib \
	  >| $(PAPERS)

site: jss papers
	$(JEKYLL) build --trace $(FLAGS)

test: site
	$(JEKYLLS) serve --trace --watch --skip-initial-build $(FLAGS)

## mirage

FS    ?= direct
NET   ?= socket
PORT  ?= 4000

configure:
	FS=$(FS) NET=$(NET) PORT=$(PORT) ADDR=$(ADDR) MASK=$(MASK) GWS=$(GWS) \
		$(MIRAGE) configure _mirage/config.ml --$(MODE)

configure.xen:
	MODE=xen ADDR=$(ADDR) MASK=$(MASK) GWS=$(GWS) \
		$(MIRAGE) configure $(MIRFLAGS) _mirage/config.ml --$(MODE)

configure.socket:
	MODE=unix FS=direct NET=socket \
		$(MIRAGE) configure $(MIRFLAGS) _mirage/config.ml --$(MODE)

configure.direct:
	MODE=unix FS=direct NET=direct DHCP=true \
		$(MIRAGE) configure $(MIRFLAGS) _mirage/config.ml --$(MODE)

build:
	cd _mirage && make build
