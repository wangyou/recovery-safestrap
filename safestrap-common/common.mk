#
# This is the product configuration for a full common
#
include $(all-subdir-makefiles)

SAFESTRAP_VERSION := 3.50
COMMON_GLOBAL_CFLAGS += -DSS_VERSION_STR=\"$(SAFESTRAP_VERSION)\"

# Safestrap
SS_DEVICE_FOLDER := device/generic/safestrap
SS_COMMON_FOLDER := bootable/recovery/safestrap-common

$(call inherit-product, $(SS_DEVICE_FOLDER)/safestrap.mk)

# Packages
PRODUCT_PACKAGES += \
    safestrapmenu \
    libpng \
    fb2png.bin \
    updater \
    adbd

# Setup 2nd-init.zip
PRODUCT_COPY_FILES += \
    $(SS_COMMON_FOLDER)/sbin/2nd-init:/root/../2nd-init-files/2nd-init \
    $(SS_COMMON_FOLDER)/sbin/getprop:/root/../2nd-init-files/getprop \
    $(SS_COMMON_FOLDER)/sbin/hijack.killall:/root/../2nd-init-files/hijack.killall \
    $(SS_COMMON_FOLDER)/sbin/stop:/root/../2nd-init-files/stop \
    $(SS_COMMON_FOLDER)/sbin/taskset:/root/../2nd-init-files/taskset \

# Setup rootfs files
PRODUCT_COPY_FILES += \
    $(OUT)/system/bin/updater:/root/sbin/update-binary

# Common files
PRODUCT_COPY_FILES += \
    $(SS_COMMON_FOLDER)/version:/root/../install-files/etc/safestrap/flags/version \
    $(SS_COMMON_FOLDER)/recovery_mode:/root/../install-files/etc/safestrap/flags/recovery_mode \
    $(SS_COMMON_FOLDER)/sbin/bbx:/root/../install-files/etc/safestrap/bbx \

# App files
PRODUCT_COPY_FILES += \
    $(SS_COMMON_FOLDER)/busybox:/root/../APP/busybox \

ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=0

