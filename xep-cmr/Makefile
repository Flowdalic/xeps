.PHONY: all clean

all: xep-cmr.html

xep-cmr.html: xep-cmr.xml
	xsltproc $^ --output $@

clean:
	rm -f xep-cmr.html
