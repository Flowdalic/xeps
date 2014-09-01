.PHONY: all clean

all: xep-template.html

xep-template.html: xep-template.xml
	xsltproc $^ --output $@

clean:
	rm -f xep-template.html
