.PHONY: all clean lint lint-out lint-idnits xml

RFC_NAME := draft-schmaus-kitten-sasl-ht

RFCS_MD   := $(wildcard $(RFC_NAME)-*.md)
RFCS_XML  := $(patsubst %.md, %.xml, $(RFCS_MD))
RFCS_TXT  := $(patsubst %.md, %.txt, $(RFCS_MD))
RFCS_HTML := $(patsubst %.md, %.html, $(RFCS_MD))

IDNITS_OUT_TAG := idnits-out
RFCS_IDNITS_OUT := $(patsubst %.md, %.$(IDNITS_OUT_TAG).txt, $(RFCS_MD))

all: $(RFCS_TXT) $(RFCS_HTML)

clean:
	rm -rf *.xml *.txt *.html

lint: lint-idnits

lint-out: $(RFCS_IDNITS_OUT)

xml: $(RFCS_XML)

# Checks the lastest version (using 'lastword') for nits.
lint-idnits: $(lastword $(RFCS_TXT))
	idnits --verbose $<

%.$(IDNITS_OUT_TAG).txt: %.xml
	idnits --verbose $< > $@

%.txt: %.xml
	xml2rfc --text $<

%.html: %.xml
	xml2rfc --html $<

%.xml: %.md
	mmark -xml2 -page $< > $@
