Using a tutoral here for how to setup a Raspberry PI (Arm based) emulator on x86_64 Ubuntu
https://interrupt.memfault.com/blog/emulating-raspberry-pi-in-qemu

Main commands are as follows

```
apt-get install -y qemu-system-aarch64

cd ~/qemu/rasp
wget https://downloads.raspberrypi.org/raspios_arm64/images/raspios_arm64-2023-05-03/2023-05-03-raspios-bullseye-arm64.img.xz
xz -d 2023-05-03-raspios-bullseye-arm64.img.xz

sudo mkdir /mnt/image
sudo mount -o loop,offset=4194304 ./2023-05-03-raspios-bullseye-arm64.img /mnt/image/

# Need to copy device tree and kernel from image to run via QEMU
cp /mnt/image/bcm2710-rpi-3-b-plus.dtb ~/qemu/rasp
cp /mnt/image/kernel8.img ~/qemu/rasp

# Generate hashed user password. set to raspberry for ease
openssl passwd -6

# If setting the user password to something other than raspberry replace it in the
# field we are adding to the users file
echo 'pi:$6$rBoByrWRKMY1EHFy$ho.LISnfm83CLBWBE/yqJ6Lq1TinRlxw/ImMTPcvvMuUfhQYcMmFnpFXUPowjy2br1NA0IACwF9JKugSNuHoe0' | sudo tee /mnt/image/userconf

# Enable SSH
sudo touch /mnt/image/ssh

# Resize image
qemu-img resize ./2023-05-03-raspios-bullseye-arm64.img 8G

# Start QEMU
qemu-system-aarch64 -machine raspi3b -cpu cortex-a72 -nographic -dtb bcm2710-rpi-3-b-plus.dtb -m 1G -smp 4 -kernel kernel8.img -sd 2023-05-03-raspios-bullseye-arm64.img -append "rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 rootdelay=1" -device usb-net,netdev=net0 -netdev user,id=net0,hostfwd=tcp::2222-:22

# SSH into emulator
ssh -p 2222 pi@localhost

```