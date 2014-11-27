# macros to include all files with same extension
define all-files-under
$(patsubst ./%,%, \
  $(shell cd $(LOCAL_PATH) ; \
          find $(1) -name "$(2)" -and -not -name ".*") \
 )
endef

define all-files-under-except
$(patsubst ./%,%, \
  $(shell cd $(LOCAL_PATH) ; \
          find $(1) -name "$(2)" -and -not -name ".*" -and -not -path "$(3)/*") \
 )
endef

define files-under
$(patsubst ./%,%, \
  $(shell cd $(LOCAL_PATH) ; \
          find $(1) -name "$(2)" -and -not -name ".*" -and -depth 1) \
 )
endef

define cpp-files-under
$(call files-under,$(1),*.cpp)
endef

define c-files-under
$(call files-under,$(1),*.c)
endef

define all-cpp-files-under
$(call all-files-under,$(1),*.cpp)
endef

define all-c-files-under
$(call all-files-under,$(1),*.c)
endef

define all-c-files-under-except
$(call all-files-under,$(1),*.c,$(2))
endef

define all-cpp-files-under-except
$(call all-files-under-except,$(1),*.cpp,$(2))
endef

# module
LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := cocos2dx_static
LOCAL_MODULE_FILENAME := libcocos2d
LOCAL_SRC_FILES := $(call all-c-files-under-except,.,./platform) \
	$(call all-cpp-files-under-except,.,./platform) \
	$(call c-files-under,./platform) \
	$(call cpp-files-under,./platform) \
	$(call all-c-files-under,./platform/android) \
	$(call all-cpp-files-under,./platform/android) \
	$(call all-c-files-under,./platform/third_party) \
	$(call all-cpp-files-under,./platform/third_party)
LOCAL_C_INCLUDES := $(LOCAL_PATH) \
	$(LOCAL_PATH)/include \
	$(LOCAL_PATH)/kazmath/include \
    $(LOCAL_PATH)/platform \
	$(LOCAL_PATH)/platform/android \
    $(LOCAL_PATH)/platform/android/jni \
    $(LOCAL_PATH)/support \
    $(LOCAL_PATH)/support/aosp \
    $(LOCAL_PATH)/support/entities \
    $(LOCAL_PATH)/support/utils \
    $(LOCAL_PATH)/support/tinyxml2 \
    $(LOCAL_PATH)/support/yajl/include
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_C_INCLUDES)
LOCAL_LDLIBS := -lGLESv2 -llog -lz
LOCAL_EXPORT_LDLIBS := $(LOCAL_LDLIBS)
LOCAL_WHOLE_STATIC_LIBRARIES := cocos_libpng_static \
	cocos_jpeg_static \
	cocos_libxml2_static \
	cocos_libtiff_static \
	cocos_libwebp_static

# define the macro to compile through support/zip_support/ioapi.c
LOCAL_CFLAGS := -Wno-psabi -DUSE_FILE32API
LOCAL_EXPORT_CFLAGS := -Wno-psabi -DUSE_FILE32API

# compile
include $(BUILD_STATIC_LIBRARY)
$(call import-module,libjpeg)
$(call import-module,libpng)
$(call import-module,libtiff)
$(call import-module,libwebp)