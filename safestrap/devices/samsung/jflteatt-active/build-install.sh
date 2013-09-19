#!/usr/bin/env bash
sh $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/samsung/jf-common/build-install.sh

cd $OUT/recovery/root
cp $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/samsung_s4-active/init.rc ./init.rc
cp $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/samsung_s4-active/twrp.fstab ./etc/twrp.fstab

sh $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/common/build-install-finish.sh

