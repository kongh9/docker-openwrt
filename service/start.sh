#!/bin/bash

networks=(`ls /sys/class/net`)

eths=()
wlans=()

##把有线网卡与无线网卡分开
for file in ${networks[@]}
do 
    n=$(basename ${file})
    if [[ $n == "lo" || $n == "docker0" || $n == "wlan0" ]]; then
        continue

    fi
    if [ -e /sys/class/net/$n/phy80211 ] || [ -e /sys/class/net/$n/wireless ]; then
        wlans[${#wlans[@]}]=$n

    else
        eths[${#eths[@]}]=$n    
    fi
done

##把有线网卡和无线网卡重新合并在一起
##这样做的目的是为了把有线网卡排在无线网卡前面，有有线网卡则先使用有线网卡
networks=(${eths[@]} ${wlans[*]})

##找到第一个已经联网的网卡
active_net=()
for n in ${networks[@]}
do 
    active=`ip addr show $n | grep "state UP" | awk '{print $2}'`
    if [ -n $n ]; then
        active_net[${#active_net[@]}]=$n
        break
    fi
done

##如果找不到任何已经联网的网卡，则使用docker0网卡作为临时先使用的网卡来启动openwrt
if [ ${#active_net[@]} -eq 0 ]; then
    active_net[0]="docker0"
fi

echo "Using ${active_net[0]} ..."
/home/pi/openwrt/setup_openwrt_network.sh ${active_net[0]}

if ! sudo docker network inspect macnet >/dev/null 2>&1; then
    sudo docker network connect bridge openwrt
else
    sudo docker network connect macnet openwrt
fi

/home/pi/openwrt/start.sh openwrt
