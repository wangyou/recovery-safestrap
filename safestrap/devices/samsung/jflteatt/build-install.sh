#!/usr/bin/env bash
sh $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/samsung/jf-common/build-install.sh

cd $OUT/recovery/root
cp $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/samsung/jf-common/twrp.fstab ./etc/twrp.fstab
cp $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/samsung/msm8960-common/init.rc ./init.rc

sh $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/common/build-install-finish.sh

