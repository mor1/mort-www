# Copyright (C) 2012 Richard Mortier <mort@cantab.net>.
# All Rights Reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
# USA.

.PHONY: clean css site js test deploy

GH_ROOT=/
CS_ROOT=/~rmm/

COFFEE = coffee
JEKYLL = jekyll
MIRROR = rsync -rvz --rsh=ssh --delete

COFFEES = $(notdir $(wildcard _coffee/*.coffee))
JSS = $(patsubst %.coffee,js/%.js,$(COFFEES))

site: css js papers/papers.json
	$(JEKYLL) build

clean:
	$(RM) -r _site css/screen.css
	$(RM) $(JSS) $(wildcard _coffee/*.js)
	git checkout -- _config.yml css/screen.css

css: css/screen.css
css/screen.css: _less/screen.css
	sed 's!@BASEURL@!${GH_ROOT}!g' _less/screen.css >| css/screen.css

js: $(JSS)

test: css js
	$(JEKYLL) serve --watch

deploy: js
	sed 's!@BASEURL@!${CS_ROOT}!g' _less/screen.css >| css/screen.css
	sed -i '' 's!baseurl: /!baseurl: ${CS_ROOT}!;\
		s!analytics_id: UA-15796259-1!analytics_id: UA-15796259-2!' \
				_config.yml
	$(JEKYLL) build
	$(MIRROR) _site/ severn.cs.nott.ac.uk:/lhome/rmm/public_html
	git checkout -- _config.yml css/screen.css

papers/papers.json: $(wildcard ~/research/papers/my-bibs/rmm-*.bib)
	~/src/python-scripts.git/bib2json.py \
	  -s ~/research/papers/my-bibs/strings.bib \
	  ~/research/papers/my-bibs/rmm-[cjptw]*.bib \
	 >| papers/papers.json

js/%.js: _coffee/%.coffee
	$(COFFEE) -c -o js $<
