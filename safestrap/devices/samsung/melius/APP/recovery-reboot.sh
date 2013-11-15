#!/system/bin/sh
# By Hashcode
PATH=/system/bin:/system/xbin

INSTALLPATH=$1
BBX=$INSTALLPATH/busybox
SS_CONFIG=$INSTALLPATH/ss.config

chmod 755 $BBX
chmod 755 $INSTALLPATH/ss_function.sh

. $INSTALLPATH/ss_function.sh
readConfig

CURRENTSYS=`$BBX readlink $BLOCK_DIR/$BLOCK_SYSTEM`
# check for older symlink style fixboot
if [ "$?" -ne 0 ]; then
	CURRENTSYS=`$BBX readlink $BLOCK_DIR/system`
fi
echo "CURRENTSYS = $CURRENTSYS" >> $LOGFILE
# determine our active system, and mount/remount accordingly
if [ "$CURRENTSYS" = "$BLOCK_DIR/loop-system" ]; then
	# alt-system, needs to mount original /system
	DESTMOUNT=$INSTALLPATH/system
	if [ ! -d "$DESTMOUNT" ]; then
		$BBX mkdir $DESTMOUNT
		$BBX chmod 755 $DESTMOUNT
	fi
	$BBX mount -t $SYSTEM_FSTYPE $BLOCK_DIR/$BLOCK_SYSTEM-orig $DESTMOUNT >> $LOGFILE
	if [ "$?" -ne 0 ]; then
		$BBX mount -t $SYSTEM_FSTYPE $BLOCK_DIR/systemorig $DESTMOUNT
	fi
else
	DESTMOUNT=/system
	sync
	$BBX mount -o remount,rw $DESTMOUNT >> $LOGFILE
fi

# Make sure the hijack is going to run by linking this firmware file to a ramdisk based file which will disappear after each boot
$BBX mount -o remount,rw /
$BBX rm $DESTMOUNT/etc/firmware/q6.mdt
$BBX cp /firmware/image/q6.mdt /q6.mdt
$BBX ln -s /q6.mdt $DESTMOUNT/etc/firmware/q6.mdt
$BBX mount -o remount,ro /

$BBX echo 1 > /data/$SS_RECOVERY_FILE
$BBX sync

# determine our active system, and umount/remount accordingly
if [ "$CURRENTSYS" = "$BLOCK_DIR/loop-system" ]; then
	$BBX umount $DESTMOUNT
	$BBX rmdir $DESTMOUNT
else
	$BBX mount -o ro,remount $DESTMOUNT
fi


