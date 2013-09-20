#!/usr/bin/env bash
mkdir -p $OUT/recovery/root/sbin
mkdir -p $OUT/APP
mkdir -p $OUT/2nd-init-files
mkdir -p $OUT/install-files/bin/
mkdir -p $OUT/install-files/etc/safestrap/kexec/
mkdir -p $OUT/install-files/etc/safestrap/res/
cd $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/motorola
cp -fr common-omap4/APP-1p21/* $OUT/APP/
cp -fr solana/2nd-init-files/* $OUT/2nd-init-files/
cp -fr common-omap4/res/* $OUT/install-files/etc/safestrap/res/
cp -fr solana/sbin/* $OUT/recovery/root/sbin/
cp -fr common-omap4/sbin-blobs/* $OUT/recovery/root/sbin/
cp -fr solana/hijack $OUT/install-files/bin/logwrapper
cd ../../../gui
