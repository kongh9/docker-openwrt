#!/bin/bash

if [ $# != 1 ] ; then
echo "usage: $0 container_name"
exit 1;
fi

sudo docker rm -f $1


