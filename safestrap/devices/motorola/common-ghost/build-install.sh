#!/usr/bin/env bash
sh $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/common/build-install.sh
cd $OUT/recovery/root
# erase custom .rc files
touch ./init.mmi.usb.rc
touch ./init.msm.rc
touch ./init.product.rc
touch ./init.qcom.rc
touch ./init.sprint.rc
touch ./init.target.rc
touch ./init.vzw.rc
# erase SElinux files
touch ./file_contexts
touch ./property_contexts
touch ./seapp_contexts
touch ./sepolicy
touch ./sepolicy_version

