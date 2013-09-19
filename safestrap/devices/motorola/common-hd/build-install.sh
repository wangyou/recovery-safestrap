#!/usr/bin/env bash
sh $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/common/build-install.sh
cd $OUT/recovery/root
# erase custom .rc files
touch ./init.mmi.usb.rc
touch ./init.qcom.rc
touch ./init.target.rc
touch ./init.vzw.rc

