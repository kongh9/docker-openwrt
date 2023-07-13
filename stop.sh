#!/bin/bash

if [ $# != 1 ] ; then
echo "usage: $0  container_name"
exit 1;
fi

if ! sudo docker inspect $1 >/dev/null 2>&1; then
    echo "container $1 not found."
    exit 1
fi
sudo docker network disconnect bridge $1

sudo docker container stop $1
