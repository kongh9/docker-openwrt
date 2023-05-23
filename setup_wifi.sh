#!/bin/bash

if [ $# != 2 ] ; then
echo "usage: $0 wifi_interface_to_attach container_name"
exit 1;
fi

WIFI_IFACE=$1
CONTAINER=$2

if ! sudo docker inspect $2 >/dev/null 2>&1; then
    echo "container $2 not found."
    exit 1
fi


if [[ -f /sys/class/net/$WIFI_IFACE/phy80211/name ]]; then
        WIFI_PHY=$(cat /sys/class/net/$WIFI_IFACE/phy80211/name 2>/dev/null)
	echo "* moving device $WIFI_PHY to docker network namespace"
        pid=$(sudo docker inspect -f '{{.State.Pid}}' $CONTAINER)
        echo "* creating netns symlink '$CONTAINER'"
        sudo mkdir -p /var/run/netns
        sudo ln -sf /proc/$pid/ns/net /var/run/netns/$CONTAINER

	sudo iw phy "$WIFI_PHY" set netns $pid
        echo "* bring up wifi"
        sudo docker exec $CONTAINER wifi up
else
        echo "$WIFI_IFACE is not a valid phy80211 device"
        exit 1
fi

