#!/usr/bin/env bash
mkdir -p $OUT/recovery/root/sbin
mkdir -p $OUT/APP
mkdir -p $OUT/2nd-init-files
mkdir -p $OUT/install-files/etc/safestrap/res/
mkdir -p $OUT/install-files/etc/safestrap/rootfs/
cd $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/motorola
cp -fr common-hd/APP/* $OUT/APP/
cp -fr common-hd/2nd-init-files/* $OUT/2nd-init-files/
cp -fr common-hd/res/* $OUT/install-files/etc/safestrap/res/
cp -fr common-hd/sbin/* $OUT/recovery/root/sbin/
cp -fr common-hd/hijack $OUT/install-files/etc/init.qcom.modem_links.sh
cp -fr common-hd/init.rc $OUT/recovery/root/init.rc
cd ../../../gui
