.PHONY: all clean

# Finde the path to the Makefile, and the path to the directory of the
# Makefile. Credits to http://stackoverflow.com/a/18137056/194894
MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MKFILE_DIR := $(notdir $(patsubst %/,%,$(dir $(MKFILE_PATH))))
XEP := $(shell basename $(MKFILE_DIR))
FROM_XMPP_GIT := xep.xsl xep.dtd xep.ent xmpp.css prettify.css prettify.js

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

$(XEP).html: $(XEP).xml $(FROM_XMPP_GIT)
	xsltproc $^ --output $@

clean:
	rm -f $(XEP).html
	rm -r $(FROM_XMPP_GIT)
