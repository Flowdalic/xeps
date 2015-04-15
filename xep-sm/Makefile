.PHONY: all clean

FROM_XMPP_GIT := xep.xsl xep.dtd xep.ent

all: xep-sm.html

xep.xsl: ../xmpp/extensions/xep.xsl
	cp $^ $@

xep.dtd: ../xmpp/extensions/xep.dtd
	cp $^ $@

xep.ent: ../xmpp/extensions/xep.ent
	cp $^ $@

xep-sm.html: xep-sm.xml $(FROM_XMPP_GIT)
	xsltproc $^ --output $@

clean:
	rm -f xep-sm.html
	rm -r $(FROM_XMPP_GIT)
