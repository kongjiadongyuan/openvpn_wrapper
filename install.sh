#!/bin/bash

source env.sh

docker volume create --name $SERVER_VOLUME_NAME
docker run -v $SERVER_VOLUME_NAME:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u udp://$SERVER_ADDR -d -D -b -c -s $VPN_SUBNET
docker run -v $SERVER_VOLUME_NAME:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki
docker run -v $SERVER_VOLUME_NAME:/etc/openvpn --name openvpn_server -d -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn
