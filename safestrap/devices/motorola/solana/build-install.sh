#!/usr/bin/env bash
cd $OUT
rm $OUT/APP/install-files.zip
rm $OUT/install-files/etc/safestrap/2nd-init.zip
rm $OUT/install-files/etc/safestrap/ramdisk-recovery.img
zip -9rj install-files/etc/safestrap/2nd-init 2nd-init-files/*
cd $OUT/recovery/root
# we're using a real taskset binary
rm -rf sbin/taskset
cd $OUT/recovery/root
# erase custom .rc files
touch ./init.mapphone_cdma.rc
touch ./init.mapphone_umts.rc
# add common init.rc w/ battd
cp $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/motorola/common-omap4/init.rc ./init.rc

cd $OUT/recovery/root
cp $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/motorola/targa/twrp.fstab ./etc/twrp.fstab

sh $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/common/build-install-finish.sh

