#!/sbin/bbx sh
# By: Hashcode
# Last Editted: 09/19/2013

# system/userdata/cache
IMAGE_NAME=`echo '${1}' | tr '[a-z]' '[A-Z]'`
LOOP_DEV=${2}
ROMSLOT_NAME=${3}
BLOCK_DIR=/dev/block

BLOCK_SYSTEM=mmcblk1p21
BLOCK_USERDATA=mmcblk1p25
BLOCK_CACHE=mmcblk1p22
BLOCK_BOOT=mmcblk1p15

eval CURRENT_BLOCK=\$BLOCK_${IMAGE_NAME}

SS_MNT=/ss
SS_DIR=$SS_MNT/safestrap

rm $BLOCK_DIR/$CURRENT_BLOCK
ln -s $BLOCK_DIR/loop$LOOP_DEV $BLOCK_DIR/$CURRENT_BLOCK
mke2fs -T ext3 $BLOCK_DIR/loop$LOOP_DEV

