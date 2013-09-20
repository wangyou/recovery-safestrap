#SAFESTRAP COMMON
TW_INCLUDE_SPLASHMENU := true
#BOARD_USE_NO_DEVFS_SETUP := true
BOARD_SUPPRESS_EMMC_WIPE := true

# Use prebuilt kernel for kexec
TARGET_KERNEL_SOURCE := 
TARGET_KERNEL_CONFIG := 
TARGET_PREBUILT_KERNEL := $ANDROID_BUILD_TOP/bootable/recovery/safestrap/devices/motorola/kernel

include $(ANDROID_BUILD_TOP)/bootable/recovery/safestrap/devices/motorola/common-omap4/safestrap-common-omap4.mk

