#!/bin/sh

if [ -e /boot/random-seed ]
then
  cp /boot/random-seed /var/lib/systemd/random-seed
fi

exit 0
