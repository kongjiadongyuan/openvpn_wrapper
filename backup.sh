#!/bin/bash

source env.sh
docker run -v $SERVER_VOLUME_NAME:/etc/openvpn --rm kylemanna/openvpn tar -cvf - -C /etc openvpn | xz > openvpn-backup.tar.xz
