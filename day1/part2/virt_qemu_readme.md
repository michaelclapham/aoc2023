# Using qemu to emulate arm64 device

QEMU can emulate a variety of real world arm based devices. 
However the performance of these can be terrible. 
For example the raspberry PI emulator has to emulate USB ethernet resulting in really slow download speeds.
If you don't need to emulate a specific peice of arm hardware, you can use the qemu virt board.
This virt board provides faster performance.

Following a tutorial here: https://translatedcode.wordpress.com/2016/11/03/installing-debian-on-qemus-32-bit-arm-virt-board/
For how to install ARM64 Debian on a QEMU virt board.

But the main peices are

1. Download the Debian netboot installer files

```
wget -O installer-initrd.gz wget https://deb.debian.org/debian/dists/bookworm/main/installer-arm64/current/images/netboot/debian-installer/arm64/initrd.gz
wget -O installer-vmlinuz wget https://deb.debian.org/debian/dists/bookworm/main/installer-arm64/current/images/netboot/debian-installer/arm64/linux
```

2. Create a virtual hard disk for the QEMU virtual machine.
```
qemu-img create -f qcow2 hda.qcow2 5G
```

3. Boot the Debian netboot installer in QEMU virt board using Linux Kernel direct loading
```
qemu-system-arm -M virt -m 1024 \
  -kernel installer-vmlinuz \
  -initrd installer-initrd.gz \
  -drive if=none,file=hda.qcow2,format=qcow2,id=hd \
  -device virtio-blk-device,drive=hd \
  -netdev user,id=mynet \
  -device virtio-net-device,netdev=mynet \
  -nographic -no-reboot
```

4. This will load a Debian installer that requires you to input a few prompts to:
- Pick language
- Setup keyboard layout
- Setup networking domain / proxy
- Opt in / out of package usage tracking
- Setup a password for the root user
- Setup a password for the non root user

This can then take a few hours to download the packages needed. This will install the operating system without a bootloader to hda.qcow2.

5. Once step 4 completes you will have to extract the Linux kernel and initrd files, in order to boot the Debian disk image.

I did this by making a copy of my hda.qcow2, then attached it to another QEMU Linux emulator that I could already boot by adding
`-drive if=none,file=hda2.qcow2,format=qcow2,id=hd` to the start command of that QEMU emulator.
Once I had that started up I could use SCP to copy the /boot/vmlinuz-6.1.0-16-arm64 and /boot/initrd.img-6.1.0-16-arm64 files off of the
Debian disk image.

6. With those files now extracted the final step is to use them to boot the QEMU arm emulator.

```
qemu-system-arm -M virt -m 1024 \
  -kernel vmlinuz-6.1.0-16-arm64 \
  -initrd initrd.img-6.1.0-16-arm64 \
  -append 'root=/dev/vda2' \
  -drive if=none,file=hda.qcow2,format=qcow2,id=hd \
  -device virtio-blk-device,drive=hd \
  -netdev user,id=mynet \
  -device virtio-net-device,netdev=mynet \
  -nographic
```

7. Enjoy your high performance ARM64 Debian emulator!