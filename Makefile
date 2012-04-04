.DEFAULT: test
.PHONY: test clean deploy css

GH_ROOT=/
CS_ROOT=/~rmm/

JEKYLL = jekyll
MIRROR = rsync -rvz --rsh=ssh --delete

clean:
	$(RM) -r _site css/screen.css
	git checkout -- _config.yml css/screen.css

css:
	sed 's!@SITE_ROOT@!${GH_ROOT}!g' _less/screen.css >| css/screen.css

test: css
	$(JEKYLL) --auto --serve

deploy:
	sed 's!@SITE_ROOT@!${CS_ROOT}!g' _less/screen.css >| css/screen.css
	sed -i '' 's!url_root: /!url_root: ${CS_ROOT}!;\
		 	s!analytics_id: UA-15796259-1!analytics_id: UA-15796259-2!' \
	  _config.yml
	$(JEKYLL)
	$(MIRROR) _site/ severn.cs.nott.ac.uk:/lhome/rmm/public_html
	git checkout -- _config.yml css/screen.css
