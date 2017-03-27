.PHONY: all clean lint lint-idnits

RFC_NAME := draft-schmaus-kitten-sasl-ht-00

all: $(RFC_NAME).txt $(RFC_NAME).html

clean:
	rm -rf *.xml *.txt

lint: lint-idnits

lint-idnits: $(RFC_NAME).txt
	idnits --verbose $<

%.txt: %.xml
	xml2rfc --text $<

%.html: %.xml
	xml2rfc --html $<

%.xml: %.md
	mmark -xml2 -page $< > $@
