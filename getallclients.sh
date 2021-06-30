#!/bin/bash
source env.sh

docker run -v $SERVER_VOLUME_NAME:/etc/openvpn --rm -it kylemanna/openvpn ovpn_getclient_all

if [ -d "$CLIENT_CONFIG_DIR" ]; then
	        rm -r $CLIENT_CONFIG_DIR
fi

docker cp $SERVER_DOCKER_NAME:/etc/openvpn/clients $CLIENT_CONFIG_DIR
