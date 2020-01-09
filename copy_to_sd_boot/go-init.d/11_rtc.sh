#!/bin/sh

echo "dtoverlay=i2c-rtc,ds3231" >> /boot/config.txt
patch /lib/udev/hwclock-set < $(basename $0)/patch.d/hwclock-set.patch
