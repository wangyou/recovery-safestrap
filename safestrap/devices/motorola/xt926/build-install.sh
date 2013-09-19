#!/usr/bin/env bash
sh $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/motorola/common-hd/build-install.sh

cd $OUT/recovery/root
cp $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/motorola/common-hd/init.rc ./init.rc
cp $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/motorola/common-hd/twrp.fstab ./etc/twrp.fstab

sh $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/common/build-install-finish.sh

