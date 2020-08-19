#!/bin/sh

. $(dirname $0)/functions

[ -d "$BOOT_MNT" ] || error "$BOOT_MNT does not exist"

RCLOCAL="${BOOT_MNT}/rc.local"
[ -f $RCLOCAL ] || error "$RCLOCAL does not exist"

cat >> $RCLOCAL << EOF
chvt 11
top > /dev/tty11 < /dev/tty11 &
EOF
