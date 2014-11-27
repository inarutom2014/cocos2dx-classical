# macros to include all files with same extension
define all-files-under
$(patsubst ./%,%, \
  $(shell cd $(LOCAL_PATH) ; \
          find $(1) -name "$(2)" -and -not -name ".*") \
 )
endef

define all-cpp-files-under
$(call all-files-under,$(1),*.cpp)
endef

# module
LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := cocos_extension_static
LOCAL_MODULE_FILENAME := libextension
LOCAL_SRC_FILES := $(call all-cpp-files-under,.)
LOCAL_CFLAGS += -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -fexceptions
LOCAL_EXPORT_CFLAGS += -DCC_ENABLE_CHIPMUNK_INTEGRATION=1
LOCAL_CPPFLAGS += -DCC_ENABLE_CHIPMUNK_INTEGRATION=1
LOCAL_EXPORT_CPPFLAGS += -DCC_ENABLE_CHIPMUNK_INTEGRATION=1
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH) \
	$(LOCAL_PATH)/GUI/CCControlExtension \
	$(LOCAL_PATH)/GUI/CCScrollView \
	$(LOCAL_PATH)/network \
	$(LOCAL_PATH)/LocalStorage \
	$(LOCAL_PATH)/CocoStudio/Armature
LOCAL_WHOLE_STATIC_LIBRARIES := cocos2dx_static \
	cocosdenshion_static \
	cocos_curl_static \
	box2d_static \
	chipmunk_static
include $(BUILD_STATIC_LIBRARY)
$(call import-module,cocos2dx)
$(call import-module,CocosDenshion/android)
$(call import-module,cocos2dx/platform/third_party/android/prebuilt/libcurl)
$(call import-module,external/Box2D)
$(call import-module,external/chipmunk)