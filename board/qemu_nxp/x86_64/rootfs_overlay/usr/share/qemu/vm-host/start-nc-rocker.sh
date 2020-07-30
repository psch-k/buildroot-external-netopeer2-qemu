#!/bin/bash

a=${1:-0}

ROOTDIR=/mnt/vms/dev/netop/boot

qemu-kvm \
  -nographic \
  -serial mon:stdio \
  -m 2048 \
  -smp 2,cores=2,maxcpus=2 \
  -M pc \
  -kernel ${ROOTDIR}/bzImage-${a} \
  -drive file=${ROOTDIR}/rootfs-${a}.ext2,if=virtio,format=raw \
  -append "rootwait root=/dev/vda console=tty1 console=ttyS0" \
  -netdev tap,id=mgmt,ifname=vmgmt,script=/etc/qemu-mgmt-ifup,downscript=/etc/qemu-mgmt-ifdown,br=qbr0 \
  -device virtio-net,netdev=mgmt,mac=02:20:20:03:26:17 \
-netdev tap,id=dev1,ifname=sw1p1,script=/etc/qemu-switchport-ifup,downscript=no \
-netdev tap,id=dev2,ifname=sw1p2,script=/etc/qemu-switchport-ifup,downscript=no \
-netdev tap,id=dev3,ifname=sw1p3,script=/etc/qemu-switchport-ifup,downscript=no \
-netdev tap,id=dev4,ifname=sw1p4,script=/etc/qemu-switchport-ifup,downscript=no \
-device rocker,name=sw1,len-ports=4,ports[0]=dev1,ports[1]=dev2,ports[2]=dev3,ports[3]=dev4

