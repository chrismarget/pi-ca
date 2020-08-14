#!/bin/sh

. $(dirname $0)/functions
[ -d "$BOOT_MNT" ] || error "$BOOT_MNT does not exist"

BOOT_CFG="${BOOT_MNT}/config.txt"
[ -f $BOOT_CFG ] || error "$BOOT_CFG does not exist"

sed -i .bak 's/dtparam=audio=on/dtparam=audio=off/' $BOOT_CFG && rm ${BOOT_CFG}.bak
