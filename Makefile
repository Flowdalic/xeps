FROM_XMPP_GIT := xmpp.css prettify.js prettify.css template/xep.xsl template/xep.dtd template/xep.ent template/xep-template.xml
XEPS := $(shell find -mindepth 1 -maxdepth 1 -type d -name 'xep-*')

.PHONY: all clean distclean init sync $(XEPS)

all: $(XEPS) init

init: $(FROM_XMPP_GIT)

clean:
	rm -rf $(FROM_XMPP_GIT)

distclean:
	rm -rf $(FROM_XMPP_GIT)
	TARGET=clean $(MAKE) $(XEPS)

xmpp.css: xmpp/xmpp.css
	cp $^ $@

prettify.css: xmpp/prettify.css
	cp $^ $@

prettify.js: xmpp/prettify.js
	cp $^ $@

template/xep.xsl: xmpp/extensions/xep.xsl
	cp $^ $@

template/xep.dtd: xmpp/extensions/xep.dtd
	cp $^ $@

template/xep.ent: xmpp/extensions/xep.ent
	cp $^ $@

template/xep-template.xml: xmpp/extensions/xep-template.xml
	cp $^ $@

$(XEPS):
	$(MAKE) -C $@ $(TARGET)

sync: all
	./sync.sh
