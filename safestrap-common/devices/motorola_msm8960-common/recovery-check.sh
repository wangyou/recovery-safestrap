#!/system/bin/sh
# By Hashcode
# Last Editted: 08/31/2013
PATH=/system/bin:/system/xbin
BLOCK_DIR=/dev/block
BLOCKNAME_DIR=$BLOCK_DIR/platform/msm_sdcc.1/by-name
SYS_BLOCK_FSTYPE=ext4
HIJACK_BIN=bin/logwrapper

INSTALLPATH=$1
RECOVERY_DIR=etc/safestrap
LOGFILE=$INSTALLPATH/action-check.log

chmod 755 $INSTALLPATH/busybox

CURRENTSYS=`$INSTALLPATH/busybox readlink $BLOCKNAME_DIR/system`
PRIMARYSYS=`$INSTALLPATH/busybox readlink $BLOCKNAME_DIR/systemorig`
if [ "$PRIMARYSYS" = "" ]; then
	PRIMARYSYS=`$INSTALLPATH/busybox readlink $BLOCKNAME_DIR/system`
fi

$INSTALLPATH/busybox echo '' > $LOGFILE
$INSTALLPATH/busybox echo "CURRENTSYS=$CURRENTSYS" >> $LOGFILE
$INSTALLPATH/busybox echo "PRIMARYSYS=$PRIMARYSYS" >> $LOGFILE

vers=0
alt_boot_mode=0

if [ ! "$CURRENTSYS" = "$PRIMARYSYS" ]; then
	# alt-system, needs to mount original /system
	alt_boot_mode=1
	DESTMOUNT=$INSTALLPATH/system
	if [ ! -d "$DESTMOUNT" ]; then
		$INSTALLPATH/busybox mkdir $DESTMOUNT
	fi
	$INSTALLPATH/busybox mount -t $SYS_BLOCK_FSTYPE $PRIMARYSYS $DESTMOUNT
else
	DESTMOUNT=/system
fi

if [ -f "$DESTMOUNT/$RECOVERY_DIR/flags/version" ]; then
	vers=`$INSTALLPATH/busybox cat $DESTMOUNT/$RECOVERY_DIR/flags/version`
fi

if [ ! "$CURRENTSYS" = "$PRIMARYSYS" ]; then
	$INSTALLPATH/busybox umount $DESTMOUNT
fi
echo "$vers:$alt_boot_mode"

