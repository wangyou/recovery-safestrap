#!/usr/bin/env bash
sh $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/samsung/h-common/build-install.sh
cp $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/samsung/hltevzw/selinux/* $OUT/recovery/root/
sh $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/common/build-install-finish.sh

