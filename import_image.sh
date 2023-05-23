#!/bin/bash

if [ $# != 2 ] ; then
echo "usage: $0 openwrt-imagefile-location image_name"
exit 1;
fi

echo "deleting old image $2"
sudo docker image rm -f  $2

sudo docker import $1 $2

