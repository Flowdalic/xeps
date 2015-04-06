#!/bin/bash

if [[ -z DEPLOY_TARGET && -f config ]]; then
	. config
	DEPLOY_TARGET=$REMOTEHOST:REMOTEDIR
fi

if [[ -z DEPLOY_TARGET ]]; then
	echo "DEPLOY_TARGET not set, aborting"
	exit 1
fi

rsync --archive \
	--delete \
	-v \
	-e ssh \
	--exclude=xmpp/ \
	--exclude=.git/ \
	./ "$DEPLOY_TARGET"
