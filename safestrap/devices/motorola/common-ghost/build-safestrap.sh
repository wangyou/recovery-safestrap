#!/usr/bin/env bash
mkdir -p $OUT/2nd-init-files/
mkdir -p $OUT/APP
mkdir -p $OUT/install-files/bin/
mkdir -p $OUT/install-files/etc/safestrap/res/
mkdir -p $OUT/install-files/etc/safestrap/rootfs/
mkdir -p $OUT/recovery/root/etc/
mkdir -p $OUT/recovery/root/sbin/
cd $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/motorola
cp -fr common-ghost/APP/* $OUT/APP/
cp -fr common-ghost/res/* $OUT/install-files/etc/safestrap/res/
cp -fr common-ghost/sbin/* $OUT/recovery/root/sbin/
cp -fr common-ghost/hijack $OUT/install-files/bin/hijack.sh
cp -fr common-ghost/twrp.fstab $OUT/recovery/root/etc/twrp.fstab
cp -fr common-ghost/ss.config $OUT/install-files/etc/safestrap/ss.config
cp -fr common-ghost/ss.config $OUT/APP/ss.config
cp -fr common-ghost/ss.config $OUT/recovery/root/ss.config
cp -fr common-ghost/changeslot.sh $OUT/recovery/root/sbin/
cd ../../../gui
