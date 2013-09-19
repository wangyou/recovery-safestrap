#!/system/bin/sh
# By Hashcode
# Last Editted: 09/11/2013
PATH=/system/bin:/system/xbin
BLOCK_DIR=/dev/block

BLOCK_SYSTEM=mmcblk0p38
BLOCK_USERDATA=mmcblk0p40
BLOCK_CACHE=mmcblk0p36
BLOCK_BOOT=mmcblk0p33

HIJACK_BIN=bin/logwrapper
SYS_BLOCK_FSTYPE=ext4

INSTALLPATH=$1
RECOVERY_DIR=etc/safestrap
LOGFILE=$INSTALLPATH/action-uninstall.log

chmod 755 $INSTALLPATH/busybox

CURRENTSYS=`$INSTALLPATH/busybox readlink $BLOCK_DIR/$BLOCK_SYSTEM`
PRIMARYSYS=`$INSTALLPATH/busybox readlink $BLOCK_DIR/$BLOCK_SYSTEM-orig`
if [ "$PRIMARYSYS" = "" ]; then
	PRIMARYSYS=`$INSTALLPATH/busybox readlink $BLOCK_DIR/$BLOCK_SYSTEM`
fi

$INSTALLPATH/busybox echo '' > $LOGFILE
$INSTALLPATH/busybox echo "CURRENTSYS=$CURRENTSYS" >> $LOGFILE
$INSTALLPATH/busybox echo "PRIMARYSYS=$PRIMARYSYS" >> $LOGFILE

# determine our active system, and mount/remount accordingly
if [ ! "$CURRENTSYS" = "$PRIMARYSYS" ]; then
	$INSTALLPATH/busybox echo "ALT-system found, mounting systemorig" >> $LOGFILE
	# alt-system, needs to mount original /system
	DESTMOUNT=$INSTALLPATH/system
	if [ ! -d "$DESTMOUNT" ]; then
		$INSTALLPATH/busybox mkdir $DESTMOUNT
		$INSTALLPATH/busybox chmod 755 $DESTMOUNT
	fi
	$INSTALLPATH/busybox mount -t $SYS_BLOCK_FSTYPE $PRIMARYSYS $DESTMOUNT
else
	$INSTALLPATH/busybox echo "stock system found" >> $LOGFILE
	DESTMOUNT=/system
	sync
	$INSTALLPATH/busybox mount -o remount,rw $DESTMOUNT
fi

if [ -f "$DESTMOUNT/$HIJACK_BIN.bin" ]; then
	$INSTALLPATH/busybox cp -f $DESTMOUNT/$HIJACK_BIN.bin $DESTMOUNT/$HIJACK_BIN >> $LOGFILE
	$INSTALLPATH/busybox chown 0.2000 $DESTMOUNT/$HIJACK_BIN >> $LOGFILE
	$INSTALLPATH/busybox chmod 755 $DESTMOUNT/$HIJACK_BIN >> $LOGFILE
fi

if [ -d "$DESTMOUNT/$RECOVERY_DIR" ]; then
	$INSTALLPATH/busybox rm -r $DESTMOUNT/$RECOVERY_DIR >> $LOGFILE
fi

sync

# determine our active system, and umount/remount accordingly
if [ ! "$CURRENTSYS" = "$PRIMARYSYS" ]; then
	$INSTALLPATH/busybox umount $DESTMOUNT >> $LOGFILE
	$INSTALLPATH/busybox rmdir $DESTMOUNT
else
	$INSTALLPATH/busybox mount -o ro,remount $DESTMOUNT >> $LOGFILE
fi

