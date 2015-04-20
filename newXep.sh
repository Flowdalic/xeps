#!/usr/bin/env bash

set -e
set -x

XEP_SHORTNAME=$1

cp -r xep-template "xep-${XEP_SHORTNAME}"
rm "xep-${XEP_SHORTNAME}/xep-template.xml"
cp xmpp/extensions/xep-template.xml "xep-${XEP_SHORTNAME}/xep-${XEP_SHORTNAME}.xml"
sed -i "s/template/${XEP_SHORTNAME}/g" "xep-${XEP_SHORTNAME}/Makefile"
git add "xep-${XEP_SHORTNAME}"
