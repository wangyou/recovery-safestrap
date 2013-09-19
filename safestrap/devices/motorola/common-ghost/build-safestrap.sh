#!/usr/bin/env bash
mkdir -p $OUT/recovery/root/sbin
mkdir -p $OUT/APP
mkdir -p $OUT/2nd-init-files
mkdir -p $OUT/install-files/bin/
mkdir -p $OUT/install-files/etc/safestrap/res/
mkdir -p $OUT/install-files/etc/safestrap/rootfs/
cd $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/motorola
cp -fr common-ghost/APP/* $OUT/APP/
cp -fr common-ghost/2nd-init-files/* $OUT/2nd-init-files/
cp -fr common-ghost/res/* $OUT/install-files/etc/safestrap/res/
cp -fr common-ghost/sbin/* $OUT/recovery/root/sbin/
cp -fr common-ghost/hijack $OUT/install-files/bin/logwrapper
cd ../../../gui
