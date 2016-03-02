#!/bin/bash
set -ex

# device specific settings
HYPRIOT_DEVICE="ODROID U2/U3"

# set up /etc/resolv.conf
echo "nameserver 8.8.8.8" > /etc/resolv.conf

# set up Hypriot Schatzkiste repository
wget -q https://packagecloud.io/gpg.key -O - | apt-key add -
echo 'deb https://packagecloud.io/Hypriot/Schatzkiste/debian/ wheezy main' > /etc/apt/sources.list.d/hypriot.list

# set up odroid repository
wget -O- http://oph.mdrjr.net/meveric/meveric.asc | apt-key add -
echo 'deb http://oph.mdrjr.net/meveric wheezy main' > /etc/apt/sources.list.d/odroid-meveric.list
# wget /etc/apt/sources.list.d/meveric-wheezy-main.list http://oph.mdrjr.net/meveric/sources.lists/meveric-wheezy-main.list

# update all apt repository lists
export DEBIAN_FRONTEND=noninteractive
apt-get update

# ---install Docker tools---

# install Hypriot packages for using Docker
apt-get install -y \
  "docker-hypriot=${DOCKER_ENGINE_VERSION}" \
  "docker-compose=${DOCKER_COMPOSE_VERSION}" \
  "docker-machine=${DOCKER_MACHINE_VERSION}"

#FIXME: should be handled in .deb package
# setup Docker default configuration for ODROID xu4
rm -f /etc/init.d/docker # we're using a pure systemd init, remove sysvinit script
rm -f /etc/default/docker
# --get upstream config
wget -q -O /etc/default/docker https://github.com/docker/docker/raw/master/contrib/init/sysvinit-debian/docker.default
# --enable aufs by default
sed -i "/#DOCKER_OPTS/a \
DOCKER_OPTS=\"--storage-driver=aufs -D\"" /etc/default/docker

#FIXME: should be handled in .deb package
# enable Docker systemd service
systemctl enable docker

# install ODROID kernel

apt-get install -y u-boot-tools initramfs-tools

# make the kernel package create a copy of the current kernel here
#-don't create /media/boot, then all files will be installed in /boot
#mkdir -p /media/boot
apt-get install -y initramfs-tools
#wget -q -O /tmp/bootini.deb http://deb.odroid.in/5422/pool/main/b/bootini/bootini_20151220-14_armhf.deb
#wget -q -O /tmp/linux-image-3.10.92-67_20151123_armhf.deb http://deb.odroid.in/umiddelb/linux-image-3.10.92-67_20151123_armhf.deb
#dpkg -i /tmp/bootini.deb /tmp/linux-image-3.10.92-67_20151123_armhf.deb
#rm -f /tmp/bootini.deb /tmp/linux-image-3.10.92-67_20151123_armhf.deb

#apt-get install linux-headers-armhf-odroid-u
apt-get install -y linux-image-armhf-odroid-u

# set device label and version number
echo "HYPRIOT_DEVICE=\"$HYPRIOT_DEVICE\"" >> /etc/os-release
echo "HYPRIOT_IMAGE_VERSION=\"$HYPRIOT_IMAGE_VERSION\"" >> /etc/os-release
