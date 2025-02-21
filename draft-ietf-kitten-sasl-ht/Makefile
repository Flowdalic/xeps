.PHONY: all clean lint lint-out lint-idnits-latest-release xml

RFC_NAME := draft-*-kitten-sasl-ht

RFCS_MD   := $(sort $(wildcard $(RFC_NAME)-*.md))
RFCS_XML  := $(patsubst %.md, %.xml, $(RFCS_MD))
RFCS_TXT  := $(patsubst %.md, %.txt, $(RFCS_MD))
RFCS_HTML := $(patsubst %.md, %.html, $(RFCS_MD))

NON_SNAPSHOT_RFCS_TXT := $(filter-out %-SNAPSHOT.txt, $(RFCS_TXT))

SNAPSHOT_HTML := $(filter %-SNAPSHOT.html, $(RFCS_HTML))

IDNITS_OUT_TAG := idnits-out
RFCS_IDNITS_OUT := $(patsubst %.txt, %.$(IDNITS_OUT_TAG).txt, $(NON_SNAPSHOT_RFCS_TXT))

RFC_XML_VER ?= 3

all: $(RFCS_TXT) $(RFCS_HTML)

clean:
	rm -rf *.xml *.txt *.html

lint: lint-idnits-latest-release

lint-out: $(RFCS_IDNITS_OUT)

xml: $(RFCS_XML)

# Checks the lastest version (using 'lastword') for nits.
lint-idnits-latest-release: $(lastword $(NON_SNAPSHOT_RFCS_TXT))
	idnits --verbose $<

%.$(IDNITS_OUT_TAG).txt: %.txt
	idnits --verbose $< > $@

%.txt: %.xml
	xml2rfc --v$(RFC_XML_VER) --text $<

%.html: %.xml
	xml2rfc --v$(RFC_XML_VER) --html $<

%.xml: %.md
	kramdown-rfc --v$(RFC_XML_VER) $< > $@
