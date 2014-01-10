#!/usr/bin/env bash
sh $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/samsung/d2-common/build-install.sh
cp $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/samsung/d2vzw/selinux/* $OUT/recovery/root/
sh $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/common/build-install-finish.sh

