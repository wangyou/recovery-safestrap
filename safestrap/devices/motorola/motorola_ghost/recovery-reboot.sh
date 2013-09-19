#!/system/bin/sh
# By Hashcode
# Last Editted: 08/28/2013
PATH=/system/bin:/system/xbin

INSTALLPATH=$1

$INSTALLPATH/busybox echo 1 > /data/.recovery_mode
$INSTALLPATH/busybox sync


