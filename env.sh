#!/bin/bash

CONNECT_METHOD="tcp"
# CONNECT_METHOD="udp"
CONNECT_PORT="22"
SERVER_DOCKER_NAME="openvpn_server"
SERVER_VOLUME_NAME="ovpn_data"
SERVER_ADDR="your.server.address"
VPN_SUBNET="10.97.213.0/24"
CLIENT_CONFIG_DIR="client_files"

RESTORE="false"
RESTORE_PATH="openvpn-backup.tar.xz"
