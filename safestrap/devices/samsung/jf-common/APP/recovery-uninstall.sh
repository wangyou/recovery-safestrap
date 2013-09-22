#!/system/bin/sh
# By Hashcode
# Last Editted: 09/21/2013
PATH=/system/bin:/system/xbin
BLOCK_DIR=/dev/block

BLOCK_SYSTEM=mmcblk0p16

SYS_BLOCK_FSTYPE=ext4
HIJACK_BIN=etc/init.qcom.modem_links.sh

INSTALLPATH=$1
RECOVERY_DIR=etc/safestrap
LOGFILE=$INSTALLPATH/action-uninstall.log

chmod 755 $INSTALLPATH/busybox

CURRENTSYS=`$INSTALLPATH/busybox readlink $BLOCK_DIR/$BLOCK_SYSTEM`
echo "CURRENTSYS = $CURRENTSYS" >> $LOGFILE
if [ "$CURRENTSYS" = "$BLOCK_DIR/loop-system" ]; then
	# alt-system, needs to mount original /system
	DESTMOUNT=$INSTALLPATH/system
	if [ ! -d "$DESTMOUNT" ]; then
		$INSTALLPATH/busybox mkdir $DESTMOUNT
	fi
	$INSTALLPATH/busybox mount -t $SYS_BLOCK_FSTYPE $BLOCK_DIR/$BLOCK_SYSTEM-orig $DESTMOUNT
else
	DESTMOUNT=/system
	sync
	$INSTALLPATH/busybox mount -o remount,rw $DESTMOUNT
fi
echo "DESTMOUNT = $DESTMOUNT" >> $LOGFILE

if [ -f "$DESTMOUNT/$HIJACK_BIN.bin" ]; then
	$INSTALLPATH/busybox mv -f $DESTMOUNT/$HIJACK_BIN.bin $DESTMOUNT/$HIJACK_BIN >> $LOGFILE
	$INSTALLPATH/busybox chown 0.2000 $DESTMOUNT/$HIJACK_BIN >> $LOGFILE
	$INSTALLPATH/busybox chmod 755 $DESTMOUNT/$HIJACK_BIN >> $LOGFILE
fi

if [ -d "$DESTMOUNT/$RECOVERY_DIR" ]; then
	$INSTALLPATH/busybox rm -r $DESTMOUNT/$RECOVERY_DIR >> $LOGFILE
fi

# Fix up the firmware file used to enter recovery
$INSTALLPATH/busybox rm $DESTMOUNT/etc/firmware/q6.mdt
$INSTALLPATH/busybox ln -s /firmware/image/q6.mdt $DESTMOUNT/etc/firmware/q6.mdt

sync

# determine our active system, and umount/remount accordingly
if [ "$CURRENTSYS" = "$BLOCK_DIR/loop-system" ]; then
	$INSTALLPATH/busybox umount $DESTMOUNT >> $LOGFILE
	$INSTALLPATH/busybox rmdir $DESTMOUNT
else
	$INSTALLPATH/busybox mount -o ro,remount $DESTMOUNT >> $LOGFILE
fi

