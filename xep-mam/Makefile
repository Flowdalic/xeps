.PHONY: all clean

FROM_XMPP_GIT := xep.xsl xep.dtd xep.ent

all: xep-mam.html xep-mam-w-mid.html xep-mam-current.html

xep.xsl: ../xsf-xeps/xep.xsl
	cp $^ $@

xep.dtd: ../xsf-xeps/xep.dtd
	cp $^ $@

xep.ent: ../xsf-xeps/xep.ent
	cp $^ $@

xep-mam.html: xep-mam.xml $(FROM_XMPP_GIT)
	xsltproc $^ --output $@

xep-mam-w-mid.html: xep-mam-w-mid.xml $(FROM_XMPP_GIT)
	xsltproc $^ --output $@

xep-mam-current.html: xep-mam-current.xml $(FROM_XMPP_GIT)
	xsltproc $^ --output $@

clean:
	rm -f xep-mam.html
	rm -r $(FROM_XMPP_GIT)
