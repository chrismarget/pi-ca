#!/bin/sh

. $(dirname $0)/functions

[ -d "$BOOT_MNT" ] || error "$BOOT_MNT does not exist"

BOOT_CFG="${BOOT_MNT}/config.txt"
[ -f $BOOT_CFG ] || error "$BOOT_CFG does not exist"

CMDLINE="${BOOT_MNT}/cmdline.txt.orig"
[ -f $CMDLINE ] || error "$CMDLINE does not exist"

echo "hdmi_force_hotplug=1" >> $BOOT_CFG
echo "dtparam=spi=on" >> $BOOT_CFG
echo "dtparam=i2c1=on" >> $BOOT_CFG
echo "dtparam=i2c_arm=on" >> $BOOT_CFG
echo "dtoverlay=pitft28-capacitive,speed=64000000,fps=30" >> $BOOT_CFG
echo "dtoverlay=pitft28-capacitive,rotate=90,touch-swapxy=true,touch-invx=true" >> $BOOT_CFG

sed -i .bak 's/^.*disable_overscan=.*$/disable_overscan=0/' $BOOT_CFG && rm ${BOOT_CFG}.bak
sed -i .bak 's/^.*hdmi_force_hotplug=.*$/hdmi_force_hotplug=0/' $BOOT_CFG && rm ${BOOT_CFG}.bak
sed -i .bak 's/^.*dtoverlay=vc4-fkms-v3d$/dtoverlay=vc4-fkms-v3d/' $BOOT_CFG && rm ${BOOT_CFG}.bak

sed -i .bak 's/rootwait/rootwait fbcon=map:10 fbcon=font:VGA8x8/g' "$CMDLINE" && rm ${CMDLINE}.bak
