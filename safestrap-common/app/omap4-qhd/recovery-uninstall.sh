#!/system/bin/sh
# By Hashcode
# Last Editted: 08/28/2013
PATH=/system/bin:/system/xbin
BLOCK_DIR=/dev/block
BLOCKNAME_DIR=$BLOCK_DIR
SYS_BLOCK_FSTYPE=ext3
HIJACK_BIN=bin/logwrapper

INSTALLPATH=$1
RECOVERY_DIR=etc/safestrap
LOGFILE=$INSTALLPATH/action-uninstall.log

chmod 755 $INSTALLPATH/busybox

CURRENTSYS=`$INSTALLPATH/busybox readlink $BLOCKNAME_DIR/system`
PRIMARYSYS=`$INSTALLPATH/busybox readlink $BLOCKNAME_DIR/systemorig`
if [ "$PRIMARYSYS" = "" ]; then
	PRIMARYSYS=`$INSTALLPATH/busybox readlink $BLOCKNAME_DIR/system`
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

