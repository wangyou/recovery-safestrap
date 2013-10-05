#!/usr/bin/env bash
sh $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/common/build-install.sh
cd $OUT/recovery/root
# remove fstab.qcom from recovery
rm fstab.qcom
cp $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/motorola/common-ghost/init.rc ./init.rc
mv $OUT/install-files/bin/hijack-wrapper $OUT/install-files/bin/logwrapper

