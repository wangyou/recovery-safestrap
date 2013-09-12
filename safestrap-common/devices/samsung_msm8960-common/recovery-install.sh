#!/system/bin/sh
# By Hashcode
# Last Editted: 09/04/2013
PATH=/system/bin:/system/xbin
BLOCK_DIR=/dev/block
BLOCK_SYSTEM=mmcblk0p16
BLOCK_BOOT=mmcblk0p20

SYS_BLOCK_FSTYPE=ext4
HIJACK_BIN=etc/init.qcom.modem_links.sh

INSTALLPATH=$1
RECOVERY_DIR=etc/safestrap
LOGFILE=$INSTALLPATH/action-install.log

chmod 755 $INSTALLPATH/busybox

CURRENTSYS=`$INSTALLPATH/busybox readlink $BLOCK_DIR/$BLOCK_SYSTEM`
PRIMARYSYS=`$INSTALLPATH/busybox readlink $BLOCK_DIR/$BLOCK_SYSTEM-orig`
if [ "$PRIMARYSYS" = "" ]; then
	PRIMARYSYS=`$INSTALLPATH/busybox readlink $BLOCK_DIR/$BLOCK_SYSTEM`
fi

$INSTALLPATH/busybox echo '' > $LOGFILE
$INSTALLPATH/busybox echo "CURRENTSYS=$CURRENTSYS" >> $LOGFILE
$INSTALLPATH/busybox echo "PRIMARYSYS=$PRIMARYSYS" >> $LOGFILE

echo "install path=$INSTALLPATH/install-files" >> $LOGFILE
if [ -d $INSTALLPATH/install-files ]; then
	rm -r $INSTALLPATH/install-files >> $LOGFILE
fi

$INSTALLPATH/busybox unzip $INSTALLPATH/install-files.zip  -d $INSTALLPATH >> $LOGFILE
if [ ! -d $INSTALLPATH/install-files ]; then
	echo 'ERR: Zip file didnt extract correctly.  Installation aborted.' >> $LOGFILE
	exit 1
fi

# determine our active system, and mount/remount accordingly
if [ ! "$CURRENTSYS" = "$PRIMARYSYS" ]; then
	# alt-system, needs to mount original /system
	DESTMOUNT=$INSTALLPATH/system
	if [ ! -d "$DESTMOUNT" ]; then
		$INSTALLPATH/busybox mkdir $DESTMOUNT
		$INSTALLPATH/busybox chmod 755 $DESTMOUNT
	fi
	$INSTALLPATH/busybox mount -t $SYS_BLOCK_FSTYPE $PRIMARYSYS $DESTMOUNT >> $LOGFILE
else
	DESTMOUNT=/system
	sync
	$INSTALLPATH/busybox mount -o remount,rw $DESTMOUNT >> $LOGFILE
fi

# check for a $HIJACK_BIN.bin file and its not there, make a copy
if [ ! -f "$DESTMOUNT/$HIJACK_BIN.bin" ]; then
	$INSTALLPATH/busybox cp $DESTMOUNT/$HIJACK_BIN $DESTMOUNT/$HIJACK_BIN.bin >> $LOGFILE
	$INSTALLPATH/busybox chown 0.0 $DESTMOUNT/$HIJACK_BIN.bin >> $LOGFILE
	$INSTALLPATH/busybox chmod 755 $DESTMOUNT/$HIJACK_BIN.bin >> $LOGFILE
fi
$INSTALLPATH/busybox rm $DESTMOUNT/$HIJACK_BIN >> $LOGFILE
$INSTALLPATH/busybox cp -f $INSTALLPATH/install-files/$HIJACK_BIN $DESTMOUNT/$HIJACK_BIN >> $LOGFILE
$INSTALLPATH/busybox chown 0.0 $DESTMOUNT/$HIJACK_BIN >> $LOGFILE
$INSTALLPATH/busybox chmod 755 $DESTMOUNT/$HIJACK_BIN >> $LOGFILE

# delete any existing /system/etc/safestrap dir
if [ -d "$DESTMOUNT/$RECOVERY_DIR" ]; then
	$INSTALLPATH/busybox rm -rf $DESTMOUNT/$RECOVERY_DIR >> $LOGFILE
fi
# extract the new dirs to /system
$INSTALLPATH/busybox cp -R $INSTALLPATH/install-files/$RECOVERY_DIR $DESTMOUNT/etc >> $LOGFILE
$INSTALLPATH/busybox chown 0.2000 $DESTMOUNT/$RECOVERY_DIR/* >> $LOGFILE
$INSTALLPATH/busybox chmod 755 $DESTMOUNT/$RECOVERY_DIR/* >> $LOGFILE

# Make sure the hijack is going to run by linking this firmware file to a ramdisk based file which will disappear after each boot
$INSTALLPATH/busybox mount -o remount,rw /
$INSTALLPATH/busybox rm $DESTMOUNT/etc/firmware/q6.mdt
$INSTALLPATH/busybox cp /firmware/image/q6.mdt /q6.mdt
$INSTALLPATH/busybox ln -s /q6.mdt $DESTMOUNT/etc/firmware/q6.mdt
$INSTALLPATH/busybox mount -o remount,ro /

# determine our active system, and umount/remount accordingly
if [ ! "$CURRENTSYS" = "$PRIMARYSYS" ]; then
	# if we're in 2nd-system then re-enable safe boot
	$INSTALLPATH/busybox touch $DESTMOUNT/$RECOVERY_DIR/flags/alt_system_mode >> $LOGFILE

	$INSTALLPATH/busybox umount $DESTMOUNT >> $LOGFILE
	$INSTALLPATH/busybox rmdir $DESTMOUNT >> $LOGFILE
else
	$INSTALLPATH/busybox mount -o ro,remount $DESTMOUNT >> $LOGFILE
fi

