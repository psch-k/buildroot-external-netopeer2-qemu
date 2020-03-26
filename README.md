This is a buildroot external layer for netopeer2.

## Build

You have to clone buildroot and this layer. When building, use the
appropriate defconfig in the `buildroot-external-netopeer2-qemu/configs`
directory.

```
git clone https://github.com/hthiery/buildroot.git -b feature-netopeer2-new-package
git clone https://github.com/hthiery/buildroot-external-netopeer2-qemu.git
mkdir build
cd build
make -C ../buildroot BR2_EXTERNAL=../buildroot-external-netopeer2-qemu O=`pwd` netopeer2_qemu_x86_64_defconfig
make
```

The resulting kernel and root filesystem will be put in the
`build/images` directory.

## Run in QEMU

```
qemu-system-x86_64 -M pc -kernel images/bzImage -drive file=images/rootfs.ext2,if=virtio,format=raw -append "rootwait root=/dev/vda console=tty1 console=ttyS0" -serial stdio -net nic,model=virtio -net user
```

Optionally add -smp N to emulate a SMP system with N CPUs.

The login prompt will appear in the graphical window.

Tested with QEMU emulator version 3.1.0 (Debian 1:3.1+dfsg-8+deb10u4)
