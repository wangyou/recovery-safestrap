#!/sbin/bbx sh
# By: Hashcode
# Last Editted: 08/31/2013
PATH=/sbin

/sbin/hijack.killall

/sbin/taskset -p -c 0 1 > /dev/kmsg
/sbin/bbx sync
/sbin/taskset -c 0 /sbin/2nd-init > /dev/kmsg

