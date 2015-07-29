.PHONY: all clean

FROM_XMPP_GIT := xep.xsl xep.dtd xep.ent

all: xep-cmr.html

xep.xsl: ../xsf-xeps/xep.xsl
	cp $^ $@

xep.dtd: ../xsf-xeps/xep.dtd
	cp $^ $@

xep.ent: ../xsf-xeps/xep.ent
	cp $^ $@

xep-cmr.html: xep-cmr.xml $(FROM_XMPP_GIT)
	xsltproc $^ --output $@

clean:
	rm -f xep-cmr.html
	rm -r $(FROM_XMPP_GIT)
