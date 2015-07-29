.PHONY: all clean

FROM_XMPP_GIT := xep.xsl xep.dtd xep.ent

all: xep-sm.html

xep.xsl: ../xsf-xeps/xep.xsl
	cp $^ $@

xep.dtd: ../xsf-xeps/xep.dtd
	cp $^ $@

xep.ent: ../xsf-xeps/xep.ent
	cp $^ $@

xep-sm.html: xep-sm.xml $(FROM_XMPP_GIT)
	xsltproc $^ --output $@

clean:
	rm -f xep-sm.html
	rm -r $(FROM_XMPP_GIT)
