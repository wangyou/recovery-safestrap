#!/usr/bin/env bash
sh $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/common/build-install.sh
cd $OUT/recovery/root
# erase custom .rc files
touch ./init.mapphone_cdma.rc
touch ./init.mapphone_umts.rc
cp $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/motorola/common-omap4/init.rc ./init.rc

