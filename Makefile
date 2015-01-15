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

BIBS = $(wildcard ~/me/footprint/publications/rmm-*.bib)
PAPERS = research/papers/data/papers.json
DRAFTS ?=

all: site

clean:
	$(RM) -r _site
distclean: | clean
	$(RM) -r $(PAPERS)

site: papers
	jekyll build --trace --$(DRAFTS)

test: site
	jekyll serve --trace --watch --skip-initial-build

papers: $(PAPERS)
$(PAPERS): $(BIBS)
	~/src/python-scripts/bib2json.py \
	    -s ~/me/footprint/publications/strings.bib \
	    ~/me/footprint/publications/rmm-[cjptwu]*.bib \
	  >| $(PAPERS)
