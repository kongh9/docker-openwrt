#!/bin/bash


sudo rm -rf /var/run/netns/openwrt

if ! sudo docker network inspect macnet >/dev/null 2>&1; then
    sudo docker network disconnect bridge openwrt
else
    sudo docker network disconnect macnet openwrt
    sudo docker network rm macnet
fi
