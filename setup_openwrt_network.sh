#!/bin/bash

if [ $# != 1 ] ; then
echo -e  "Setup the network interface used by docker container. \nRun only once!\nUsage: $0 eth0/eth1/..."
exit 1;
fi


sudo ip link set $1 promisc on

if [ -n "$(sudo docker network ls | grep macnet)" ]; then
    echo "docker network macnet already exist."
    exit 1;
fi

gateway=$(ip route show | grep $1 | grep default | awk '{print $3}')
subnet=$(ip route show | grep $1 | grep link | awk '{print $1}')

if [ -n "$gateway" -a -n "$subnet" ]; then
    sudo docker network create -d macvlan --subnet=$subnet --gateway=$gateway -o parent=$1 macnet
fi
