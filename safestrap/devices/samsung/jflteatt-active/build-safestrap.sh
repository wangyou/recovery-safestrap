#!/usr/bin/env bash
mkdir -p $OUT/recovery/root/sbin
mkdir -p $OUT/APP
mkdir -p $OUT/2nd-init-files
mkdir -p $OUT/install-files/etc/safestrap/res/
mkdir -p $OUT/install-files/etc/safestrap/rootfs/
cd $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/samsung
cp -fr jflteatt-active/2nd-init-files/* $OUT/2nd-init-files/
cp -fr jflteatt-active/sbin/* $OUT/recovery/root/sbin/
cp -fr jflteatt-active/hijack $OUT/install-files/etc/init.qcom.modem_links.sh
cp -fr jflteatt-active/init.rc $OUT/recovery/root/init.rc
cp -fr jf-common/APP/* $OUT/APP/
cp -fr jf-common/res/* $OUT/install-files/etc/safestrap/res/
cp -fr jf-common/sbin-libs/* $OUT/recovery/root/sbin/
cp -fr jf-common/backup-ss.sh $OUT/recovery/root/sbin/backup-ss.sh
cp -fr jf-common/restore-ss.sh $OUT/recovery/root/sbin/restore-ss.sh
cp -fr msm8960-common/rootfs/* $OUT/install-files/etc/safestrap/rootfs/
cd ../../../gui
