LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
    gui.cpp \
    resources.cpp \
    pages.cpp \
    text.cpp \
    image.cpp \
    action.cpp \
    console.cpp \
    fill.cpp \
    button.cpp \
    checkbox.cpp \
    fileselector.cpp \
    progressbar.cpp \
    animation.cpp \
    conditional.cpp \
    slider.cpp \
    slidervalue.cpp \
    listbox.cpp \
    keyboard.cpp \
    input.cpp \
    blanktimer.cpp \
    partitionlist.cpp

ifneq ($(TWRP_CUSTOM_KEYBOARD),)
  LOCAL_SRC_FILES += $(TWRP_CUSTOM_KEYBOARD)
else
  LOCAL_SRC_FILES += hardwarekeyboard.cpp
endif

LOCAL_SHARED_LIBRARIES += libminuitwrp libc libstdc++
LOCAL_MODULE := libguitwrp

# Use this flag to create a build that simulates threaded actions like installing zips, backups, restores, and wipes for theme testing
#TWRP_SIMULATE_ACTIONS := true
ifeq ($(TWRP_SIMULATE_ACTIONS), true)
LOCAL_CFLAGS += -D_SIMULATE_ACTIONS
endif

#TWRP_EVENT_LOGGING := true
ifeq ($(TWRP_EVENT_LOGGING), true)
LOCAL_CFLAGS += -D_EVENT_LOGGING
endif

ifneq ($(RECOVERY_SDCARD_ON_DATA),)
	LOCAL_CFLAGS += -DRECOVERY_SDCARD_ON_DATA
endif
ifneq ($(TW_EXTERNAL_STORAGE_PATH),)
	LOCAL_CFLAGS += -DTW_EXTERNAL_STORAGE_PATH=$(TW_EXTERNAL_STORAGE_PATH)
endif
ifneq ($(TW_BRIGHTNESS_PATH),)
	LOCAL_CFLAGS += -DTW_BRIGHTNESS_PATH=$(TW_BRIGHTNESS_PATH)
endif
ifneq ($(TW_MAX_BRIGHTNESS),)
	LOCAL_CFLAGS += -DTW_MAX_BRIGHTNESS=$(TW_MAX_BRIGHTNESS)
else
	LOCAL_CFLAGS += -DTW_MAX_BRIGHTNESS=255
endif
ifneq ($(TW_NO_SCREEN_BLANK),)
	LOCAL_CFLAGS += -DTW_NO_SCREEN_BLANK
endif
ifneq ($(TW_NO_SCREEN_TIMEOUT),)
	LOCAL_CFLAGS += -DTW_NO_SCREEN_TIMEOUT
endif
ifeq ($(HAVE_SELINUX), true)
LOCAL_CFLAGS += -DHAVE_SELINUX
endif

# Safestrap virtual size defaults
ifndef BOARD_DEFAULT_VIRT_SYSTEM_SIZE
  BOARD_DEFAULT_VIRT_SYSTEM_SIZE := 600
endif
LOCAL_CFLAGS += -DDEFAULT_VIRT_SYSTEM_SIZE=\"$(BOARD_DEFAULT_VIRT_SYSTEM_SIZE)\"
ifndef BOARD_DEFAULT_VIRT_CACHE_SIZE
  BOARD_DEFAULT_VIRT_CACHE_SIZE := 300
endif
LOCAL_CFLAGS += -DDEFAULT_VIRT_CACHE_SIZE=\"$(BOARD_DEFAULT_VIRT_CACHE_SIZE)\"

LOCAL_C_INCLUDES += bionic external/stlport/stlport $(commands_recovery_local_path)/gui/devices/$(DEVICE_RESOLUTION)

include $(BUILD_STATIC_LIBRARY)

# Transfer in the resources for the device
include $(CLEAR_VARS)
LOCAL_MODULE := twrp
LOCAL_MODULE_TAGS := eng
LOCAL_MODULE_CLASS := RECOVERY_EXECUTABLES
LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/res

ifdef BUILD_SAFESTRAP
TWRP_RES_LOC := $(commands_recovery_local_path)/safestrap/devices/common/res
else
TWRP_RES_LOC := $(commands_recovery_local_path)/gui/devices
endif
TWRP_RES_GEN := $(intermediates)/twrp
SS_COMMON := $(commands_recovery_local_path)/safestrap

$(TWRP_RES_GEN):
	mkdir -p $(TARGET_RECOVERY_ROOT_OUT)/res/
	cp -fr $(TWRP_RES_LOC)/common/res/* $(TARGET_RECOVERY_ROOT_OUT)/res/
	cp -fr $(TWRP_RES_LOC)/$(DEVICE_RESOLUTION)/res/* $(TARGET_RECOVERY_ROOT_OUT)/res/
	mkdir -p $(TARGET_RECOVERY_ROOT_OUT)/sbin/
	ln -sf /sbin/busybox $(TARGET_RECOVERY_ROOT_OUT)/sbin/sh
	ln -sf /sbin/pigz $(TARGET_RECOVERY_ROOT_OUT)/sbin/gzip
	ln -sf /sbin/unpigz $(TARGET_RECOVERY_ROOT_OUT)/sbin/gunzip
	# Safestrap Setup
	rm -rf $(OUT)/2nd-init-files
	rm -rf $(OUT)/APP
	rm -rf $(OUT)/install-files
	mkdir -p $(OUT)/2nd-init-files
	mkdir -p $(OUT)/install-files/etc/safestrap/flags
	mkdir -p $(OUT)/install-files/etc/safestrap/res
	mkdir -p $(OUT)/APP
	cp -p $(TWRP_RES_LOC)/../2nd-init-files/* $(OUT)/2nd-init-files
	cp -p $(SS_COMMON)/flags/* $(OUT)/install-files/etc/safestrap/flags/
	cp -p $(SS_COMMON)/bbx $(OUT)/install-files/etc/safestrap/bbx
	cp -p $(SS_COMMON)/busybox $(OUT)/APP/busybox
	cp -p $(SS_COMMON)/lfs $(TARGET_RECOVERY_ROOT_OUT)/sbin/lfs
	cp -p $(SS_COMMON)/devices/common/splashscreen-res/$(DEVICE_RESOLUTION)/* $(OUT)/install-files/etc/safestrap/res/
	# Call out to device-specific script
	$(SS_COMMON)/devices/$(SS_PRODUCT_MANUFACTURER)/$(TARGET_DEVICE)/build-safestrap.sh

LOCAL_GENERATED_SOURCES := $(TWRP_RES_GEN)
LOCAL_SRC_FILES := twrp $(TWRP_RES_GEN)
include $(BUILD_PREBUILT)
