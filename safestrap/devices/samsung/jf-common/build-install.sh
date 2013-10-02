#!/usr/bin/env bash
sh $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/common/build-install.sh
cd $OUT/recovery/root
cp $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/samsung/jf-common/init.rc ./init.rc

