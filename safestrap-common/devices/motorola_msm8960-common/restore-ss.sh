#!/sbin/sh
# By: Hashcode
# Last Edit: 08/31/2013
HIJACK_BIN=init.qcom.modem_links.sh
HIJACK_LOC=etc

if [ -d "/tmp/safestrap" ] && [ -f "/tmp/$HIJACK_BIN" ]; then
	# clear out old safestrap
	if [ -d "/system/etc/safestrap" ]; then
		rm -R /system/etc/safestrap
	fi
	mkdir -p /system/etc/

	cp -R /tmp/safestrap /system/etc/
	chown -R root.shell /system/etc/safestrap
	chmod 755 /system/etc/safestrap/bbx
	chmod 755 /system/etc/safestrap/safestrapmenu

	if [ ! -d "/system/$HIJACK_LOC" ]; then
		mkdir -p /system/$HIJACK_LOC
		chown -R root.shell /system/$HIJACK_LOC
		chmod 755 /system/$HIJACK_LOC
	fi
	if [ ! -f "/system/$HIJACK_LOC/$HIJACK_BIN.bin" ]; then
		if [ -f "/system/$HIJACK_LOC/$HIJACK_BIN" ]; then
			mv /system/$HIJACK_LOC/$HIJACK_BIN /system/$HIJACK_LOC/$HIJACK_BIN.bin
		else
			cp /tmp/$HIJACK_BIN.bin /system/$HIJACK_LOC/$HIJACK_BIN.bin
		fi
		chown root.shell /system/$HIJACK_LOC/$HIJACK_BIN.bin
		chmod 755 /system/$HIJACK_LOC/$HIJACK_BIN.bin
	fi
	cp /tmp/$HIJACK_BIN /system/$HIJACK_LOC/$HIJACK_BIN
	chown root.shell /system/$HIJACK_LOC/$HIJACK_BIN
	chmod 755 /system/$HIJACK_LOC/$HIJACK_BIN
fi

