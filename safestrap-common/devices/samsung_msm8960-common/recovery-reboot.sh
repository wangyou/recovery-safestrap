#!/system/bin/sh
# By Hashcode
# Last Editted: 08/28/2013
PATH=/system/bin:/system/xbin
BLOCK_DIR=/dev/block
BLOCKNAME_DIR=$BLOCK_DIR/platform/msm_sdcc.1/by-name
SYS_BLOCK_FSTYPE=ext4

INSTALLPATH=$1

CURRENTSYS=`$INSTALLPATH/busybox readlink $BLOCKNAME_DIR/system`
PRIMARYSYS=`$INSTALLPATH/busybox readlink $BLOCKNAME_DIR/systemorig`
if [ "$PRIMARYSYS" = "" ]; then
	PRIMARYSYS=`$INSTALLPATH/busybox readlink $BLOCKNAME_DIR/system`
fi

if [ ! "$CURRENTSYS" = "$PRIMARYSYS" ]; then
	DESTMOUNT=$INSTALLPATH/system
	if [ ! -d "$DESTMOUNT" ]; then
		$INSTALLPATH/busybox mkdir $DESTMOUNT
	fi
	$INSTALLPATH/busybox mount -t $SYS_BLOCK_FSTYPE $PRIMARYSYS $DESTMOUNT
else
	DESTMOUNT=/system
	sync
	$INSTALLPATH/busybox mount -o remount,rw $DESTMOUNT
fi

# Make sure the hijack is going to run by linking this firmware file to a ramdisk based file which will disappear after each boot
$INSTALLPATH/busybox rm $DESTMOUNT/etc/firmware/q6.mdt
$INSTALLPATH/busybox cp /firmware/image/q6.mdt /q6.mdt
$INSTALLPATH/busybox ln -s /q6.mdt $DESTMOUNT/etc/firmware/q6.mdt

$INSTALLPATH/busybox echo 1 > /data/.recovery_mode
$INSTALLPATH/busybox sync

# determine our active system, and umount/remount accordingly
if [ ! "$CURRENTSYS" = "$PRIMARYSYS" ]; then
	$INSTALLPATH/busybox umount $DESTMOUNT
	$INSTALLPATH/busybox rmdir $DESTMOUNT
else
	$INSTALLPATH/busybox mount -o ro,remount $DESTMOUNT
fi


