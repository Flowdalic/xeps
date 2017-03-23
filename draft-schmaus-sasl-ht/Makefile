.PHONY: all

RFC_NAME := draft-schmaus-sasl-ht

all: $(RFC_NAME).txt

%.txt: %.xml
	xml2rfc --text $<

%.xml: %.md
	mmark -xml2 -page $< > $@
