include $(ANDROID_BUILD_TOP)/bootable/recovery/safestrap/devices/common/safestrap-common.mk

#TWRP
RECOVERY_SDCARD_ON_DATA := true
TW_INTERNAL_STORAGE_PATH := "/datamedia/media"
TW_INTERNAL_STORAGE_MOUNT_POINT := "datamedia"
TW_EXTERNAL_STORAGE_PATH := "/sdcard"
TW_EXTERNAL_STORAGE_MOUNT_POINT := "sdcard"
TW_DEFAULT_EXTERNAL_STORAGE := true

SPLASH_RECOVERY_KEY := KEY_MENU
SPLASH_CONTINUE_KEY := KEY_SEARCH

BOARD_DEFAULT_VIRT_SYSTEM_SIZE := 640
BOARD_DEFAULT_VIRT_CACHE_SIZE := 300
TW_CUSTOM_BATTERY_CAPACITY_FIELD := charge_counter

HAVE_SELINUX := true

TW_BRIGHTNESS_PATH := /sys/class/backlight/lm3532_bl/brightness
