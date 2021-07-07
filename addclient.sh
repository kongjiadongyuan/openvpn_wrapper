#!/bin/bash

source env.sh

docker run -v $SERVER_VOLUME_NAME:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full $@


