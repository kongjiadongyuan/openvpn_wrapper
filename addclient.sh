#!/bin/bash

source env.sh

docker run -v $SERVER_VOLUME_NAME:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full $1 nopass
docker run -v $SERVER_VOLUME_NAME:/etc/openvpn --rm -it kylemanna/openvpn ovpn_getclient $1 > client_files/$1.ovpn


