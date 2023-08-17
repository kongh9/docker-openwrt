#!/bin/bash

if [ $# -lt 1 ] ; then
    echo -e  "Create a container from image and start it or start an exist container.\nUsage: $0 [ -c image_name ] container_name"
    exit 1;
fi

wlan="wlan0"
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


##参数是container名称
_start_container() {
    ##如果已经在运行了则不用再次运行
    pid=$(sudo docker inspect -f '{{.State.Pid}}' $1)
    if [ $pid -eq 0 ] ; then
        echo "starting $1 ..."
        sudo docker container start $1
    fi

##    sudo docker network connect bridge $1
##    sudo docker container update --restart=unless-stopped $1
    $dir/setup_wifi.sh $wlan $1
}


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

    sudo docker container create --name $3 --network=bridge --restart=unless-stopped  --cap-add NET_ADMIN --cap-add NET_RAW --privileged $2 /sbin/init
    
    echo "setup the network..."
    sudo docker cp $dir/config/wireless $3:/etc/config/
    sudo docker cp $dir/config/dhcp $3:/etc/config/
    sudo docker cp $dir/config/network $3:/etc/config/
    sudo docker cp $dir/config/firewall $3:/etc/config/

    _start_container $3
else
    if [ $# != 1 ] ; then
        echo -e "Start an exist container.\nUsage: $0 container_name"
        exit 1;
    fi
    
    if ! sudo docker inspect $1 >/dev/null 2>&1; then
        echo "container $1 not exist.."
        exit 1;
    fi

    _start_container $1
fi

