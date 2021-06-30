#!/bin/bash
source env.sh
docker run --rm -v $(pwd):/backup -v $SERVER_VOLUME_NAME:/vol busybox tar -zcvf /backup/$SERVER_VOLUME_NAME.tar.gz /vol
