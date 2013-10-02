#!/sbin/bbx sh
# By: Hashcode
PATH=/sbin:/system/xbin:/system/bin

# system/userdata/cache
IMAGE_NAME=`echo '${1}' | tr '[a-z]' '[A-Z]'`
LOOP_DEV=${2}
ROMSLOT_NAME=${3}
BBX=/sbin/bbx
SS_CONFIG=/ss.config

. /sbin/ss_function.sh
readConfig

$BBX eval CURRENT_BLOCK=\$BLOCK_${IMAGE_NAME}

$BBX rm $BLOCK_DIR/$CURRENT_BLOCK
$BBX ln -s $BLOCK_DIR/loop$LOOP_DEV $BLOCK_DIR/$CURRENT_BLOCK
if [ "$USERDATA_FSTYPE" = "f2fs" ] && [ "$LOOP_DEV" = "-userdata" ]; then
	mkfs.f2fs $BLOCK_DIR/loop$LOOP_DEV
else
	if [ "$LOOP_DEV" = "-userdata" ]; then
		mke2fs -T $USERDATA_FSTYPE $BLOCK_DIR/loop$LOOP_DEV
	else
		mke2fs -T $SYSTEM_FSTYPE $BLOCK_DIR/loop$LOOP_DEV
	fi
fi

