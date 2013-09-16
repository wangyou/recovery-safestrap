#!/sbin/sh
# By: Hashcode
# Last Edit: 09/13/2013
HIJACK_BIN=logwrapper
HIJACK_LOC=bin

if [ -d "/tmp/safestrap" ]; then
	rm -rf /tmp/safestrap
fi
if [ -f "/tmp/$HIJACK_BIN" ]; then
	rm /tmp/$HIJACK_BIN
fi
if [ -f "/tmp/$HIJACK_BIN.bin" ]; then
	rm /tmp/$HIJACK_BIN.bin
fi
cp -R /system/etc/safestrap /tmp/
cp /system/$HIJACK_LOC/$HIJACK_BIN /tmp/
cp /system/$HIJACK_LOC/$HIJACK_BIN.bin /tmp/

