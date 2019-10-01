#!/bin/bash

# defaults
# SERVICE=h5p
# VERSION=0.1
# NETWORK=dev-net
# PORT=57301

# input with four arguments: go.sh SERVICE VERSION NETWORK PORT
if [ "$1" != "" ]; then
        SERVICE=$1
fi
if [ "$2" != "" ]; then
        VERSION=$2
fi
if [ "$3" != "" ]; then
        NETWORK=$3
fi
if [ "$4" != "" ]; then
        PORT=$4
fi

if [ $NETWORK == "dev-net" ]; then
        export STACK_DOMAIN=h5p.dev.dlo.surf.nl
        export STACK_NETWORK_URL_IDP=https://idp.dev.dlo.surf.nl
        export STACK_NETWORK_IDP_FINGERPRINT=D9:BD:30:11:E7:1D:12:FA:92:E9:3F:95:D6:C4:24:B5:CD:D3:6F:AF
fi
if [ $NETWORK == "test-net" ]; then
        export STACK_DOMAIN=h5p.test.dlo.surf.nl
        export STACK_NETWORK_URL_IDP=https://idp.test.dlo.surf.nl
        export STACK_NETWORK_IDP_FINGERPRINT=54:14:99:9B:9F:91:BE:DE:BA:0E:00:87:4A:88:35:49:68:F9:D9:82
fi
if [ $NETWORK == "exp-net" ]; then
        export STACK_DOMAIN=h5p.experimenteer.dlo.surf.nl
        export STACK_NETWORK_URL_IDP=https://idp.experimenteer.dlo.surf.nl
        export STACK_NETWORK_IDP_FINGERPRINT=D5:42:1D:BB:9F:CE:2F:2E:F7:B5:06:A1:D3:DA:A9:48:D9:3F:21:0B
fi

# reuse input
export STACK_SERVICE=$SERVICE
export STACK_VERSION=$VERSION
export STACK_NETWORK=$NETWORK
export STACK_PORT=$PORT

# source
export STACK_REPOSITORY=h5p

# delete previous version
# note: geen rollback!
docker stack rm $STACK_SERVICE

# prepare
./prepare.sh

# go
docker stack deploy --with-registry-auth -c docker-compose.yml $STACK_SERVICE

