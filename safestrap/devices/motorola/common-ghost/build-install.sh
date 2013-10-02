#!/usr/bin/env bash
sh $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/common/build-install.sh
cp $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/motorola/common-ghost/init.rc ./init.rc
cd $OUT/recovery/root

