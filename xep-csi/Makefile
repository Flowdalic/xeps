.PHONY: all clean

FROM_XMPP_GIT := xep.xsl xep.dtd xep.ent

all: xep-csi.html

xep.xsl: ../xsf-xeps/xep.xsl
	cp $^ $@

xep.dtd: ../xsf-xeps/xep.dtd
	cp $^ $@

xep.ent: ../xsf-xeps/xep.ent
	cp $^ $@

xep-csi.html: xep-csi.xml $(FROM_XMPP_GIT)
	xsltproc $^ --output $@

clean:
	rm -f xep-csi.html
	rm -r $(FROM_XMPP_GIT)
