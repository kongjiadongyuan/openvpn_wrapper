#!/bin/bash

source env.sh

docker volume create --name $SERVER_VOLUME_NAME
if [ "$RESTORE" = "true" ]; then
	xzcat $RESTORE_PATH | docker run -v $SERVER_VOLUME_NAME:/etc/openvpn -i kylemanna/openvpn tar -xvf - -C /etc
fi

docker run -v $SERVER_VOLUME_NAME:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u $CONNECT_METHOD://$SERVER_ADDR:$CONNECT_PORT -d -D -b -c -s $VPN_SUBNET
docker run -v $SERVER_VOLUME_NAME:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki
docker run -v $SERVER_VOLUME_NAME:/etc/openvpn --name $SERVER_DOCKER_NAME --restart=always -d -p $CONNECT_PORT:1194/$CONNECT_METHOD --cap-add=NET_ADMIN kylemanna/openvpn

# edit ovpn_run
docker exec $SERVER_DOCKER_NAME sed -i "2i /usr/local/bin/iptables.sh" /usr/local/bin/ovpn_run
echo "#!/bin/sh" | docker exec -i $SERVER_DOCKER_NAME tee -a /usr/local/bin/iptables.sh
docker exec $SERVER_DOCKER_NAME chmod +x /usr/local/bin/iptables.sh

python3 refreshconfig.py
