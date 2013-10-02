#!/usr/bin/env bash
sh $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/common/build-install.sh
cp $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/motorola/common-omap4/init.rc ./init.rc
cd $OUT/recovery/root

