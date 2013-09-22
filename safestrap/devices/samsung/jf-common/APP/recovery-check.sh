#!/system/bin/sh
# By Hashcode
# Last Editted: 09/21/2013
PATH=/system/bin:/system/xbin
BLOCK_DIR=/dev/block
vers=0
alt_boot_mode=0

BLOCK_SYSTEM=mmcblk0p16

SYS_BLOCK_FSTYPE=ext4

INSTALLPATH=$1
RECOVERY_DIR=etc/safestrap
LOGFILE=$INSTALLPATH/action-check.log

chmod 755 $INSTALLPATH/busybox

CURRENTSYS=`$INSTALLPATH/busybox readlink $BLOCK_DIR/$BLOCK_SYSTEM`
if [ "$CURRENTSYS" = "$BLOCK_DIR/loop-system" ]; then
	# alt-system, needs to mount original /system
	alt_boot_mode=1
	DESTMOUNT=$INSTALLPATH/system
	if [ ! -d "$DESTMOUNT" ]; then
		$INSTALLPATH/busybox mkdir $DESTMOUNT >> $LOGFILE
	fi
	$INSTALLPATH/busybox mount -t $SYS_BLOCK_FSTYPE $BLOCK_DIR/$BLOCK_SYSTEM-orig $DESTMOUNT
else
	DESTMOUNT=/system
fi
echo "DESTMOUNT = $DESTMOUNT" >> $LOGFILE

if [ -f "$DESTMOUNT/$RECOVERY_DIR/flags/version" ]; then
	vers=`$INSTALLPATH/busybox cat $DESTMOUNT/$RECOVERY_DIR/flags/version`
fi

if [ "$CURRENTSYS" = "$BLOCK_DIR/loop-system" ]; then
	$INSTALLPATH/busybox umount $DESTMOUNT
fi
echo "$vers:$alt_boot_mode"

