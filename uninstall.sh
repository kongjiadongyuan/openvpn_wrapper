#!/bin/bash

source env.sh
docker container rm -f $SERVER_DOCKER_NAME
docker volume rm -f $SERVER_VOLUME_NAME
