.PHONY: all clean

FROM_XMPP_GIT := xep.xsl xep.dtd xep.ent

all: xep-openpgp.html

xep.xsl: ../xsf-xeps/xep.xsl
	cp $^ $@

xep.dtd: ../xsf-xeps/xep.dtd
	cp $^ $@

xep.ent: ../xsf-xeps/xep.ent
	cp $^ $@

xep-openpgp.html: xep-openpgp.xml $(FROM_XMPP_GIT)
	xsltproc $^ --output $@

clean:
	rm -f xep-openpgp.html
	rm -r $(FROM_XMPP_GIT)
