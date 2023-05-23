#!/bin/bash

if [ $# != 1 ] ; then
echo "usage: $0 container_name"
exit 1;
fi

wlan="wlan0"

if ! sudo docker inspect $1 >/dev/null 2>&1; then
    echo "container $1 not found."
    exit 1
fi

sudo docker container restart $1

./setup_wifi.sh $wlan $1  
