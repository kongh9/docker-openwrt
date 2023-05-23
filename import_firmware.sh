#!/bin/bash

if [ $# != 2 ] ; then
echo "usage: $0 openwrt-squashfs-fireware-url image_name"
exit 1;
fi

echo "deleting old image $2"
sudo docker image rm -f  $2

tmpdir=$(mktemp -u -p .)

wget "$1" -O- | gzip -d > image.img
offset=$(sfdisk -d image.img | grep "image.img2" | sed -E 's/.*start=\s+([0-9]+).*/\1/g')
fakeroot unsquashfs -no-progress -quiet -offset $(( 512 * $offset )) -dest "$tmpdir" image.img
fakeroot tar czf rootfs.tar.gz -C "$tmpdir" .
sudo docker import rootfs.tar.gz $2
rm -rf "$tmpdir"
rm image.img
rm rootfs.tar.gz




