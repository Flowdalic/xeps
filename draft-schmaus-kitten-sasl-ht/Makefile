.PHONY: all clean lint lint-idnits xml

RFC_NAME := draft-schmaus-kitten-sasl-ht

RFCS_MD   := $(wildcard $(RFC_NAME)-*.md)
RFCS_XML  := $(patsubst %.md, %.xml, $(RFCS_MD))
RFCS_TXT  := $(patsubst %.md, %.txt, $(RFCS_MD))
RFCS_HTML := $(patsubst %.md, %.html, $(RFCS_MD))

all: $(RFCS_TXT) $(RFCS_HTML)

clean:
	rm -rf *.xml *.txt *.html

lint: lint-idnits

xml: $(RFCS_XML)

lint-idnits: $(RFCS_TXT)
	idnits --verbose $<

%.txt: %.xml
	xml2rfc --text $<

%.html: %.xml
	xml2rfc --html $<

%.xml: %.md
	mmark -xml2 -page $< > $@
