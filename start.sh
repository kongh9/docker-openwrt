#!/bin/bash

if [ $# -lt 1 ] ; then
    echo -e  "Create a container from image and start it or start an exist container.\nUsage: $0 [ -c image_name ]  container_name"
    exit 1;
fi

wlan="wlan0"
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ "$1" = "-c" ] ; then
    if [ $# != 3 ] ; then
        echo -e "Create a container from image and start it.\nUsage: $0 -c image_name container_name"
        exit 1;
    fi
    if ! sudo docker inspect $2 >/dev/null 2>&1; then
        echo "image $2 not found, please deploy the image first."
        exit 1
    fi

    if  sudo docker inspect -f '{{.State.Pid}}' $3 >/dev/null 2>&1; then
        echo "container $3 already exist."
        exit 1
    fi

    sudo docker container create --name $3 --privileged $2 /sbin/init
    
    echo "setup the network..."
    sudo docker cp $dir/config/wireless $3:/etc/config/
    sudo docker cp $dir/config/dhcp $3:/etc/config/
    sudo docker cp $dir/config/network $3:/etc/config/
    sudo docker cp $dir/config/firewall $3:/etc/config/
    sudo docker network connect macnet $3
    
    sudo docker container start $3
    sudo docker container update --restart=always $3
    $dir/setup_wifi.sh $wlan $3
else
    if [ $# != 1 ] ; then
        echo -e "Start an exist container.\nUsage: $0 container_name"
        exit 1;
    fi
    
    if ! sudo docker inspect $1 >/dev/null 2>&1; then
        echo "container $1 not exist.."
        exit 1;
    fi

    pid=$(sudo docker inspect -f '{{.State.Pid}}' $1)
    if [ $pid -gt 0 ] ; then
        echo "container $1 already running"
        $dir/setup_wifi.sh $wlan $1
        exit 1;
    fi

    sudo docker container start $1
    sudo docker container update --restart=always $1

    $dir/setup_wifi.sh $wlan $1
fi

