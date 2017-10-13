.PHONY: all clean

# Finde the path to the Makefile, and the path to the directory of the
# Makefile. Credits to http://stackoverflow.com/a/18137056/194894
MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MKFILE_DIR := $(notdir $(patsubst %/,%,$(dir $(MKFILE_PATH))))
XEP := $(shell basename $(MKFILE_DIR))
FROM_XMPP_GIT := xep.xsl xep.dtd xep.ent xmpp.css prettify.css prettify.js

ifneq ($(wildcard xep-official.xml),)
OFFICIAL_XEP_FOUND := true
else
OFFICIAL_XEP_FOUND := false
endif

ifeq ($(OFFICIAL_XEP_FOUND), true)
all: xep-official.html
endif

ifeq (,$(shell which htmldiff 2> /dev/null))
HTMLDIFF_BINARY_AVAILABLE := false
else
HTMLDIFF_BINARY_AVAILABLE := true
endif

DIFF_HTML := diff.html diff-side-by-side.html
ifeq (true, $(and $(findstring true, $(HTMLDIFF_BINARY_AVAILABLE)), $(findstring true, $(OFFICIAL_XEP_FOUND))))
all: $(DIFF_HTML)
endif

all: $(XEP).html

xep.xsl: ../xsf-xeps/xep.xsl
	cp $^ $@

xep.dtd: ../xsf-xeps/xep.dtd
	cp $^ $@

xep.ent: ../xsf-xeps/xep.ent
	cp $^ $@

xmpp.css: ../xsf-xeps/xmpp.css
	cp $^ $@

prettify.css: ../xsf-xeps/prettify.css
	cp $^ $@

prettify.js: ../xsf-xeps/prettify.js
	cp $^ $@

%.html: %.xml $(FROM_XMPP_GIT)
	xsltproc $^ --output $@

COMMON_DIFF_PREREQUISITES := xep-official.html $(XEP).html

diff.html: $(COMMON_DIFF_PREREQUISITES)
	htmldiff -a $^ > $@

diff-side-by-side.html: $(COMMON_DIFF_PREREQUISITES)
	htmldiff -a -s $^ > $@

clean:
	rm -f $(XEP).html
	rm -f $(FROM_XMPP_GIT)
	rm -f $(DIFF_HTML)
	rm -f xep-official.html
