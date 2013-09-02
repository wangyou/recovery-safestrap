LOCAL_PATH := $(call my-dir)
splash_local_path := $(LOCAL_PATH)

include $(CLEAR_VARS)

ifeq ($(TWRP_EVENT_LOGGING), true)
  LOCAL_CFLAGS += -D_EVENT_LOGGING
endif

splash_sources := \
    splashmenu.c \
    ui.c


LOCAL_MODULE := safestrapmenu
LOCAL_MODULE_TAGS := optional

LOCAL_SRC_FILES := $(splash_sources)

LOCAL_CFLAGS += -DMAX_ROWS=44 -DMAX_COLS=96


LOCAL_STATIC_LIBRARIES := \
	libminui_ss \
	libpixelflinger_static \
	libpng \
	libz \
	libstdc++ \
	libc \
	libcutils

LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_MODULE_CLASS := RECOVERY_EXECUTABLES
LOCAL_MODULE_PATH := $(TARGET_RECOVERY_OUT)/root/../../install-files/etc/safestrap

include $(BUILD_EXECUTABLE)

include $(call all-makefiles-under,$(splash_local_path))

