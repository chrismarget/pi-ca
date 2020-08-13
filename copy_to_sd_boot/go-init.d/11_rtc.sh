#!/bin/sh

# These take forever. It's easier to just leave the service installed
# but disabled. Maybe add these commands to soemthing other than the
# first (go-init) boot.
echo "#########################"
echo "Removing fake-hwclock"
apt-get -y remove fake-hwclock

echo "#########################"
echo "purging fake-hwclock"
apt-get -y purge fake-hwclock

echo "#########################"
echo "Calling update-rc.d -f fake-hwclock remove"
update-rc.d -f fake-hwclock remove

echo "#########################"
echo "Disabling systemd-timesyncd"
systemctl disable systemd-timesyncd

echo "#########################"
echo "Enabling RTC hardware"
echo "dtoverlay=i2c-rtc,ds3231" >> /boot/config.txt
echo "i2c_dev" >> /etc/modules

echo "#########################"
