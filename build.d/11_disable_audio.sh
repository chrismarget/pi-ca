#!/bin/sh

if [ -e "$BOOT_MNT" ]
then
  echo disabling audio driver
  sed -i .bak 's/dtparam=audio=on/dtparam=audio=off/' $BOOT_MNT/config.txt
  rm $BOOT_MNT/config.txt.bak
fi
