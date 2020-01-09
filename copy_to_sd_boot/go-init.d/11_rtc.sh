#!/bin/sh

# These take forever. It's easier to just leave the service installed
# but disabled. Maybe add these commands to soemthing other than the
# first (go-init) boot.
#apt-get -y remove fake-hwclock
#apt-get -y purge fake-hwclock
#update-rc.d -f fake-hwclock remove

rm /etc/systemd/system/sysinit.target.wants/fake-hwclock.service
mv /etc/rcS.d/S01fake-hwclock /etc/rcS.d/K01fake-hwclock
echo "dtoverlay=i2c-rtc,ds3231" >> /boot/config.txt
patch /lib/udev/hwclock-set < $(dirname $0)/patch.d/hwclock-set.patch
