#!/usr/bin/env bash
sh $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/common/build-install.sh
cd $OUT/recovery/root
# erase custom .rc files
touch ./MSM8960_lpm.rc
touch ./init.carrier.rc
touch ./init.mmi.usb.rc
touch ./init.qcom.rc
touch ./init.qcom.usb.rc
touch ./init.target.rc
touch ./init.vzw.rc
touch ./lpm.rc
# erase SElinux files
touch ./file_contexts
touch ./property_contexts
touch ./seapp_contexts
touch ./sepolicy
touch ./sepolicy_version

