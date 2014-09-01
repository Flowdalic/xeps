#!/usr/bin/env bash

set -e

XEP_SHORTNAME=$1

cp -r template xep-${XEP_SHORTNAME}
mv xep-${XEP_SHORTNAME}/xep-template.xml xep-${XEP_SHORTNAME}/xep-${XEP_SHORTNAME}.xml
sed -i "s/template/${XEP_SHORTNAME}/g" xep-${XEP_SHORTNAME}/Makefile
git add xep-${XEP_SHORTNAME}
