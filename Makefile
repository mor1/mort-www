MIRAGE = mirage
MODE ?= unix
FS_MODE ?= crunch
BFLAGS ?=

configure:
	$(MIRAGE) configure src/config.ml $(BFLAGS) --$(MODE)

build:
	$(MIRAGE) build src/config.ml $(BFLAGS) --$(MODE)

run:
	$(MIRAGE) run src/config.ml --$(MODE)

clean:
	$(MIRAGE) clean src/config.ml $(BFLAGS)
