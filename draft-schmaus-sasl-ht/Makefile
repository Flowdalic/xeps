.PHONY: all clean

RFC_NAME := draft-schmaus-sasl-ht

all: $(RFC_NAME).txt $(RFC_NAME).html

clean:
	rm -rf *.xml *.txt

%.txt: %.xml
	xml2rfc --text $<

%.html: %.xml
	xml2rfc --html $<

%.xml: %.md
	mmark -xml2 -page $< > $@
