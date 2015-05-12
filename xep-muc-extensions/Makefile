.PHONY: all clean

FROM_XMPP_GIT := xep.xsl xep.dtd xep.ent

all: xep-muc-extensions.html

xep.xsl: ../xmpp/extensions/xep.xsl
	cp $^ $@

xep.dtd: ../xmpp/extensions/xep.dtd
	cp $^ $@

xep.ent: ../xmpp/extensions/xep.ent
	cp $^ $@

xep-muc-extensions.html: xep-muc-extensions.xml $(FROM_XMPP_GIT)
	xsltproc $^ --output $@

clean:
	rm -f xep-muc-extensions.html
	rm -r $(FROM_XMPP_GIT)
